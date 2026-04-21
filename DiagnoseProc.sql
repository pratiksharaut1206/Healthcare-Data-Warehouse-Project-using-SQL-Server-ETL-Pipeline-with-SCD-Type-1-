IF OBJECT_ID('Proc_HealthConnect_Diagnoses_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Diagnoses_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Diagnoses_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_diagnoses;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_diagnoses
    SELECT
        diagnosis_id, encounter_id,
        UPPER(diagnosis_description),
        is_primary,
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_diagnoses;

    MERGE HealthConnect_refined.dbo.refined_diagnoses AS target
    USING HealthConnect_cleansed.dbo.cleansed_diagnoses AS source
    ON target.diagnosis_id = source.diagnosis_id

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.diagnosis_id, source.encounter_id,
        source.diagnosis_description, source.is_primary,
        source.load_date, GETDATE()
    );
END;
GO