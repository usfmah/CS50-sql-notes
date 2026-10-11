SELECT first_name, last_name
FROM (
    SELECT players.id, first_name, last_name
    FROM players
    JOIN salaries
        ON players.id = salaries.player_id
    JOIN performances
        ON players.id = performances.player_id
        AND salaries.year = performances.year
    WHERE salaries.year = 2001
      AND performances.H > 0
    ORDER BY salaries.salary * 1.0 / performances.H
    LIMIT 10
)

INTERSECT

SELECT first_name, last_name
FROM (
    SELECT players.id, first_name, last_name
    FROM players
    JOIN salaries
        ON players.id = salaries.player_id
    JOIN performances
        ON players.id = performances.player_id
        AND salaries.year = performances.year
    WHERE salaries.year = 2001
      AND performances.RBI > 0
    ORDER BY salaries.salary * 1.0 / performances.RBI
    LIMIT 10
)

ORDER BY last_name;