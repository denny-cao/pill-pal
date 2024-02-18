from flask import Flask, request
from flask_restful import Resource, Api
import psycopg2
import os
import requests
import json
import datetime
# import OTP as otp

app = Flask(__name__)
api = Api(app)

conn = psycopg2.connect(
    database="database"
)
cur = conn.cursor()

@app.post('/api/new-patient')
def new_patient_otp():
    data = request.get_json()
    name = data['name']
    number = data['phone_number']
    if not cur.execute("SELECT * FROM patients WHERE phone_number = %s", (number,)):
        cur.execute("INSERT INTO patients (name, phone_number) VALUES (%s, %s)", (name, number))
        return "Patient added", 200
    else:
        return "Patient already exists", 400

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
        # Check if patient exists
        patients = cur.execute("SELECT * FROM patients WHERE id = %s", (patient_id,))

        if patients:
            caretaker_name = data['name']
            cur.execute("INSERT INTO caretakers (name, patient_id) VALUES (%s, %s)", (caretaker_name, patient_id))
            return "Caretaker added", 200
        else:
            return "Patient does not exist", 400
