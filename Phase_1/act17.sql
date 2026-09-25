
-- CT 17: Model Design
-- Sketch a Star Schema for a hospital. Identify the central Fact table and 3 Dimension tables.

CREATE TABLE dim_patient
(patient_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
age INT,
birthdate DATE,
gender VARCHAR(20),
contact_num VARCHAR(20)
);

CREATE TABLE dim_department
(department_id SERIAL PRIMARY KEY,
department_name VARCHAR(50) NOT NULL
);

CREATE TABLE dim_doctor
(doctor_id SERIAL PRIMARY KEY,
department_id INT REFERENCES dim_department(department_id),
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
specialization VARCHAR(100),
contact_num VARCHAR(20)
);



CREATE TABLE fact_patient_visits
(visit_id SERIAL PRIMARY KEY,
patient_id INT REFERENCES dim_patient(patient_id),
doctor_id INT REFERENCES dim_doctor(doctor_id),
date_visit DATE,
treatment VARCHAR(100),
bill_amount DECIMAL(10, 2)
);

