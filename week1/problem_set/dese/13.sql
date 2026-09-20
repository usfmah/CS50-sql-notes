SELECT schools.name,
       graduation_rates.graduated
FROM schools
JOIN graduation_rates
    ON schools.id = graduation_rates.school_id
WHERE graduation_rates.graduated > (
    SELECT AVG(graduated)
    FROM graduation_rates
)
ORDER BY graduation_rates.graduated DESC;