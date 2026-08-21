# English SQL Import Guide

[← Main page](../README.md) · [Türkmençe](../tm/README.md) · [Sources](SOURCES.md)

Choose your database, download the corresponding `import.sql` file, and import it directly.

## PostgreSQL

Download [`sql/postgresql/import.sql`](../sql/postgresql/import.sql), then run:

```sh
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f import.sql
```

## MySQL

Download [`sql/mysql/import.sql`](../sql/mysql/import.sql), then run:

```sh
mysql --default-character-set=utf8mb4 -u USER -p DATABASE_NAME < import.sql
```

The MySQL import file creates and selects the `tm_data` database automatically. It can also be executed directly in a server-level SQL editor.

## SQLite

Download [`sql/sqlite/import.sql`](../sql/sqlite/import.sql), then run:

```sh
sqlite3 tm-data.sqlite < import.sql
```

## SQL Server

Download [`sql/sqlserver/import.sql`](../sql/sqlserver/import.sql), then run:

```sh
sqlcmd -S SERVER -d DATABASE_NAME -C -i import.sql
```

## Search Examples

### PostgreSQL

```sql
SELECT * FROM find_region('Dashoguz');
```

### MySQL

```sql
CALL find_region('Dashoguz');
```

### SQL Server

```sql
SELECT * FROM dbo.find_region(N'Dashoguz');
```

Different spellings and aliases can resolve to the same canonical region:

```text
Daşoguz
Dashoguz
Dasoguz
Дашогуз
```

## Dataset

The dataset currently contains:

- **2,711** administrative and settlement records
- **7,494** aliases
- Administrative regions
- Districts
- Cities and towns
- Villages and rural settlements
- Alternative and historical names
- Search-ready aliases

Village and rural-council records combine legal compilations with OpenStreetMap-derived data. Records that have not been independently verified are marked as `verification_required` and should not be presented as an official government register.

For detailed information about data sources and verification, see [Sources](SOURCES.md).