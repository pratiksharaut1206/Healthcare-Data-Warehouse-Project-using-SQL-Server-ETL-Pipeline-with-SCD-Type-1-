USE HealthConnect_refined;
GO

IF OBJECT_ID('Proc_HealthConnect_Providers_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Providers_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Providers_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_providers;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_providers
    SELECT
        provider_id,
        UPPER(LTRIM(RTRIM(first_name))),
        UPPER(LTRIM(RTRIM(last_name))),
        UPPER(LTRIM(RTRIM(specialty))),
        npi,
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_providers;

    MERGE HealthConnect_refined.dbo.refined_providers AS target
    USING HealthConnect_cleansed.dbo.cleansed_providers AS source
    ON target.provider_id = source.provider_id

    WHEN MATCHED THEN
    UPDATE SET
        target.first_name = source.first_name,
        target.last_name = source.last_name,
        target.specialty = source.specialty,
        target.npi = source.npi,
        target.last_updated_date = GETDATE()

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.provider_id, source.first_name, source.last_name,
        source.specialty, source.npi,
        source.load_date, GETDATE()
    );
END;
GO

