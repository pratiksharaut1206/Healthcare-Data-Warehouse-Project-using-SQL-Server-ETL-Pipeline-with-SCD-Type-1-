SELECT city, COUNT(*) AS total_patients
FROM refined_patients
GROUP BY city;