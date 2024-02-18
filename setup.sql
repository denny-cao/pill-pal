-- Caretakers Table 
CREATE TABLE caretakers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Patients Table
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    caretaker_id INT REFERENCES caretakers(id),
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
    uid INT NOT NULL
);

-- Medications Table 
CREATE TABLE medications (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    interval INT NOT NULL,
    next_dose TIMESTAMP NOT NULL
);

-- Medications_Patients Table 
CREATE TABLE medications_patients (
    id SERIAL PRIMARY KEY,
    medication_id INT REFERENCES medications(id),
    patient_id INT REFERENCES patients(id)
);
