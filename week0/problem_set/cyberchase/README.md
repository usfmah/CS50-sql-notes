# Cyberchase

Source: https://cs50.harvard.edu/sql/psets/0/cyberchase/

Educational PBS series. DB: `cyberchase.db`, table `episodes`.

## Schema — `episodes`

| column | description |
|---|---|
| `id` | PK, unique episode |
| `season` | season number |
| `episode_in_season` | number within season |
| `title` | episode title |
| `topic` | ideas taught (NULL if none) |
| `air_date` | `YYYY-MM-DD` |
| `production_code` | PBS internal ID |

## Specification

1. `1.sql` — Titles of all Season 1 episodes.
2. `2.sql` — Season + title of first episode of every season (`episode_in_season = 1`).
3. `3.sql` — Production code for “Hackerized!”.
4. `4.sql` — Titles where topic IS NULL.
5. `5.sql` — Title of holiday episode aired `2004-12-31`.
6. `6.sql` — Titles from season 6 that aired early in 2007 (`air_date` in 2007 but season=6/2008 season).
7. `7.sql` — Titles + topics where topic LIKE '%fractions%'.
8. `8.sql` — COUNT episodes 2018–2023 inclusive (use BETWEEN on `air_date`).
9. `9.sql` — COUNT episodes 2002–2007 inclusive.
10. `10.sql` — id, title, production_code ordered by production_code ASC.
11. `11.sql` — Titles from season 5 in reverse alphabetical (DESC).
12. `12.sql` — COUNT(DISTINCT title).
13. `13.sql` — Custom: must use WHERE with AND/OR.

Optional:
- Titles aired in holiday season (December) — better than LIKE, use `strftime`.
- For each year, first air date (MIN air_date grouped by year).

## Expected rows

1:26×1, 2:14×2, 3:1×1, 4:26×1, 5:1×1, 6:2×1, 7:6×2, 8:1×1, 9:1×1, 10:140×3, 11:10×1, 12:1×1
