# Turkmen Calendar Vocabulary

[← Main page](../../README.md)

Turkmen and English names for months, weekdays, seasons, periods of the day, and time units. These datasets provide labels for calendar interfaces, date selectors, and language-learning tools.

## Files

All files contain JSON arrays encoded in UTF-8, with 36 records in total.

| File | Records | Contents |
| --- | ---: | --- |
| [`months.json`](months.json) | 12 | Months, ordered from January to December |
| [`weekdays.json`](weekdays.json) | 7 | Weekdays, ordered from Monday to Sunday |
| [`seasons.json`](seasons.json) | 4 | Spring, summer, autumn, and winter |
| [`day-periods.json`](day-periods.json) | 5 | Morning, noon, afternoon, evening, and night |
| [`time-units.json`](time-units.json) | 8 | Second, minute, hour, day, week, month, year, and century |

## JSON structure

Every record includes `tm` (the Turkmen label) and `en` (the English label). The identifier field depends on the file:

| Field | Type | Used in | Description |
| --- | --- | --- | --- |
| `number` | integer | `months.json` | Month number: `1` for January through `12` for December |
| `iso` | integer | `weekdays.json` | Weekday number: `1` for Monday through `7` for Sunday |
| `id` | string | Seasons, day periods, and time units | Lowercase English identifier, such as `spring`, `afternoon`, or `hour` |
| `tm` | string | All files | Turkmen display label |
| `en` | string | All files | English display label |

Example month record:

```json
{
  "number": 1,
  "tm": "Ýanwar",
  "en": "January"
}
```

Example time-unit record:

```json
{
  "id": "hour",
  "tm": "sagat",
  "en": "hour"
}
```

## Usage

Run these examples from the repository root.

Find the Turkmen name for Monday with `jq`:

```sh
jq -r '.[] | select(.iso == 1) | .tm' utils/calendar/weekdays.json
```

Load month labels in Python:

```python
import json
from pathlib import Path

path = Path("utils/calendar/months.json")
months = json.loads(path.read_text(encoding="utf-8"))
names_tm = {month["number"]: month["tm"] for month in months}

print(names_tm[1])  # Ýanwar
```

Preserve UTF-8 encoding and the supplied capitalization when displaying labels. Month, weekday, and season labels begin with capital letters; day-period and time-unit labels are lowercase.

## Scope and limitations

These files contain vocabulary only. They do not define date formats, abbreviations, plural forms, time-unit conversions, season boundaries, or clock-time ranges for day periods. Weekday numbering starts at Monday (`1`); adapt it when using APIs with a different numbering convention.

For holiday dates and observances, see the [holidays dataset](../holidays/README.md).

## Sources and contributions

This directory does not currently include source references or a retrieval date. Contributions should document sources for new entries and spelling or translation corrections. See the repository's [source guidelines](../../SOURCES.md) and [license](../../LICENSE).
