MERGE refined_patients AS target
USING HealthConnect_cleansed.dbo.cleansed_patients AS source
ON target.patient_id = source.patient_id

WHEN MATCHED THEN
UPDATE SET
    target.first_name = source.first_name,
    target.last_name = source.last_name,
    target.city = source.city,
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
GO