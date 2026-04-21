-- Patients
TRUNCATE TABLE cleansed_patients;

INSERT INTO cleansed_patients
SELECT
    patient_id,
    UPPER(LTRIM(RTRIM(first_name))),
    UPPER(LTRIM(RTRIM(last_name))),
    gender,
    date_of_birth,
    UPPER(state_code),
    UPPER(city),
    phone,
    GETDATE()
FROM HealthConnect_raw.dbo.raw_patients;


-- Providers
TRUNCATE TABLE cleansed_providers;

INSERT INTO cleansed_providers
SELECT
    provider_id,
    UPPER(LTRIM(RTRIM(first_name))),
    UPPER(LTRIM(RTRIM(last_name))),
    UPPER(LTRIM(RTRIM(specialty))),
    npi,
    GETDATE()
FROM HealthConnect_raw.dbo.raw_providers;


-- Payers
TRUNCATE TABLE cleansed_payers;

INSERT INTO cleansed_payers
SELECT
    payer_id,
    UPPER(LTRIM(RTRIM(payer_name))),
    GETDATE()
FROM HealthConnect_raw.dbo.raw_payers;


-- Encounters
TRUNCATE TABLE cleansed_encounters;

INSERT INTO cleansed_encounters
SELECT
    encounter_id,
    patient_id,
    provider_id,
    UPPER(encounter_type),
    encounter_start,
    encounter_end,
    height_cm,
    weight_kg,
    systolic_bp,
    diastolic_bp,
    GETDATE()
FROM HealthConnect_raw.dbo.raw_encounters;


-- Claims
TRUNCATE TABLE cleansed_claims;

INSERT INTO cleansed_claims
SELECT
    claim_id,
    encounter_id,
    payer_id,
    admit_date,
    discharge_date,
    total_billed_amount,
    total_allowed_amount,
    total_paid_amount,
    UPPER(claim_status),
    GETDATE()
FROM HealthConnect_raw.dbo.raw_claims;


-- Diagnoses
TRUNCATE TABLE cleansed_diagnoses;

INSERT INTO cleansed_diagnoses
SELECT
    diagnosis_id,
    encounter_id,
    UPPER(LTRIM(RTRIM(diagnosis_description))),
    is_primary,
    GETDATE()
FROM HealthConnect_raw.dbo.raw_diagnoses;


-- Procedures
TRUNCATE TABLE cleansed_procedures;

INSERT INTO cleansed_procedures
SELECT
    procedure_id,
    encounter_id,
    UPPER(LTRIM(RTRIM(procedure_description))),
    GETDATE()
FROM HealthConnect_raw.dbo.raw_procedures;


-- Medications
TRUNCATE TABLE cleansed_medications;

INSERT INTO cleansed_medications
SELECT
    medication_id,
    encounter_id,
    UPPER(LTRIM(RTRIM(drug_name))),
    UPPER(route),
    dose,
    frequency,
    days_supply,
    GETDATE()
FROM HealthConnect_raw.dbo.raw_medications;
GO