USE HealthConnect_refined;
GO

CREATE TABLE process_log (
    process_name VARCHAR(100),
    status VARCHAR(20),
    run_time DATETIME
);
GO