# Lecture 0 - Querying - CS50's Introduction to Databases with SQL
Source: https://cs50.harvard.edu/sql/notes/0/

## Table of Contents
- [Introduction](#introduction)
- [What is a Database?](#what-is-a-database)
- [SQL](#sql)
- [Getting Started with SQLite](#getting-started-with-sqlite)
- [Terminal Tips](#terminal-tips)
- [`SELECT`](#select)
- [`LIMIT`](#limit)
- [`WHERE`](#where)
- [`NULL`](#null)
- [`LIKE`](#like)
- [Ranges](#ranges)
- [`ORDER BY`](#order-by)
- [Aggregate Functions](#aggregate-functions)
- [Fin](#fin)

## Introduction
- Databases (and SQL) are tools that can be used to interact with, store, and manage information. Although the tools we're using in this course are new, a database is an age-old idea.
- Look at diagram from a few thousand years ago with rows and columns containing stipends for workers at a temple. One could call this diagram a table, or even a spreadsheet.
- Based on diagram:
  - A table stores some set of information (here, worker stipends).
  - Every row in a table stores one item in that set (here, one worker).
  - Every column has some attribute of that item (here, the stipend for a particular month).
- Consider librarian organizing book titles and authors: each book is now a row, every row has two columns — book title and author.
- In today's information age, we can store tables using software like Google Sheets instead of paper or stone tablets. However, in this course we will talk about databases and not spreadsheets.
- Three reasons to move beyond spreadsheets to databases are
  - **Scale**: Databases can store not just tens of thousands but even millions and billions.
  - **Update Capacity**: Databases are able to handle multiple updates of data in a second.
  - **Speed**: Databases allow faster look-up of information via different algorithms vs Ctrl+F in spreadsheets.

## What is a Database?
- A database is a way of organizing data such that you can perform four operations on it
  - create
  - read
  - update
  - delete
- A database management system (DBMS) is a way to interact with a database using a graphical interface or textual language.
- Examples of DBMS: MySQL, Oracle, PostgreSQL, SQLite, Microsoft Access, MongoDB etc.
- Choice of DBMS rests on factors like
  - **Cost**: proprietary vs. free software,
  - **Amount of support**: free and open source like MySQL, PostgreSQL and SQLite require self-setup,
  - **Weight**: more fully-featured systems like MySQL or PostgreSQL are heavier than SQLite.
- In this course, we will start with SQLite and then move on to MySQL and PostgreSQL.

## SQL
- SQL stands for Structured Query Language. It is used to interact with databases: create, read, update, and delete data.
- SQL is structured, has keywords to interact with DB, and is a query language — used to ask questions of data.
- In this lesson, we will learn to write simple SQL queries.

### Questions
> Are there subsets of SQL?
- SQL is a standard of ANSI and ISO. Most DBMS support some subset. For SQLite, we're using subset supported by SQLite. Porting to MySQL would require syntax changes.

## Getting Started with SQLite
- SQLite is not merely for this class, but used in phones, desktop apps and websites.
- Consider database of books longlisted for the International Booker Prize. Each year 13 books, database contains 5 years' worth.
- Before interacting:
  - Log in to Visual Studio Code for CS50 (https://cs50.dev/)
  - SQLite environment is already set up in Codespace! Open it on terminal.

## Terminal Tips
- To clear terminal screen, hit Ctrl + L.
- To get previously executed instruction(s), press Up Arrow.
- If SQL query is too long and wrapping, hit enter and continue on next line.
- To exit database or SQLite environment, use `.quit`.

## `SELECT`
- `SELECT` allows to select some (or all) rows from a table.
```sql
SELECT * 
FROM "longlist";
```
Selects all rows from table `longlist`.

```sql
SELECT "title" 
FROM "longlist";
```
List of titles.

```sql
SELECT "title", "author" 
FROM longlist;
```

### Questions
> Is it necessary to use double quotes (") around table and column names?
- Good practice to use double quotes around identifiers. Use single quotes around strings to differentiate.

> Where is data coming from?
- Longlists 2018-2023 from Booker Prize website (https://thebookerprizes.com/the-booker-library/features/full-list-of-international-booker-prize-winners-shortlisted-authors-and-their-books)
- Ratings and other info from Goodreads (https://www.goodreads.com/)

> How do we know what tables and columns are in a database?
- Database schema contains structure, including table and column names. Later we learn how to get schema.

> Is SQLite 3 case-sensitive? Why are some parts capitalized?
- SQLite is case-insensitive. However style: SQL keywords in CAPITALS for readability. Table/column names in lowercase.
```sql
SELECT *
FROM "longlist";
```

## `LIMIT`
- Use `LIMIT` to specify number of rows if millions of rows exist.
```sql
SELECT "title" 
FROM "longlist" 
LIMIT 10;
```
First 10 titles, ordered as in database.

## `WHERE`
- `WHERE` selects rows based on condition.
```sql
SELECT "title", "author" 
FROM "longlist" 
WHERE "year" = 2023;
```
Note `2023` not in quotes because integer.

Operators: `=` ("equal to"), `!=` ("not equal to") and `<>` (also "not equal to").

```sql
SELECT "title", "format" 
FROM "longlist" 
WHERE "format" != 'hardcover';
```
Note `hardcover` in single quotes (string).

```sql
SELECT "title", "format" 
FROM "longlist" 
WHERE "format" <> 'hardcover';
```

```sql
SELECT "title", "format" 
FROM "longlist" 
WHERE NOT "format" = 'hardcover';
```

Combine conditions with `AND` and `OR`, use parentheses.

```sql
SELECT "title", "author" 
FROM "longlist" 
WHERE "year" = 2022 OR "year" = 2023;
```

```sql
SELECT "title", "format" 
FROM "longlist" 
WHERE ("year" = 2022 OR "year" = 2023) AND "format" != 'hardcover';
```

## `NULL`
- `NULL` indicates missing data / does not exist.
- Example: books have translator, but only some translated to English -> NULL.
- Conditions: `IS NULL` and `IS NOT NULL`.

```sql
SELECT "title", "translator" 
FROM "longlist"
 WHERE "translator" IS NULL;
```

```sql
SELECT "title", "translator" 
FROM "longlist"
WHERE "translator" IS NOT NULL;
```

## `LIKE`
- Used to select data roughly matching string, combined with `%` (matches any chars) and `_` (matches single char).

```sql
SELECT "title"
FROM "longlist"
WHERE "title" LIKE '%love%';
```
`%` matches 0+ chars.

```sql
SELECT "title" 
FROM "longlist" 
WHERE "title" LIKE 'The%';
```

```sql
SELECT "title" 
FROM "longlist" 
WHERE "title" LIKE 'The %';
```
With space to avoid "Their"/"They".

```sql
SELECT "title" 
FROM "longlist" 
WHERE "title" LIKE 'P_re';
```
Matches "Pyre" or "Pire", also "Pore"/"Pure" if existed.

### Questions
> Can we use multiple `%` or `_` symbols?
- Yes! Example:
```sql
SELECT "title" 
FROM "longlist" 
WHERE "title" LIKE 'The%love%';
```
Example 2: title begins with "T" and has four letters:
```sql
SELECT "title" 
FROM "longlist" 
WHERE "title" LIKE 'T____';
```

> Is string comparison case-sensitive?
- In SQLite, `LIKE` is by default case-insensitive, whereas `=` is case-sensitive. In other DBMS, config can change this!

## Ranges
- Operators `<`, `>`, `<=`, `>=` to match range.
```sql
SELECT "title", "author" 
FROM "longlist" 
WHERE "year" >= 2019 AND "year" <= 2022;
```
Alternative with `BETWEEN` (inclusive):
```sql
SELECT "title", "author" 
FROM "longlist" 
WHERE "year" BETWEEN 2019 AND 2022;
```

```sql
SELECT "title", "rating" 
FROM "longlist" 
WHERE "rating" > 4.0;
```

```sql
SELECT "title", "rating", "votes" 
FROM "longlist" 
WHERE "rating" > 4.0 AND "votes" > 10000;
```

```sql
SELECT "title", "pages" 
FROM "longlist" 
WHERE "pages" < 300;
```

### Questions
> For range operators, do values have to be integers?
- No, can be integers or floating-point ("decimal" or "real") numbers.

## `ORDER BY`
- Organizes returned rows in specified order.

```sql
SELECT "title", "rating" 
FROM "longlist" 
ORDER BY "rating" LIMIT 10;
```
Bottom 10 (ascending default).

```sql
SELECT "title", "rating" 
FROM "longlist" 
ORDER BY "rating" DESC LIMIT 10;
```
Top 10 (`DESC` descending, `ASC` explicit ascending).

```sql
SELECT "title", "rating", "votes" 
FROM "longlist"
ORDER BY "rating" DESC, "votes" DESC 
LIMIT 10;
```

### Questions
> To sort books by title alphabetically, can we use `ORDER BY`?
```sql
SELECT "title" 
FROM "longlist" 
ORDER BY "title";
```

## Aggregate Functions
- `COUNT`, `AVG`, `MIN`, `MAX`, `SUM` — perform operations over multiple rows, each returns single aggregated value.

```sql
SELECT AVG("rating") 
FROM "longlist";
```

```sql
SELECT ROUND(AVG("rating"), 2) 
FROM "longlist";
```

```sql
SELECT ROUND(AVG("rating"), 2) AS "average rating" 
FROM "longlist";
```
`AS` to rename columns.

```sql
SELECT MAX("rating") 
FROM "longlist";
```

```sql
SELECT MIN("rating") 
FROM "longlist";
```

```sql
SELECT SUM("votes") 
FROM "longlist";
```

```sql
 SELECT COUNT(*) 
 FROM "longlist";
```
`*` counts every row.

```sql
SELECT COUNT("translator") 
FROM "longlist";
```
Does not count NULL -> fewer than total rows.

```sql
SELECT COUNT("publisher") 
FROM "longlist";
```

```sql
SELECT COUNT(DISTINCT "publisher") 
FROM "longlist";
```
`DISTINCT` ensures distinct values counted.

### Questions
> Would using `MAX` with title give longest title?
- No, gives "largest" (last) title alphabetically. Similarly `MIN` gives first alphabetically.

## Fin
- Conclusion of Lecture 0 about Querying! To exit SQLite prompt, type `.quit`.
