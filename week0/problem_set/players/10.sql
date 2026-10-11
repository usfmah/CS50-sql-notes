SELECT first_name, last_name, height AS "Height in inches"
FROM players
WHERE height > 75
ORDER BY height DESC;