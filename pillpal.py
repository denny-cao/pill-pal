from flask import Flask, request
from flask_restful import Resource, Api
import psycopg2
import time
import os

app = Flask(__name__)
api = Api(app)

conn = psycopg2.connect(
    database="database"
)
cur = conn.cursor()


