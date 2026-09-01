# Turkmenistan Holidays Dataset

[← Main page](../../README.md)

This directory contains a small JSON dataset of public holidays and observance days in Turkmenistan.

## File

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`holidays.json`](holidays.json) | JSON, UTF-8 | 29 | Fixed-date holidays and observances |

## JSON structure

The file contains an array of holiday records:

```json
{
  "name": "Täze ýyl",
  "month": 1,
  "day": 1,
  "type": "public_holiday",
  "day_off": true
}
```

Multi-day holidays use `start_day` and `end_day` instead of `day`:

```json
{
  "name": "Milli bahar baýramy",
  "month": 3,
  "start_day": 21,
  "end_day": 22,
  "type": "public_holiday",
  "day_off": true
}
```

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | Holiday or observance name in Turkmen |
| `month` | number | Month number, from `1` to `12` |
| `day` | number | Day of month for a single-day entry |
| `start_day` | number | First day of a multi-day entry |
| `end_day` | number | Last day of a multi-day entry |
| `type` | string | `public_holiday` or `observance` |
| `day_off` | boolean | Whether the date is listed as a day off |

## Usage

List public holidays with `jq`:

```sh
jq '.[] | select(.type == "public_holiday")' utils/holidays/holidays.json
```

Find entries in March:

```sh
jq '.[] | select(.month == 3)' utils/holidays/holidays.json
```

## Data quality and limitations

This dataset currently stores fixed month/day entries. It may not fully represent moving religious holidays, substitute days off, one-time government decisions, or future legal changes. Verify dates against an official current source before using the data for payroll, legal compliance, travel planning, or production calendars.

## Sources and contributions

This directory does not currently include a dedicated source list. Contributions should document the legal or official source, access date, and whether a holiday is a non-working day for the relevant year.
