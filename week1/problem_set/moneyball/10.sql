SELECT first_name, last_name, salary, performances.year, HR
FROM performances
JOIN players
    ON players.id = performances.player_id
JOIN salaries
    ON salaries.player_id = players.id
    AND salaries.year = performances.year
ORDER BY performances.player_id,
         performances.year DESC,
         HR DESC,
         salary DESC;