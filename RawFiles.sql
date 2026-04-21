TRUNCATE TABLE raw_patients;
BULK INSERT raw_patients
FROM 'D:\HealthConnect\InboundFiles\patients.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_providers;
BULK INSERT raw_providers
FROM 'D:\HealthConnect\InboundFiles\providers.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_payers;
BULK INSERT raw_payers
FROM 'D:\HealthConnect\InboundFiles\payers.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_claims;
BULK INSERT raw_claims
FROM 'D:\HealthConnect\InboundFiles\claims.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_encounters;
BULK INSERT raw_encounters
FROM 'D:\HealthConnect\InboundFiles\encounters.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_diagnoses;
BULK INSERT raw_diagnoses
FROM 'D:\HealthConnect\InboundFiles\diagnoses.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_procedures;
BULK INSERT raw_procedures
FROM 'D:\HealthConnect\InboundFiles\procedures.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);

TRUNCATE TABLE raw_medications;
BULK INSERT raw_medications
FROM 'D:\HealthConnect\InboundFiles\medications.csv'
WITH (FIELDTERMINATOR=',', ROWTERMINATOR='\n', FIRSTROW=2);