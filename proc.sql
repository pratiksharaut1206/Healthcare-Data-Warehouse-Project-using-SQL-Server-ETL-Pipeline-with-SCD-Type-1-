/*EXEC Proc_HealthConnect_Procedures_Load;
GO
EXEC Proc_HealthConnect_Master_Load;*/

SELECT * 
FROM HealthConnect_cleansed.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'cleansed_medications';