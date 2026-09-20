SELECT city, COUNT(name) AS Schools
FROM schools
WHERE type = 'Public School'
GROUP BY city
ORDER BY Schools DESC, city ASC
LIMIT 10;