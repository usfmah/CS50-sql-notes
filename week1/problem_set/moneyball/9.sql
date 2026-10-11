SELECT ROUND(AVG(salary), 2), name 
FROM salaries
JOIN teams ON salaries.team_id = teams.id
WHERE salaries.year = 2001
GROUP BY teams.id, teams.name
ORDER BY AVG(salary)
LIMIT 5;
