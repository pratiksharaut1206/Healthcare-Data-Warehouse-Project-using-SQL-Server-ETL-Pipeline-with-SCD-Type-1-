USE HealthConnect_refined;
GO

ALTER PROCEDURE Proc_HealthConnect_Patients_Load
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

    ---------------------------------------------------
    -- 1. LOAD RAW (Optional - if using BULK INSERT)
    ---------------------------------------------------
    -- Uncomment if needed

    /*
    TRUNCATE TABLE dev_HealthConnect_raw.dbo.raw_patients;

    BULK INSERT dev_HealthConnect_raw.dbo.raw_patients
    FROM 'D:\HealthConnect\InboundFiles\patients_yyyymmdd.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );
    */

    ---------------------------------------------------
    -- 2. RAW → CLEANSED
    ---------------------------------------------------
    TRUNCATE TABLE HealthConnect_cleansed.dbo.cleansed_patients;

    INSERT INTO HealthConnect_cleansed.dbo.cleansed_patients
    SELECT
        patient_id,
        UPPER(LTRIM(RTRIM(first_name))) AS first_name,
        UPPER(LTRIM(RTRIM(last_name))) AS last_name,
        gender,
        date_of_birth,
        UPPER(state_code),
        UPPER(city),
        phone,
        GETDATE()
    FROM HealthConnect_raw.dbo.raw_patients;

    ---------------------------------------------------
    -- 3. CLEANSED → REFINED (SCD TYPE 1)
    ---------------------------------------------------
    MERGE HealthConnect_refined.dbo.refined_patients AS target
    USING HealthConnect_cleansed.dbo.cleansed_patients AS source
    ON target.patient_id = source.patient_id

    WHEN MATCHED THEN
        UPDATE SET
            target.first_name = source.first_name,
            target.last_name = source.last_name,
            target.gender = source.gender,
            target.date_of_birth = source.date_of_birth,
            target.state_code = source.state_code,
            target.city = source.city,
            target.phone = source.phone,
            target.last_updated_date = GETDATE()

    WHEN NOT MATCHED THEN
        INSERT (
            patient_id, first_name, last_name, gender,
            date_of_birth, state_code, city, phone,
            load_date, last_updated_date
        )
        VALUES (
            source.patient_id, source.first_name, source.last_name,
            source.gender, source.date_of_birth,
            source.state_code, source.city, source.phone,
            source.load_date, GETDATE()
        );

    ---------------------------------------------------
    -- 4. LOG SUCCESS
    ---------------------------------------------------
    INSERT INTO HealthConnect_refined.dbo.process_log
    VALUES ('Patients Load','SUCCESS',GETDATE());

    END TRY
    BEGIN CATCH

        ---------------------------------------------------
        -- 5. LOG FAILURE
        ---------------------------------------------------
        INSERT INTO HealthConnect_refined.dbo.process_log
        VALUES ('Patients Load','FAILED',GETDATE());

    END CATCH

END;
GO