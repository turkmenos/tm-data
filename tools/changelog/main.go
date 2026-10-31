package main

import (
	"bytes"
	"encoding/csv"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"unicode/utf8"
)

const (
	schemaVersion   = "1.0.0"
	defaultConfig   = "tools/changelog/config.json"
	defaultLog      = "CHANGELOG.md"
	defaultChanges  = "changes"
	entriesMarker   = "<!-- changelog:entries -->"
	entryEndMarker  = "<!-- changelog:end -->"
	maxListedIDs    = 20
	statusAdded     = "added"
	statusRemoved   = "removed"
	statusChanged   = "changed"
	identityContent = "content"
)

type config struct {
	Version   int              `json:"version"`
	Resources []resourceConfig `json:"resources"`
}

type resourceConfig struct {
	Pattern string   `json:"pattern"`
	Records string   `json:"records"`
	Map     bool     `json:"map"`
	Key     []string `json:"key"`
	matcher *regexp.Regexp
}

type catalog struct {
	Datasets []catalogDataset `json:"datasets"`
}

type catalogDataset struct {
	ID            string            `json:"id"`
	Title         string            `json:"title"`
	Version       string            `json:"version"`
	Formats       []string          `json:"formats"`
	Documentation []string          `json:"documentation"`
	Provenance    json.RawMessage   `json:"provenance"`
	Resources     []catalogResource `json:"resources"`
}

type catalogResource struct {
	Path    string `json:"path"`
	Format  string `json:"format"`
	Version string `json:"version"`
}

type report struct {
	SchemaVersion string          `json:"schema_version"`
	From          revision        `json:"from"`
	To            revision        `json:"to"`
	Summary       summary         `json:"summary"`
	Datasets      []datasetChange `json:"datasets"`
}

type revision struct {
	Revision string `json:"revision"`
	Commit   string `json:"commit"`
	Date     string `json:"date"`
}

type summary struct {
	DatasetsChanged int    `json:"datasets_changed"`
	Changes         counts `json:"changes"`
	Breaking        bool   `json:"breaking"`
}

type counts struct {
	Added    int `json:"added"`
	Modified int `json:"modified"`
	Deleted  int `json:"deleted"`
}

type datasetChange struct {
	Dataset     string          `json:"dataset"`
	Title       string          `json:"title"`
	Status      string          `json:"status"`
	FromVersion *string         `json:"from_version"`
	ToVersion   *string         `json:"to_version"`
	Changes     counts          `json:"changes"`
	Resources   resourceChanges `json:"resources"`
	Formats     listChange      `json:"formats"`
	Records     []recordChange  `json:"records"`
	Schema      []schemaChange  `json:"schema"`
	Metadata    []string        `json:"metadata"`
	Breaking    []string        `json:"breaking"`
}

type resourceChanges struct {
	Added    []string `json:"added"`
	Removed  []string `json:"removed"`
	Modified []string `json:"modified"`
}

type listChange struct {
	Added   []string `json:"added"`
	Removed []string `json:"removed"`
}

type recordChange struct {
	Path        string   `json:"path"`
	Identity    string   `json:"identity"`
	Added       int      `json:"added"`
	Modified    int      `json:"modified"`
	Deleted     int      `json:"deleted"`
	AddedIDs    []string `json:"added_ids"`
	ModifiedIDs []string `json:"modified_ids"`
	DeletedIDs  []string `json:"deleted_ids"`
	Note        string   `json:"note,omitempty"`
}

type schemaChange struct {
	Path          string   `json:"path"`
	AddedFields   []string `json:"added_fields"`
	RemovedFields []string `json:"removed_fields"`
}

// snapshot is the parsed content of one data file at one revision.
type snapshot struct {
	fields   map[string]bool
	records  map[string]string // identity -> canonical JSON (keyed)
	content  map[string]int    // canonical JSON -> occurrences (unkeyed)
	keyed    bool
	metadata map[string]string // top-level fields outside the records collection
	note     string
}

type repository struct {
	dir string
}

