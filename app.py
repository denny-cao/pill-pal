from flask import Flask, request
from flask_restful import Resource, Api
import psycopg2
import os
import requests
import json
import datetime
import dotenv
import datetime
# import otp

dotenv.load_dotenv()

password = os.getenv('PASSWORD')

app = Flask(__name__)
api = Api(app)

url = f"postgresql://postgres:{password}@localhost:5432/database"

conn = psycopg2.connect(url)
@app.get('/')
def hello():
    return "Hello World!"

@app.post('/api/check-unique-uid')
def check_unique_uid():
    data = request.get_json()
    uid = data['uid']

    with conn:
        with conn.cursor() as cur:
            query = "SELECT * FROM patients WHERE uid = %s" % (uid)
            cur.execute(query)
            if cur.fetchone():
                return {"message": "UID already exists"}, 400
            else:
                return {"message": "UID is unique"}, 200

@app.post('/api/new-patient')
def new_patient():
    data = request.get_json()
    uid = data['uid']                                         
    name = data['name']
    number = data['phone_number']
    # Validate phone number (10 digits)
    query = "SELECT * FROM patients WHERE phone_number = '%s'" % (number)
    with conn:
        with conn.cursor() as cur:
            if len(number) != 10:
                return {"message": "Invalid phone number"}, 300
            query = "SELECT * FROM patients WHERE phone_number = '%s'" % (number)
            cur.execute(query)
            if cur.fetchone():
                return {"message": "Patient already exists"}, 400

            query = "INSERT INTO patients (name, phone_number, uid) VALUES ('%s', '%s', %s);" % (name, number, uid)
            cur.execute(query)                         
            return {"message": "Patient added"}, 200

#     otp_instance = otp.OTP(number)
#     otp_instance.send_otp()
#     return "OTP sent", 200

# @app.post('/api/verify-patient-otp')
# def vertify_patient_otp():
#     data = request.get_json()
#     name = data['name']
#     number = data['phone_number']
#     user_otp = data['otp']

#     if otp.verify_otp(user_otp):
#         cur.execute("INSERT INTO patients (name, phone_number) VALUES (%s, %s)", (name, number))
#         return "Patient added", 200
#     else:
#         return "Invalid OTP", 400

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
    uid = data['uid']
    caretaker_name = data['name']

    with conn:
        with conn.cursor() as cur:
            query = "SELECT * FROM patients WHERE uid = %s" % (uid)
            cur.execute(query)
            if cur.fetchone():
                # Get patient id
                query = "SELECT id FROM patients WHERE uid = %s" % (uid)
                cur.execute(query)
                patient_id = cur.fetchone()[0]
                query = "INSERT INTO caretakers (name, patient_id) VALUES ('%s', %s);" % (caretaker_name, patient_id)
                cur.execute(query)
                return {"message": "Caretaker added"}, 200
            else:
                return {"message": "Patient does not exist"}, 400

@app.post('/api/update-next-dose')
def update_next_dose():
    data = request.get_json()
    medication_id = data['medication_id']
    with conn:
        with conn.cursor() as cur:
            query = "SELECT * FROM medications WHERE id = %s" % (medication_id)
            cur.execute(query)
            medication = cur.fetchone()
            if medication:
                # Update next dose
                interval = medication[3]
                next_dose = (datetime.datetime.now() + datetime.datetime.timedelta(hours=interval)).strftime('%Y-%m-%d %H:%M:%S')
                query = "UPDATE medications SET next_dose = '%s' WHERE id = %s" % (next_dose, medication_id)
                cur.execute(query)
                return {"message": "Next dose updated"}, 200
            else:
                return {"message": "Medication does not exist"}, 400    
