# Lecture 1 - Relating - CS50's Introduction to Databases with SQL
Source: https://cs50.harvard.edu/sql/notes/1/

## Table of Contents
- [Introduction](#introduction)
- [Entity Relationship Diagrams](#entity-relationship-diagrams)
- [Keys](#keys)
- [Subqueries](#subqueries)
- [`IN`](#in)
- [`JOIN`](#join)
- [Sets](#sets)
- [Groups](#groups)
- [Fin](#fin)

## Introduction
- Databases can have multiple tables. Last class we saw a database of books longlisted for the International Booker Prize. It has 7 tables inside `longlist.db`: books, authors, publishers, translators, ratings, etc.
- See tables with `.tables` in SQLite.
- Such a database is a **relational database**: tables have relationships between them.
  - Authors write books.
  - Publishers publish books.
  - Books are translated by translators.
- Looking at `authors.name` next to `books.title` alone tells us nothing about who wrote what.
- Bad approaches:
  - **Honor system**: row N in `authors` always matches row N in `books`. Breaks on mistakes, multiple books per author, co-authored books.
  - **One-table approach**: duplicates data when one author writes many books or books have many authors (redundancy).
- Better: keep separate tables and relate them. Relationship types:
  - **One-to-one**: each author writes one book, each book has one author.
  - **One-to-many**: one author writes many books.
  - **Many-to-many**: authors write many books, books have many co-authors.

## Entity Relationship Diagrams
- ER diagrams visualize entities (tables) and relationships (verbs on connecting lines), in crow's foot notation:
  - Circle (0): zero / optional.
  - Perpendicular line (1): exactly one / required.
  - Crow's foot (many): many rows.
- Example for `longlist.db`:
  - `Author }|--|{ Book : wrote` — authors write one-or-more books, books written by one-or-more authors.
  - `Publisher ||--|{ Book : published`
  - `Translator }o--|{ Book : translated` — books need zero-to-many translators, translators translate at least one book.
  - `Book ||--o{ Rating : has`
- Read left to right: side symbols describe that entity's cardinality.
- ER diagrams communicate designer decisions: which relationships exist is a design choice.

### Questions
> How do we know relationships in a database?
- Up to the designer. ER diagrams communicate those decisions.

> Once known, how to implement?
- With **keys** (below).

## Keys
### Primary Keys
- A primary key uniquely identifies every row in a table, e.g. ISBN for books.
- We can invent our own: `1, 2, 3, ...` for authors, publishers, translators. Each table gets one.
- Long natural keys (17-byte ISBN with dashes) waste memory vs small integer IDs.

### Foreign Keys
- A foreign key is a primary key from another table stored as a column, forming a link.
- Example one-to-many: `ratings.book_id` references `books.id` — one book has many ratings.
- Example many-to-many: junction table `authored(book_id, author_id)` maps `books.id <-> authors.id`.
- Junction tables cost space but remove redundancy.

### Questions
> Can `author_id` and `book_id` both be 1 in `authored` without mix-up?
- Yes. Columns are typed by position: first column is always author key, second always book key.

> Don't many junction tables waste space?
- Trade-off: more space, no redundancy, clean many-to-many.

> On changing an ID, does it update everywhere?
- IDs are abstracted and rarely changed; they must stay unique.

## Subqueries
- A subquery (nested query) runs inside another. Innermost parentheses run first; indent inner queries for readability.
- One-to-many: books by Fitzcarraldo Editions needs publisher id first:
  ```sql
  SELECT "title" FROM "books"
  WHERE "publisher_id" = (
    SELECT "id" FROM "publishers"
    WHERE "publisher" = 'Fitzcarraldo Editions'
  );
  ```
- Ratings for `In Memory of Memory`:
  ```sql
  SELECT "rating" FROM "ratings"
  WHERE "book_id" = (
    SELECT "id" FROM "books" WHERE "title" = 'In Memory of Memory'
  );
  ```
- Average rating: wrap with `AVG("rating")`.
- Many-to-many: author(s) of `Flights` needs `books -> authored -> authors`:
  ```sql
  SELECT "name" FROM "authors"
  WHERE "id" = (
    SELECT "author_id" FROM "authored"
    WHERE "book_id" = (
      SELECT "id" FROM "books" WHERE "title" = 'Flights'
    )
  );
  ```

## `IN`
- `IN` checks membership in a list/set. Use when inner query returns many rows (`=` expects one).
- All books by Fernanda Melchor:
  ```sql
  SELECT "title" FROM "books"
  WHERE "id" IN (
    SELECT "book_id" FROM "authored"
    WHERE "author_id" = (
      SELECT "id" FROM "authors" WHERE "name" = 'Fernanda Melchor'
    )
  );
  ```
- Inner `=` ok here (one author expected), outer needs `IN` (many books possible).

### Questions
> Inner query finds nothing?
- Outer returns nothing — outer depends on inner.

> Must indent 4 spaces?
- No. Any consistent breaking/indentation for readability is fine.

> Many-to-one with repeated foreign keys?
- Foreign keys may repeat; primary keys never repeat.

## `JOIN`
- `JOIN` combines tables side-by-side into a temporary result set (not saved).
- Example `sea_lions.db`: `sea_lions(id, ...)` + `migrations(id, ...)` share `id`:
  ```sql
  SELECT * FROM "sea_lions"
  JOIN "migrations" ON "migrations"."id" = "sea_lions"."id";
  ```
  - `ON` specifies matching values. Plain `JOIN` = `INNER JOIN`: drops IDs missing on either side.
- `LEFT JOIN`: keep all left rows, blanks (`NULL`) where right missing.
- `RIGHT JOIN`: keep all right rows. `FULL JOIN`: keep everything. These are `OUTER JOIN`s and can produce `NULL`s.
- Same column name on both sides allows:
  ```sql
  SELECT * FROM "sea_lions" NATURAL JOIN "migrations";
  ```
  No duplicate `id`, behaves like inner join.

### Questions
> Where do sea lion IDs come from?
- Assigned at data source (researchers), not generated by either table.

> Three tables — which is left/right?
- Per `JOIN` clause: table before keyword = left, table after = right.

> Is joined table saved?
- No, temporary for that query (see Lecture 4 views for saved queries).

> Which `JOIN` by default?
- Bare `JOIN` = `INNER JOIN`.

## Sets
- Query results are result sets. Combine with `INTERSECT`, `UNION`, `EXCEPT` (same column count/types required).
- Switch back to `longlist.db`. Authors vs translators:
  ```sql
  SELECT "name" FROM "translators"
  INTERSECT
  SELECT "name" FROM "authors";
  ```
  Both author and translator.
  ```sql
  SELECT "name" FROM "translators"
  UNION
  SELECT "name" FROM "authors";
  ```
  Either or both, deduplicated. Add profession column to label source.
  ```sql
  SELECT "name" FROM "authors"
  EXCEPT
  SELECT "name" FROM "translators";
  ```
  Only authors. Swap for only translators.
- Either-but-not-both = `(A UNION B) EXCEPT (A INTERSECT B)`.
- Books co-translated by Sophie Hughes and Margaret Jull Costa: two `book_id` sets by translator id, `INTERSECT` them.

### Questions
> 3-4 sets?
- Yes, chain operator twice, e.g. `A INTERSECT B INTERSECT C`.

## Groups
- `GROUP BY` collapses rows per group so aggregates apply per group. Average rating per book:
  ```sql
  SELECT "book_id", AVG("rating") AS "average rating"
  FROM "ratings" GROUP BY "book_id";
  ```
- Filter groups with `HAVING` (not `WHERE`, which filters rows):
  ```sql
  SELECT "book_id", ROUND(AVG("rating"), 2) AS "average rating"
  FROM "ratings" GROUP BY "book_id"
  HAVING "average rating" > 4.0;
  ```
- Count per book: `COUNT("rating")` with same `GROUP BY`. Add `ORDER BY "average rating" DESC` to sort.

### Questions
> Number of ratings per book?
- `SELECT "book_id", COUNT("rating") FROM "ratings" GROUP BY "book_id";`

> Sort too?
- Append `ORDER BY ... DESC` after `HAVING`.

## Fin
- This concludes Lecture 1 about relating: ER diagrams, keys, subqueries, `IN`, `JOIN`, sets, groups.
