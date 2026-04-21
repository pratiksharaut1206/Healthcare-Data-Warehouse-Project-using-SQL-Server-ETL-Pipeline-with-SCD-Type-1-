IF OBJECT_ID('Proc_HealthConnect_Claims_Load','P') IS NOT NULL
DROP PROCEDURE Proc_HealthConnect_Claims_Load;
GO

CREATE PROCEDURE Proc_HealthConnect_Claims_Load
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_claims;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_claims
    SELECT
        claim_id, encounter_id, payer_id,
        admit_date, discharge_date,
        total_billed_amount, total_allowed_amount,
        total_paid_amount,
        UPPER(claim_status),
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_claims;

    MERGE HealthConnect_refined.dbo.refined_claims AS target
    USING HealthConnect_cleansed.dbo.cleansed_claims AS source
    ON target.claim_id = source.claim_id

    WHEN MATCHED THEN
    UPDATE SET
        target.claim_status = source.claim_status,
        target.last_updated_date = GETDATE()

    WHEN NOT MATCHED THEN
    INSERT VALUES (
        source.claim_id, source.encounter_id, source.payer_id,
        source.admit_date, source.discharge_date,
        source.total_billed_amount, source.total_allowed_amount,
        source.total_paid_amount, source.claim_status,
        source.load_date, GETDATE()
    );
END;
GO