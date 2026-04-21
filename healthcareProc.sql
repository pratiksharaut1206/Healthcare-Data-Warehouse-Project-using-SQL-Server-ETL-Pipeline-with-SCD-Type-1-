IF OBJECT_ID('Proc_HealthConnect_Procedures_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Procedures_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Procedures_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_procedures;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_procedures
    SELECT
        procedure_id,
        encounter_id,
        UPPER(LTRIM(RTRIM(procedure_description))),
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_procedures;

    MERGE HealthConnect_refined.dbo.refined_procedures AS target
    USING HealthConnect_cleansed.dbo.cleansed_procedures AS source
    ON target.procedure_id = source.procedure_id

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.procedure_id,
        source.encounter_id,
        source.procedure_description,
        source.load_date,
        GETDATE()
    );
END;
GO