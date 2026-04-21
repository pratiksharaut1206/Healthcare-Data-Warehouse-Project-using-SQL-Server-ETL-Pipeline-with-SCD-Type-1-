IF OBJECT_ID('Proc_HealthConnect_Medications_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Medications_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Medications_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_medications;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_medications
    SELECT
        medication_id,
        encounter_id,
        UPPER(LTRIM(RTRIM(drug_name))),
        UPPER(LTRIM(RTRIM(route))),
        dose,
        frequency,
        days_supply,
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_medications;

    MERGE HealthConnect_refined.dbo.refined_medications AS target
    USING HealthConnect_cleansed.dbo.cleansed_medications AS source
    ON target.medication_id = source.medication_id

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.medication_id,
        source.encounter_id,
        source.drug_name,
        source.route,
        source.dose,
        source.frequency,
        source.days_supply,
        source.load_date,
        GETDATE()
    );
END;
GO