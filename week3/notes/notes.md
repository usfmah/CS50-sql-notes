# Lecture 3 - Writing - CS50's Introduction to Databases with SQL
Source: https://cs50.harvard.edu/sql/2024/notes/3/

## Table of Contents
- [Introduction](#introduction)
- [Database Schema](#database-schema)
- [Inserting Data](#inserting-data)
- [Other Constraints](#other-constraints)
- [Inserting Multiple Rows](#inserting-multiple-rows)
- [CSV Import](#csv-import)
- [Deleting Data](#deleting-data)
- [Foreign Keys and ON DELETE](#foreign-keys-and-on-delete)
- [Updating Data](#updating-data)
- [Triggers](#triggers)
- [Soft Deletions](#soft-deletions)
- [Fin](#fin)

## Introduction
- Last week: creating database schema. This week: adding, updating, deleting data.
- Example: Boston MFA (Museum of Fine Arts) manages artifacts/artwork in a database.
  - New artifact -> `INSERT`
  - Read / update / delete use cases throughout collection lifecycle.

## Database Schema
- Example `collections` table: `id` (PK), `title`, `accession_number` (unique museum ID), `acquired` (date).
- Setup:
```sql
-- create mfa.db, read schema.sql
SELECT * FROM "collections"; -- empty at first
```

## Inserting Data
- `INSERT INTO` inserts one row:
```sql
INSERT INTO "collections" ("id", "title", "accession_number", "acquired")
VALUES (1, 'Profusion of flowers', '56.257', '1956-04-12');

SELECT * FROM "collections";
```
- Let SQLite autogenerate PK by omitting `id`:
```sql
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES ('Farmers working at dawn', '11.6152', '1911-08-03');

SELECT * FROM "collections"; -- id = 2, max(id)+1
```

### Questions
> If we delete row id=1, will next insert reuse 1?
- No. SQLite uses max(id)+1, not reuse, unless `AUTOINCREMENT` semantics are used (see below).

## Other Constraints
- Schema:
```sql
CREATE TABLE "collections" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "accession_number" TEXT NOT NULL UNIQUE,
    "acquired" NUMERIC,
    PRIMARY KEY("id")
);
```
- Violations:
```sql
-- UNIQUE violation if accession_number repeats:
-- Runtime error: UNIQUE constraint failed: collections.accession_number

-- NOT NULL violation:
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES (NULL, NULL, '1900-01-10');
-- Runtime error: NOT NULL constraint failed: collections.title
```
- Schema constraints are guardrails.

## Inserting Multiple Rows
- Comma-separated `VALUES` lists — convenient + faster:
```sql
INSERT INTO "collections" ("title", "accession_number", "acquired")
VALUES
('Imaginative landscape', '56.496', NULL),
('Peonies and butterfly', '06.1899', '1906-01-01');

SELECT * FROM "collections";
```

### Questions
> Can we reorder columns on insert?
- You can change order of values if you change column list to match, but column order in table itself follows `CREATE TABLE`.

> What if one of many rows violates a constraint?
- Whole statement fails — none of the rows are inserted (atomic).

## CSV Import
- Data often comes as CSV. Example `mfa.csv` with header matching table.
- In sqlite3:
```sql
.import --csv --skip 1 mfa.csv collections
```
  - `--csv` -> parse as CSV
  - `--skip 1` -> skip header row
```sql
SELECT * FROM "collections";
```
- CSV without IDs (only `title,accession_number,acquired`):
```csv
title,accession_number,acquired
Profusion of flowers,56.257,1956-04-12
Farmers working at dawn,11.6152,1911-08-03
Spring outing,14.76,1914-01-08
Imaginative landscape,56.496,
Peonies and butterfly,06.1899,1906-01-01
```
- Can't directly import into 4-col table. Use temp table:
```sql
DELETE FROM "collections";

.import --csv mfa.csv temp
-- no --skip 1: SQLite uses first row as column names for new temp table

SELECT * FROM "temp";

INSERT INTO "collections" ("title", "accession_number", "acquired")
SELECT "title", "accession_number", "acquired" FROM "temp";
-- SQLite autogenerates id

DROP TABLE "temp";
```
- Note: empty CSV cell may import as empty text `''` not `NULL`. Run follow-up `UPDATE` to convert `''` -> `NULL` if needed.

## Deleting Data
- Delete all (careful!):
```sql
DELETE FROM "collections";
```
- Conditional deletes:
```sql
DELETE FROM "collections"
WHERE "title" = 'Spring outing';

DELETE FROM "collections"
WHERE "acquired" IS NULL;

SELECT * FROM "collections";

DELETE FROM "collections"
WHERE "acquired" < '1909-01-01'; -- before 1909-01-01
```

## Foreign Keys and ON DELETE
- Updated MFA schema: `artists` <-> `collections` many-to-many via `created`:
  - `artists(id, ...)`
  - `collections(id, ...)`
  - `created(artist_id, collection_id)` with FKs to both
- Try deleting referenced artist:
```sql
DELETE FROM "artists"
WHERE "name" = 'Unidentified artist';
-- Runtime error: FOREIGN KEY constraint failed
```
- Fix option 1 — delete children first:
```sql
DELETE FROM "created"
WHERE "artist_id" = (
    SELECT "id" FROM "artists"
    WHERE "name" = 'Unidentified artist'
);

DELETE FROM "artists"
WHERE "name" = 'Unidentified artist';
```
- Fix option 2 — `ON DELETE` actions in schema:
  - `ON DELETE RESTRICT` — block delete if FK would break
  - `ON DELETE NO ACTION` — allow, do nothing
  - `ON DELETE SET NULL` — set FK to NULL
  - `ON DELETE SET DEFAULT` — set FK to default
  - `ON DELETE CASCADE` — delete referencing rows too
- Example:
```sql
FOREIGN KEY("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE
FOREIGN KEY("collection_id") REFERENCES "collections"("id") ON DELETE CASCADE
```
- Then:
```sql
DELETE FROM "artists"
WHERE "name" = 'Unidentified artist';

SELECT * FROM "created"; -- no rows with id=3
```

### Questions
> After deleting id=3, can next insert reuse 3?
- By default SQLite uses max+1. Use `AUTOINCREMENT` keyword on PK column if you want different reuse behavior / strict monotonicity.
- Check schema with `.schema` in sqlite3.

## Updating Data
- Syntax:
```sql
UPDATE table SET col = value WHERE condition;
```
- Example — reattribute "Farmers working at dawn" from Unidentified artist to Li Yin:
```sql
UPDATE "created"
SET "artist_id" = (
    SELECT "id" FROM "artists" WHERE "name" = 'Li Yin'
)
WHERE "collection_id" = (
    SELECT "id" FROM "collections"
    WHERE "title" = 'Farmers working at dawn'
);
```

## Triggers
- Trigger = SQL that runs automatically on `INSERT` / `UPDATE` / `DELETE`. Useful for consistency + automation.
- New `transactions` table:
```sql
CREATE TABLE "transactions" (
    "id" INTEGER,
    "title" TEXT,
    "action" TEXT,
    PRIMARY KEY("id")
);
```
- Sell trigger (BEFORE DELETE, OLD):
```sql
CREATE TRIGGER "sell"
BEFORE DELETE ON "collections"
BEGIN
    INSERT INTO "transactions" ("title", "action")
    VALUES (OLD."title", 'sold');
END;
```
  - `OLD` = row being deleted
  - `OLD."title"` = its title
- Buy trigger (AFTER INSERT, NEW):
```sql
CREATE TRIGGER "buy"
AFTER INSERT ON "collections"
BEGIN
    INSERT INTO "transactions" ("title", "action")
    VALUES (NEW."title", 'bought');
END;
```
  - `NEW` = row being inserted

### Questions
> Multiple statements in a trigger?
- Yes — put them between `BEGIN` and `END`, separated by `;`.

## Soft Deletions
- Soft delete = mark as deleted instead of removing:
```sql
ALTER TABLE "collections"
ADD COLUMN "deleted" INTEGER DEFAULT 0;

UPDATE "collections"
SET "deleted" = 1
WHERE "title" = 'Farmers working at dawn';

SELECT * FROM "collections"
WHERE "deleted" != 1; -- only live rows
```
- Pros: recoverable, full history. Cons: must filter everywhere; still need true deletes for privacy compliance (e.g., GDPR right-to-erasure).

## Fin
- End of Lecture 3 — Writing in SQL. Next: Viewing (Views, CTEs, etc.).
