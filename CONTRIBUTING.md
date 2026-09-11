Thank you for your interest in contributing!


The goal of this project is to collect, structure, and maintain useful public data related to Turkmenistan and the Turkmen language in open and reusable formats.


Contributions are welcome.


What You Can Contribute

You can contribute:

* New datasets
* Missing records
* Corrections to existing data
* Better or additional data sources
* JSON, CSV, SQL, JSONL, or Parquet exports
* Documentation improvements
* Data validation scripts
* Typo and transliteration fixes

If you want to add a large dataset or significantly change an existing schema, please open an issue first.

Data Requirements

Data added to this repository should be:

* Verifiable
* Structured
* Consistent
* Useful for public use
* Legally redistributable

Do not submit data copied from a source that prohibits redistribution.

Personal, private, confidential, or sensitive information must not be added.

Sources

Every dataset should have a clear source whenever possible.

When adding or modifying data, include information such as:

* Source name
* Source URL, if available
* Publication or organization
* Retrieval date, when relevant
* License or usage terms, if known

If multiple sources were used, list all important sources.

Avoid adding information that cannot reasonably be verified.

Data Accuracy

Do not silently “correct” source data based only on assumptions.

If a source contains a possible mistake:

1. Verify it using another reliable source when possible.
2. Correct it only when there is sufficient evidence.
3. Document significant corrections.

Historical names, alternative spellings, and transliterations should be preserved when they are useful rather than simply replaced.

Turkmen Text

Use UTF-8 encoding.

Use the modern Turkmen Latin alphabet where appropriate:

````
A B Ç D E Ä F G H I J Ž K L M N Ň O Ö P R S Ş T U Ü W Y Ý Z
a b ç d e ä f g h i j ž k l m n ň o ö p r s ş t u ü w y ý z
````
Do not replace Turkmen characters with ASCII equivalents unless a specific dataset or field is intended for normalized/searchable text.

For example:
````
Aşgabat
Daşoguz
Türkmenistan
Magtymguly Pyragy
````

should not be changed to:

````
Ashgabat
Dashoguz
Turkmenistan
Magtymguly Pyragy
````
unless the field explicitly represents an English name, transliteration, alias, or normalized value.

Data Formats

When a dataset is available in multiple formats, the records should represent the same underlying data.

For example:

````
data/
├── dataset.json
├── dataset.csv
├── dataset.jsonl
└── sql/
    ├── mysql.sql
    ├── postgresql.sql
    └── sqlite.sql
````


Keep field names and values consistent across formats whenever possible.

JSON

JSON files must be valid JSON.

Use consistent field names and structures.

Example:

````
{
  "name": "Aşgabat",
  "type": "city",
  "country": "TM"
}
````
Avoid unnecessary changes to formatting or field ordering when modifying unrelated records.

CSV

CSV files should:

* Use UTF-8
* Include a header row
* Use consistent column ordering
* Properly escape commas, quotes, and newlines

SQL

SQL files should remain compatible with the database version documented by the dataset.

When modifying schemas:

* Avoid unnecessary database-specific features.
* Keep identifiers consistent.
* Preserve UTF-8 text correctly.
* Update other supported SQL formats when necessary.

Schema changes should be explained in the pull request.

Adding a New Dataset

Before adding a new dataset, consider whether it fits the scope of tm-data.

A new dataset should preferably include documentation describing:

````
Name
Description
Source
Last updated
License / attribution
Available formats
Important fields
`````
Large datasets or new categories should be proposed in an issue before implementation.

Pull Requests

Keep pull requests focused.

A pull request should clearly explain:

* What data was added or changed
* Why the change is necessary
* Where the data came from
* How the data was verified

If possible, include links to the original sources.

Avoid combining unrelated datasets or corrections in a single pull request.

Commit Messages

Clear commit messages are preferred.

Examples:
````
data: add missing Ahal settlements
data: correct Daşoguz district name
data: add Magtymguly poetry dataset
fix: correct invalid JSON records
docs: document settlement sources
chore: regenerate SQL exports
````
Reporting Incorrect Data

If you find incorrect or outdated data, please open an issue or submit a pull request.

Include:

* The incorrect record
* The proposed correction
* A source supporting the correction

This helps keep the dataset verifiable and trustworthy.

Generated Files

If a file is generated from another source file in this repository, avoid editing the generated file manually.

Modify the source data and regenerate the derived files instead.

When possible, the repository should have one clearly defined source of truth for each dataset.

License

By contributing, you confirm that the submitted data can legally be included and redistributed by this project.

Contributions will be distributed under the license specified by the repository or the individual dataset.