SELECT COUNT(*) FROM HealthConnect_raw.dbo.raw_patients;
GO
SELECT COUNT(*) FROM HealthConnect_cleansed.dbo.cleansed_patients;
GO
SELECT COUNT(*) FROM HealthConnect_refined.dbo.refined_patients;
GO

SELECT first_name FROM cleansed_patients;
GO
SELECT * FROM refined_patients;
GO
SELECT * FROM cleansed_patients WHERE first_name IS NULL;
