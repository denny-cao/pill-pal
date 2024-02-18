import os
import psycopg2
from dotenv import load_dotenv
from flask import Flask, request

load_dotenv()
app = Flask(__name__)
url = os.getenv("DATABASE_URL")
#use to insert/read data from db
connection = psycopg2.connect(url)

@app.post("/api/medications_patients")
def add_medications():
    data = request.get_json()
    name = data["name"]
    dosage = data["dosage"]
    interval = data["interval"]
    next_dose = data["next_dose"]

    with connection:
        with connection.cursor() as cursor:
            index = ("INSERT INTO medications_patients (name, dosage, interval, next_dose) VALUES (%s, %s, %d, %s)", (name, dosage, interval, next_dose))
            cursor.execute(medications_patients)
            cursor.execute(patient_id, (medication_id,))
            cursor.execute("INSERT INTO medications_patients (medication_id, ptaient_id) VALUES (%s, %s)". ())



#
# @app.post("/api/medications_patients")
# def add_medications():
#       data = request.get_json()
#       with connection.cursor() as cursor:
#           cursor.execute(
#                 "INSERT INTO medications_patients (name, dosage, interval, next_dose) VALUES (%s, %s, %s, %s)",
#                 (data["name"], data["dosage"], data["interval"], data["next_dose"])
#             )
#         connection.commit()

#         # Extract medication_id and patient_id from the request
#         data = request.json
#         medication_id = data['medication_id']
#         patient_id = data['patient_id']
#
#         # Insert a new record into PATIENT_MEDICATIONS table
#         query = "INSERT INTO PATIENT_MEDICATIONS (medication_id, patient_id) VALUES (%s, %s);"
#         cur.execute(query, (medication_id, patient_id))
# ## cursor.execute(INSERT INTO table i want (params:





######
# from flask import Flask, request, jsonify
# import psycopg2
#
# app = Flask(__name__)
#
# # Function to establish database connection
# def connect_to_database():
#     connection = psycopg2.connect(
#         database="your_database",
#         user="your_username",
#         password="your_password",
#         host="your_host",
#         port="your_port"
#     )
#     return connection
#
# # Route to add a medicine to a patient's profile
# @app.post("/caretaker/add_medicine")
# def add_medicine():
#         # Extract data from the request
#         data = request.json
#         medication_name = data["medication_name"]
#         dosage = data["dosage"]
#         patient_id = data["patient_id"]
#
#         # Connect to the database
#         connection = connect_to_database()
#         cursor = connection.cursor()
#
#         # Insert the medicine into medications table
#         cursor.execute("INSERT INTO medications (name, dosage) VALUES (%s, %s) RETURNING id", (medication_name, dosage))
#         medication_id = cursor.fetchone()[0]
#
#         # Insert the medicine-patient association into medications_patients table
#         cursor.execute("INSERT INTO medications_patients (medication_id, patient_id) VALUES (%s, %s)", (medication_id, patient_id))
#
#         # Commit the transaction and close cursor and connection
#         connection.commit()
#         cursor.close()
#         connection.close()
#
#         return jsonify({"message": "Medicine added to patient's profile successfully."}), 200
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

