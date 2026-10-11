SELECT salary 
FROM salaries
JOIN players ON salaries.player_id = players.id
WHERE salaries.player_id IN (
    SELECT player_id 
    FROM performances
    WHERE HR = (
        SELECT MAX(HR)
        FROM performances
        WHERE year = 2001
    )
    AND year = 2001
)
 AND salaries.year = 2001
