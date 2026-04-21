IF OBJECT_ID('Proc_HealthConnect_Encounters_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Encounters_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Encounters_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_encounters;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_encounters
    SELECT
        encounter_id, patient_id, provider_id,
        UPPER(encounter_type),
        encounter_start, encounter_end,
        height_cm, weight_kg,
        systolic_bp, diastolic_bp,
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_encounters;

    MERGE HealthConnect_refined.dbo.refined_encounters AS target
    USING HealthConnect_cleansed.dbo.cleansed_encounters AS source
    ON target.encounter_id = source.encounter_id

    WHEN MATCHED THEN
    UPDATE SET
        target.encounter_type = source.encounter_type,
        target.last_updated_date = GETDATE()

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.encounter_id, source.patient_id, source.provider_id,
        source.encounter_type, source.encounter_start, source.encounter_end,
        source.height_cm, source.weight_kg,
        source.systolic_bp, source.diastolic_bp,
        source.load_date, GETDATE()
    );
END;
GO