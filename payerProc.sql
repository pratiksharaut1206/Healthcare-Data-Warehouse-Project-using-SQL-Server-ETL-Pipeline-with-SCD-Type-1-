IF OBJECT_ID('Proc_HealthConnect_Payers_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Payers_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Payers_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_payers;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_payers
    SELECT
        payer_id,
        UPPER(payer_name),
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_payers;

    MERGE HealthConnect_refined.dbo.refined_payers AS target
    USING HealthConnect_cleansed.dbo.cleansed_payers AS source
    ON target.payer_id = source.payer_id

    WHEN MATCHED THEN
    UPDATE SET
        target.payer_name = source.payer_name,
        target.last_updated_date = GETDATE()

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.payer_id, source.payer_name,
        source.load_date, GETDATE()
    );
END;
GO