SELECT city, COUNT(*) AS Schools
FROM schools
WHERE type = 'Public School'
GROUP BY city
HAVING COUNT(*) <= 3
ORDER BY Schools DESC, city ASC;