func main() {
	from := flag.String("from", "", "base Git revision (required)")
	to := flag.String("to", "HEAD", "target Git revision")
	format := flag.String("format", "json", "output format: json or markdown")
	output := flag.String("output", "", "write the report to this file instead of standard output")
	changelog := flag.Bool("changelog", false, "add the entry to CHANGELOG.md and write changes/<from>..<to>.json")
	configPath := flag.String("config", defaultConfig, "record identity configuration")
	flag.Parse()
	if *from == "" || flag.NArg() != 0 || (*format != "json" && *format != "markdown") {
		fmt.Fprintln(os.Stderr, "usage: changelog --from <rev> [--to <rev>] [--format json|markdown] [--output path] [--changelog]")
		os.Exit(2)
	}

	repo := repository{}
	root, err := repo.git("rev-parse", "--show-toplevel")
	if err == nil {
		repo.dir = strings.TrimSpace(string(root))
		var cfg config
		cfg, err = loadConfig(filepath.Join(repo.dir, *configPath))
		if err == nil {
			var value report
			value, err = build(repo, cfg, *from, *to)
			if err == nil {
				err = emit(repo.dir, value, *format, *output, *changelog)
			}
		}
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
}

func emit(root string, value report, format, output string, changelog bool) error {
	if changelog {
		encoded, err := renderJSON(value)
		if err != nil {
			return err
		}
		name := fmt.Sprintf("%s..%s.json", short(value.From.Commit), short(value.To.Commit))
		if err := os.MkdirAll(filepath.Join(root, defaultChanges), 0o755); err != nil {
			return err
		}
		if err := os.WriteFile(filepath.Join(root, defaultChanges, name), encoded, 0o644); err != nil {
			return err
		}
		if err := updateChangelog(filepath.Join(root, defaultLog), value); err != nil {
			return err
		}
		fmt.Printf("Updated %s and %s/%s\n", defaultLog, defaultChanges, name)
		return nil
	}
	var encoded []byte
	var err error
	if format == "markdown" {
		encoded = []byte(renderMarkdown(value))
	} else if encoded, err = renderJSON(value); err != nil {
		return err
	}
	if output == "" {
		_, err = os.Stdout.Write(encoded)
		return err
	}
	if err := os.MkdirAll(filepath.Dir(output), 0o755); err != nil {
		return err
	}
	return os.WriteFile(output, encoded, 0o644)
}

func (r repository) git(args ...string) ([]byte, error) {
	cmd := exec.Command("git", args...)
	cmd.Dir = r.dir
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	out, err := cmd.Output()
	if err != nil {
		return nil, fmt.Errorf("git %s: %v: %s", strings.Join(args, " "), err, strings.TrimSpace(stderr.String()))
	}
	return out, nil
}

func (r repository) resolve(rev string) (revision, error) {
	out, err := r.git("rev-parse", "--verify", "--quiet", rev+"^{commit}")
	if err != nil {
		return revision{}, fmt.Errorf("unknown revision %q", rev)
	}
	commit := strings.TrimSpace(string(out))
	date, err := r.git("show", "-s", "--format=%cs", commit)
	if err != nil {
		return revision{}, err
	}
	return revision{Revision: rev, Commit: commit, Date: strings.TrimSpace(string(date))}, nil
}

// blob returns the Git object ID of a file at a commit, or ok=false when the
// file does not exist there.
func (r repository) blob(commit, path string) (string, bool, error) {
	out, err := r.git("ls-tree", "--format=%(objecttype) %(objectname)", commit, "--", path)
	if err != nil {
		return "", false, err
	}
	fields := strings.Fields(string(out))
	if len(fields) != 2 || fields[0] != "blob" {
		return "", false, nil
	}
	return fields[1], true, nil
}

// readFile returns the file at a commit, or ok=false when it does not exist there.
func (r repository) readFile(commit, path string) ([]byte, bool, error) {
	if _, err := r.git("cat-file", "-e", commit+":"+path); err != nil {
		return nil, false, nil
	}
	data, err := r.git("cat-file", "blob", commit+":"+path)
	return data, err == nil, err
}

func loadConfig(path string) (config, error) {
	var result config
	data, err := os.ReadFile(path)
	if err != nil {
		return result, err
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&result); err != nil {
		return result, fmt.Errorf("%s: %w", path, err)
	}
	if result.Version != 1 {
		return result, fmt.Errorf("%s: unsupported config version %d", path, result.Version)
	}
	for index := range result.Resources {
		item := &result.Resources[index]
		if item.Pattern == "" {
			return result, fmt.Errorf("%s: resource %d has no pattern", path, index+1)
		}
		if item.Map && len(item.Key) > 0 {
			return result, fmt.Errorf("%s: %s: map collections are keyed by their object keys; remove key", path, item.Pattern)
		}
		item.matcher = globPattern(item.Pattern)
	}
	return result, nil
}

// globPattern converts a slash-separated glob to a regular expression. "*"
// matches within one path segment and "**" matches across segments.
func globPattern(pattern string) *regexp.Regexp {
	var builder strings.Builder
	builder.WriteString("^")
	for index := 0; index < len(pattern); index++ {
		switch {
		case strings.HasPrefix(pattern[index:], "**"):
			builder.WriteString(".*")
			index++
		case pattern[index] == '*':
			builder.WriteString("[^/]*")
		case pattern[index] == '?':
			builder.WriteString("[^/]")
		default:
			builder.WriteString(regexp.QuoteMeta(pattern[index : index+1]))
		}
	}
	builder.WriteString("$")
	return regexp.MustCompile(builder.String())
}

func (c config) lookup(path string) *resourceConfig {
	for index := range c.Resources {
		if c.Resources[index].matcher.MatchString(path) {
			return &c.Resources[index]
		}
	}
	return nil
}

func build(repo repository, cfg config, fromRev, toRev string) (report, error) {
	from, err := repo.resolve(fromRev)
	if err != nil {
		return report{}, err
	}
	to, err := repo.resolve(toRev)
	if err != nil {
		return report{}, err
	}
	oldCatalog, err := readCatalog(repo, from.Commit)
	if err != nil {
		return report{}, err
	}
	newCatalog, err := readCatalog(repo, to.Commit)
	if err != nil {
		return report{}, err
	}

	result := report{SchemaVersion: schemaVersion, From: from, To: to, Datasets: []datasetChange{}}
	oldByID := indexDatasets(oldCatalog)
	newByID := indexDatasets(newCatalog)
	ids := make([]string, 0, len(oldByID)+len(newByID))
	for id := range oldByID {
		ids = append(ids, id)
	}
	for id := range newByID {
		if _, exists := oldByID[id]; !exists {
			ids = append(ids, id)
		}
	}
	sort.Strings(ids)

	for _, id := range ids {
		change, changed, err := compareDataset(repo, cfg, from.Commit, to.Commit, oldByID[id], newByID[id])
		if err != nil {
			return report{}, err
		}
		if !changed {
			continue
		}
		result.Datasets = append(result.Datasets, change)
		result.Summary.DatasetsChanged++
		result.Summary.Changes.Added += change.Changes.Added
		result.Summary.Changes.Modified += change.Changes.Modified
		result.Summary.Changes.Deleted += change.Changes.Deleted
		if len(change.Breaking) > 0 {
			result.Summary.Breaking = true
		}
	}
	return result, nil
}

func readCatalog(repo repository, commit string) (catalog, error) {
	var result catalog
	data, ok, err := repo.readFile(commit, "catalog.json")
	if err != nil {
		return result, err
	}
	if !ok {
		return result, fmt.Errorf("catalog.json does not exist at %s; choose a later revision", short(commit))
	}
	if err := json.Unmarshal(data, &result); err != nil {
		return result, fmt.Errorf("catalog.json at %s: %w", short(commit), err)
	}
	return result, nil
}

func indexDatasets(value catalog) map[string]*catalogDataset {
	result := make(map[string]*catalogDataset, len(value.Datasets))
	for index := range value.Datasets {
		result[value.Datasets[index].ID] = &value.Datasets[index]
	}
	return result
}

func compareDataset(repo repository, cfg config, fromCommit, toCommit string, old, new *catalogDataset) (datasetChange, bool, error) {
	change := datasetChange{
		Records:   []recordChange{},
		Schema:    []schemaChange{},
		Metadata:  []string{},
		Breaking:  []string{},
		Resources: resourceChanges{Added: []string{}, Removed: []string{}, Modified: []string{}},
		Formats:   listChange{Added: []string{}, Removed: []string{}},
	}
	var oldResources, newResources []catalogResource
	switch {
	case old == nil:
		change.Dataset, change.Title, change.Status = new.ID, new.Title, statusAdded
		change.ToVersion = &new.Version
		newResources = new.Resources
	case new == nil:
		change.Dataset, change.Title, change.Status = old.ID, old.Title, statusRemoved
		change.FromVersion = &old.Version
		oldResources = old.Resources
		change.Breaking = append(change.Breaking, "dataset removed")
	default:
		change.Dataset, change.Title, change.Status = new.ID, new.Title, statusChanged
		change.FromVersion, change.ToVersion = &old.Version, &new.Version
		oldResources, newResources = old.Resources, new.Resources
		change.Metadata = append(change.Metadata, compareMetadata(old, new)...)
	}

	var oldFormats, newFormats []string
	if old != nil {
		oldFormats = old.Formats
	}
	if new != nil {
		newFormats = new.Formats
	}
	change.Formats.Added, change.Formats.Removed = diffLists(oldFormats, newFormats)
	for _, format := range change.Formats.Removed {
		change.Breaking = append(change.Breaking, fmt.Sprintf("format %s no longer provided", format))
	}

	oldMap := make(map[string]catalogResource, len(oldResources))
	for _, item := range oldResources {
		oldMap[item.Path] = item
	}
	newMap := make(map[string]catalogResource, len(newResources))
	for _, item := range newResources {
		newMap[item.Path] = item
	}
	var paths []string
	for path := range oldMap {
		paths = append(paths, path)
	}
	for path := range newMap {
		if _, exists := oldMap[path]; !exists {
			paths = append(paths, path)
		}
	}
	sort.Strings(paths)

	for _, path := range paths {
		before, listedBefore := oldMap[path]
		after, listedAfter := newMap[path]
		// File contents in Git are authoritative; the catalog of an older
		// revision may be stale and omit files that already existed.
		blobBefore, hadBefore, err := repo.blob(fromCommit, path)
		if err != nil {
			return change, false, err
		}
		blobAfter, hasAfter, err := repo.blob(toCommit, path)
		if err != nil {
			return change, false, err
		}
		if !listedBefore && hadBefore {
			change.Metadata = append(change.Metadata, path+": already present but missing from the previous catalog")
		}
		if !listedAfter && hasAfter {
			change.Metadata = append(change.Metadata, path+": still present but no longer listed in the catalog")
		}
		switch {
		case !hadBefore && !hasAfter:
			continue
		case !hadBefore:
			change.Resources.Added = append(change.Resources.Added, path)
		case !hasAfter:
			change.Resources.Removed = append(change.Resources.Removed, path)
			change.Breaking = append(change.Breaking, fmt.Sprintf("resource %s removed", path))
		case blobBefore != blobAfter:
			change.Resources.Modified = append(change.Resources.Modified, path)
		default:
			continue
		}

		rc := cfg.lookup(path)
		format := after.Format
		if !listedAfter {
			format = before.Format
		}
		if format != "json" && format != "csv" {
			continue
		}
		oldSnap, err := loadSnapshot(repo, fromCommit, path, format, rc, hadBefore)
		if err != nil {
			return change, false, err
		}
		newSnap, err := loadSnapshot(repo, toCommit, path, format, rc, hasAfter)
		if err != nil {
			return change, false, err
		}

		if added, removed := diffSets(oldSnap.fields, newSnap.fields); hadBefore && hasAfter && (len(added) > 0 || len(removed) > 0) {
			change.Schema = append(change.Schema, schemaChange{Path: path, AddedFields: added, RemovedFields: removed})
			for _, field := range removed {
				change.Breaking = append(change.Breaking, fmt.Sprintf("field %q removed from %s", field, path))
			}
		}
		if hadBefore && hasAfter {
			change.Metadata = append(change.Metadata, compareFileMetadata(path, oldSnap.metadata, newSnap.metadata)...)
		}
		if rc == nil {
			continue
		}
		record := diffRecords(path, rc, oldSnap, newSnap)
		if record.Added+record.Modified+record.Deleted == 0 && record.Note == "" {
			continue
		}
		change.Records = append(change.Records, record)
		change.Changes.Added += record.Added
		change.Changes.Modified += record.Modified
		change.Changes.Deleted += record.Deleted
		if record.Identity != identityContent && record.Deleted > 0 && hasAfter {
			change.Breaking = append(change.Breaking, fmt.Sprintf("%d record(s) with stable identifiers deleted from %s", record.Deleted, path))
		}
	}

	resourcesChanged := len(change.Resources.Added)+len(change.Resources.Removed)+len(change.Resources.Modified) > 0
	if change.Status == statusChanged && old.Version != new.Version && !resourcesChanged {
		change.Metadata = append(change.Metadata, "version identifier changed without any file content change (catalog listing or fingerprint method changed)")
	}
	changed := change.Status != statusChanged || old.Version != new.Version || len(change.Metadata) > 0 ||
		len(change.Formats.Added) > 0 || len(change.Formats.Removed) > 0
	return change, changed, nil
}

func compareMetadata(old, new *catalogDataset) []string {
	var result []string
	if old.Title != new.Title {
		result = append(result, fmt.Sprintf("title changed from %q to %q", old.Title, new.Title))
	}
	added, removed := diffLists(old.Documentation, new.Documentation)
	for _, path := range added {
		result = append(result, "documentation added: "+path)
	}
	for _, path := range removed {
		result = append(result, "documentation removed: "+path)
	}
	if canonical(old.Provenance) != canonical(new.Provenance) {
		result = append(result, "provenance references or note changed")
	}
	return result
}

func compareFileMetadata(path string, old, new map[string]string) []string {
	var keys []string
	for key := range old {
		keys = append(keys, key)
	}
	for key := range new {
		if _, exists := old[key]; !exists {
			keys = append(keys, key)
		}
	}
	sort.Strings(keys)
	var result []string
	for _, key := range keys {
		before, hadBefore := old[key]
		after, hasAfter := new[key]
		switch {
		case !hadBefore:
			result = append(result, fmt.Sprintf("%s: top-level field %q added", path, key))
		case !hasAfter:
			result = append(result, fmt.Sprintf("%s: top-level field %q removed", path, key))
		case before != after:
			result = append(result, fmt.Sprintf("%s: top-level field %q changed", path, key))
		}
	}
	return result
}

func canonical(raw json.RawMessage) string {
	if len(raw) == 0 {
		return ""
	}
	var value any
	if err := json.Unmarshal(raw, &value); err != nil {
		return string(raw)
	}
	encoded, _ := json.Marshal(value)
	return string(encoded)
}

func loadSnapshot(repo repository, commit, path, format string, rc *resourceConfig, exists bool) (snapshot, error) {
	result := snapshot{fields: map[string]bool{}, records: map[string]string{}, content: map[string]int{}, metadata: map[string]string{}}
	if rc != nil {
		result.keyed = rc.Map || len(rc.Key) > 0
	}
	if !exists {
		return result, nil
	}
	data, ok, err := repo.readFile(commit, path)
	if err != nil || !ok {
		return result, err
	}
	if !utf8.Valid(data) {
		result.note = fmt.Sprintf("not valid UTF-8 at %s", short(commit))
		result.keyed = false
		return result, nil
	}
	if parseErr := parseSnapshot(&result, data, format, rc); parseErr != nil {
		result = snapshot{fields: map[string]bool{}, records: map[string]string{}, content: map[string]int{}, metadata: map[string]string{}}
		result.note = fmt.Sprintf("records could not be read at %s: %v", short(commit), parseErr)
	}
	return result, nil
}

func parseSnapshot(result *snapshot, data []byte, format string, rc *resourceConfig) error {
	if format == "csv" {
		return parseCSV(result, data, rc)
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.UseNumber()
	var value any
	if err := decoder.Decode(&value); err != nil {
		return err
	}
	if rc != nil && rc.Records != "" {
		object, ok := value.(map[string]any)
		if !ok {
			return fmt.Errorf("expected an object with %q", rc.Records)
		}
		collection, exists := object[rc.Records]
		if !exists {
			return fmt.Errorf("missing %q", rc.Records)
		}
		for key, item := range object {
			if key != rc.Records {
				result.metadata[key] = encode(item)
			}
		}
		value = collection
	}

	if rc != nil && rc.Map {
		object, ok := value.(map[string]any)
		if !ok {
			return errors.New("expected an object of records")
		}
		for key, item := range object {
			collectFields(result, item)
			result.records[key] = encode(item)
		}
		return nil
	}

	items, ok := value.([]any)
	if !ok {
		if rc == nil {
			return nil // not a record collection; file-level change only
		}
		return errors.New("expected an array of records")
	}
	var keys []string
	if rc != nil {
		keys = rc.Key
	}
	return addItems(result, items, keys)
}

func parseCSV(result *snapshot, data []byte, rc *resourceConfig) error {
	reader := csv.NewReader(bytes.NewReader(data))
	header, err := reader.Read()
	if err != nil {
		return err
	}
	var items []any
	for {
		row, err := reader.Read()
		if errors.Is(err, io.EOF) {
			break
		}
		if err != nil {
			return err
		}
		item := make(map[string]any, len(header))
		for index, name := range header {
			item[name] = row[index]
		}
		items = append(items, item)
	}
	for _, name := range header {
		result.fields[name] = true
	}
	var keys []string
	if rc != nil {
		keys = rc.Key
	}
	return addItems(result, items, keys)
}

func addItems(result *snapshot, items []any, keys []string) error {
	for _, item := range items {
		collectFields(result, item)
		result.content[encode(item)]++
	}
	if len(keys) == 0 {
		result.keyed = false
		return nil
	}
	for _, item := range items {
		object, ok := item.(map[string]any)
		if !ok {
			return stableKeyFallback(result, "records are not objects")
		}
		parts := make([]string, 0, len(keys))
		for _, key := range keys {
			value, exists := object[key]
			if !exists || value == nil {
				return stableKeyFallback(result, fmt.Sprintf("a record has no %q", key))
			}
			if text, isText := value.(string); isText {
				parts = append(parts, text)
			} else {
				parts = append(parts, encode(value))
			}
		}
		id := strings.Join(parts, " / ")
		if _, duplicate := result.records[id]; duplicate {
			return stableKeyFallback(result, fmt.Sprintf("identifier %q is not unique", id))
		}
		result.records[id] = encode(item)
	}
	return nil
}

func stableKeyFallback(result *snapshot, reason string) error {
	result.keyed = false
	result.records = map[string]string{}
	result.note = "stable identifiers unavailable (" + reason + "); compared by content"
	return nil
}

func collectFields(result *snapshot, item any) {
	if object, ok := item.(map[string]any); ok {
		for key := range object {
			result.fields[key] = true
		}
	}
}

func diffRecords(path string, rc *resourceConfig, old, new snapshot) recordChange {
	change := recordChange{Path: path, Identity: identityContent, AddedIDs: []string{}, ModifiedIDs: []string{}, DeletedIDs: []string{}}
	notes := uniqueStrings(old.note, new.note)
	change.Note = strings.Join(notes, "; ")

	if old.keyed && new.keyed {
		if rc.Map {
			change.Identity = "object key"
		} else {
			change.Identity = "key: " + strings.Join(rc.Key, ", ")
		}
		for id, value := range new.records {
			before, exists := old.records[id]
			switch {
			case !exists:
				change.Added++
				change.AddedIDs = append(change.AddedIDs, id)
			case before != value:
				change.Modified++
				change.ModifiedIDs = append(change.ModifiedIDs, id)
			}
		}
		for id := range old.records {
			if _, exists := new.records[id]; !exists {
				change.Deleted++
				change.DeletedIDs = append(change.DeletedIDs, id)
			}
		}
		change.AddedIDs = limitIDs(change.AddedIDs)
		change.ModifiedIDs = limitIDs(change.ModifiedIDs)
		change.DeletedIDs = limitIDs(change.DeletedIDs)
		return change
	}

	for value, count := range new.content {
		if extra := count - old.content[value]; extra > 0 {
			change.Added += extra
		}
	}
	for value, count := range old.content {
		if missing := count - new.content[value]; missing > 0 {
			change.Deleted += missing
		}
	}
	if change.Added+change.Deleted > 0 {
		change.Note = strings.Join(uniqueStrings(change.Note, "without stable identifiers, edited records appear as one deletion and one addition"), "; ")
	}
	return change
}

func limitIDs(ids []string) []string {
	sort.Strings(ids)
	if len(ids) > maxListedIDs {
		return ids[:maxListedIDs]
	}
	return ids
}

func uniqueStrings(values ...string) []string {
	var result []string
	seen := map[string]bool{}
	for _, value := range values {
		if value != "" && !seen[value] {
			seen[value] = true
			result = append(result, value)
		}
	}
	return result
}

func diffLists(old, new []string) ([]string, []string) {
	return diffSets(toSet(old), toSet(new))
}

func toSet(values []string) map[string]bool {
	result := make(map[string]bool, len(values))
	for _, value := range values {
		result[value] = true
	}
	return result
}

func diffSets(old, new map[string]bool) ([]string, []string) {
	added, removed := []string{}, []string{}
	for value := range new {
		if !old[value] {
			added = append(added, value)
		}
	}
	for value := range old {
		if !new[value] {
			removed = append(removed, value)
		}
	}
	sort.Strings(added)
	sort.Strings(removed)
	return added, removed
}

func encode(value any) string {
	encoded, err := json.Marshal(value)
	if err != nil {
		return fmt.Sprint(value)
	}
	return string(encoded)
}

func short(commit string) string {
	if len(commit) > 12 {
		return commit[:12]
	}
	return commit
}

func shortVersion(version *string) string {
	if version == nil {
		return "none"
	}
	if digest := strings.TrimPrefix(*version, "sha256:"); digest != *version && len(digest) > 12 {
		return "sha256:" + digest[:12]
	}
	return *version
}

func renderJSON(value report) ([]byte, error) {
	var buffer bytes.Buffer
	encoder := json.NewEncoder(&buffer)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(value); err != nil {
		return nil, err
	}
	return buffer.Bytes(), nil
}

func plural(count int, singular string) string {
	if count == 1 {
		return fmt.Sprintf("%d %s", count, singular)
	}
	return fmt.Sprintf("%d %ss", count, singular)
}

func rangeMarker(value report) string {
	return fmt.Sprintf("<!-- changelog:range %s..%s -->", value.From.Commit, value.To.Commit)
}

func renderMarkdown(value report) string {
	var b strings.Builder
	fmt.Fprintf(&b, "%s\n## %s · `%s`…`%s`\n\n", rangeMarker(value), value.To.Date, short(value.From.Commit), short(value.To.Commit))
	if len(value.Datasets) == 0 {
		b.WriteString("No dataset changes.\n\n")
		return b.String()
	}
	s := value.Summary.Changes
	fmt.Fprintf(&b, "%s changed: %d added, %d modified, %d deleted record(s).", plural(value.Summary.DatasetsChanged, "dataset"), s.Added, s.Modified, s.Deleted)
	if value.Summary.Breaking {
		b.WriteString(" **Contains breaking changes.**")
	}
	b.WriteString("\n\n")

	for _, item := range value.Datasets {
		fmt.Fprintf(&b, "### %s (`%s`)\n\n", item.Title, item.Dataset)
		switch item.Status {
		case statusAdded:
			fmt.Fprintf(&b, "New dataset, version `%s`.\n\n", shortVersion(item.ToVersion))
		case statusRemoved:
			fmt.Fprintf(&b, "Dataset removed; last version `%s`.\n\n", shortVersion(item.FromVersion))
		default:
			fmt.Fprintf(&b, "Version `%s` → `%s`.\n\n", shortVersion(item.FromVersion), shortVersion(item.ToVersion))
		}

		var added, changed, removed []string
		for _, record := range item.Records {
			if record.Added > 0 {
				added = append(added, fmt.Sprintf("%s in `%s`", plural(record.Added, "record"), record.Path))
			}
			if record.Modified > 0 {
				changed = append(changed, fmt.Sprintf("%s updated in `%s`", plural(record.Modified, "record"), record.Path))
			}
			if record.Deleted > 0 {
				removed = append(removed, fmt.Sprintf("%s from `%s`", plural(record.Deleted, "record"), record.Path))
			}
			if record.Note != "" {
				changed = append(changed, fmt.Sprintf("Note for `%s`: %s", record.Path, record.Note))
			}
		}
		for _, path := range item.Resources.Added {
			added = append(added, fmt.Sprintf("File `%s`", path))
		}
		for _, format := range item.Formats.Added {
			added = append(added, "Format "+format)
		}
		tracked := map[string]bool{}
		for _, record := range item.Records {
			tracked[record.Path] = true
		}
		for _, path := range item.Resources.Modified {
			if !tracked[path] {
				changed = append(changed, fmt.Sprintf("File `%s` updated", path))
			}
		}
		for _, schema := range item.Schema {
			if len(schema.AddedFields) > 0 {
				changed = append(changed, fmt.Sprintf("Fields added to `%s`: %s", schema.Path, codeList(schema.AddedFields)))
			}
			if len(schema.RemovedFields) > 0 {
				changed = append(changed, fmt.Sprintf("Fields removed from `%s`: %s", schema.Path, codeList(schema.RemovedFields)))
			}
		}
		for _, note := range item.Metadata {
			changed = append(changed, "Metadata: "+note)
		}
		for _, path := range item.Resources.Removed {
			removed = append(removed, fmt.Sprintf("File `%s`", path))
		}
		for _, format := range item.Formats.Removed {
			removed = append(removed, "Format "+format)
		}
		writeSection(&b, "Added", added)
		writeSection(&b, "Changed", changed)
		writeSection(&b, "Removed", removed)
		writeSection(&b, "Breaking changes", item.Breaking)
	}
	return b.String()
}

func writeSection(b *strings.Builder, title string, lines []string) {
	if len(lines) == 0 {
		return
	}
	fmt.Fprintf(b, "#### %s\n\n", title)
	for _, line := range lines {
		fmt.Fprintf(b, "- %s\n", line)
	}
	b.WriteString("\n")
}

func codeList(values []string) string {
	quoted := make([]string, len(values))
	for index, value := range values {
		quoted[index] = "`" + value + "`"
	}
	return strings.Join(quoted, ", ")
}

// updateChangelog inserts the entry for the report's range below the entries
// marker, replacing an existing entry for the same range.
func updateChangelog(path string, value report) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	text := string(data)
	markerIndex := strings.Index(text, entriesMarker)
	if markerIndex < 0 {
		return fmt.Errorf("%s has no %s marker", path, entriesMarker)
	}
	head := text[:markerIndex+len(entriesMarker)] + "\n\n"
	body := strings.TrimLeft(text[markerIndex+len(entriesMarker):], "\n")

	entry := renderMarkdown(value) + entryEndMarker + "\n\n"
	marker := rangeMarker(value)
	if start := strings.Index(body, marker); start >= 0 {
		end := strings.Index(body[start:], entryEndMarker)
		if end < 0 {
			return fmt.Errorf("%s: entry %s has no %s", path, marker, entryEndMarker)
		}
		end = start + end + len(entryEndMarker)
		body = body[:start] + entry + strings.TrimLeft(body[end:], "\n")
	} else {
		body = entry + body
	}
	return os.WriteFile(path, []byte(head+strings.TrimRight(body, "\n")+"\n"), 0o644)
}
