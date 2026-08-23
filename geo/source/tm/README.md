# Türkmençe SQL import gollanmasy

[← Baş sahypa](../../README.md) · [English](../en/README.md) · [Çeşmeler](SOURCES.md)

Ulanylýan maglumatlar bazasyny saýlaň, degişli `import.sql` faýlyny ýükläň we göni maglumatlar bazaňyza import ediň.

## PostgreSQL

[`sql/postgresql/import.sql`](../../sql/postgresql/import.sql) faýlyny ýükläň we şu buýrugy işlediň:

```sh
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f import.sql
```

## MySQL

[`sql/mysql/import.sql`](../../sql/mysql/import.sql) faýlyny ýükläň we şu buýrugy işlediň:

```sh
mysql --default-character-set=utf8mb4 -u USER -p DATABASE_NAME < import.sql
```

MySQL import faýly `turkmenistan_geo` maglumatlar bazasyny awtomatik döredýär we saýlaýar. Faýly serwer derejesindäki SQL redaktorynda hem göni işledip bolýar.

## SQLite

[`sql/sqlite/import.sql`](../../sql/sqlite/import.sql) faýlyny ýükläň we şu buýrugy işlediň:

```sh
sqlite3 tm-data.sqlite < import.sql
```

## SQL Server

[`sql/sqlserver/import.sql`](../../sql/sqlserver/import.sql) faýlyny ýükläň we şu buýrugy işlediň:

```sh
sqlcmd -S SERVER -d DATABASE_NAME -C -i import.sql
```

## Gözleg mysallary

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

Dürli ýazuw görnüşleri we alternatiw atlar şol bir sebite degişli netijäni tapyp biler:

```text
Daşoguz
Dashoguz
Dasoguz
Дашогуз
```

## Maglumat toplumy

Maglumat toplumynda häzirki wagtda:

- **2 711** dolandyryş we ilatly ýer ýazgysy
- **7 494** alternatiw at (alias)
- Welaýatlar
- Etraplar
- Şäherler we şäherçeler
- Obalar we beýleki ilatly ýerler
- Alternatiw we taryhy atlar
- Gözleg üçin taýýarlanan alias maglumatlary

Oba we geňeşlik ýazgylarynyň bir bölegi hukuk çeşmeleri bilen OpenStreetMap maglumatlarynyň birleşdirilmegi arkaly taýýarlanyldy.

Doly tassyklanmadyk ýazgylar `verification_required` hökmünde bellenýär we resmi döwlet sanawy hökmünde görkezilmeli däldir.

Maglumatlaryň çeşmeleri we tassyklanyş ýagdaýy barada giňişleýin maglumat üçin [Çeşmeler](SOURCES.md) sahypasyna serediň.
