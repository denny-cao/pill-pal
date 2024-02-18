from flask import Flask, request
from flask_restful import Resource, Api
import psycopg2
import os
import requests
import json
import datetime
import otp

app = Flask(__name__)
api = Api(app)

conn = psycopg2.connect(
    database="database"
)
cur = conn.cursor()

@app.post('/api/new-patient')
def new_patient():
    data = request.get_json()
    name = data['name']
    number = data['phone_number']
    # Validate phone number (10 digits)
    if len(number) != 10 or number.isdigit():
        return "Invalid phone number", 400
    elif cur.execute("SELECT * FROM patients WHERE phone_number = %s", (number,)):
        return "Patient already exists", 400

    otp_instance = otp.OTP(number)
    otp_instance.send_otp()
    return "OTP sent", 200

@app.post('/api/verify-patient-otp')
def vertify_patient_otp():
    data = request.get_json()
    name = data['name']
    number = data['phone_number']
    user_otp = data['otp']

    if otp.verify_otp(user_otp):
        cur.execute("INSERT INTO patients (name, phone_number) VALUES (%s, %s)", (name, number))
        return "Patient added", 200
    else:
        return "Invalid OTP", 400

# 
#     if not cur.execute("SELECT * FROM patients WHERE phone_number = %s", (number,)):
#         cur.execute("INSERT INTO patients (name, phone_number) VALUES (%s, %s)", (name, number))
#         return "Patient added", 200
#     else:
#         return "Patient already exists", 400

#     # Validate phone phone_number (10 digits)
#     if len(number) != 10:
#         return "Invalid phone number", 400
#     elif not number.isdigit():
#         return "Invalid phone number", 400
# 
#     # Check if patient already exists
#     if cur.execute("SELECT * FROM patients WHERE phone_number = %s", (name, number)):
#         return "Patient already exists", 400
# 
#     # OTP generation
#     otp = otp(number)
# 
#     otp.send_otp()
# 
#     return "OTP sent", 200

# @app.post('/api/verify-patient-otp')
# def verify_patient_otp():
#     data = request.get_json()
#     user_otp = data['otp']
# 
#     if otp.verify_otp(user_otp):
#         return "OTP verified", 200
#     else:
#         return "Invalid OTP", 400

@app.post('/api/new-caretaker')
def new_caretaker():
    data = request.get_json()
    patient_id = data['patient_id']
    with conn:
        if cur.execute("SELECT * FROM patients WHERE id = %s", (patient_id,)):
            caretaker_name = data['name']
            cur.execute("INSERT INTO caretakers (name, patient_id) VALUES (%s, %s)", (caretaker_name, patient_id))
            return "Caretaker added", 200
        else:
            return "Patient does not exist", 400

@app.post('/update-next-dose')
def update_next_dose():
    data = request.get_json()
    medication_id = data['medication_id']
    next_dose = data['next_dose']
    with conn:
        cur.execute("UPDATE medications SET next_dose = %s WHERE id = %s", (next_dose, medication_id))
        return "Next dose updated", 200
