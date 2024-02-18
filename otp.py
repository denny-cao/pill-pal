from twilio.rest import Client
import random
import threading
import time
import dotenv

client = Client()
dotenv.load_dotenv()
account_sid = dotenv.get('TWILIO_ACCOUNT_SID')
auth_token = dotenv.get('TWILIO_AUTH_TOKEN')

class Otp:
    def __init__(self, phone_number):
        self.phone_number = phone_number
        self.otp = random.randint(1000, 9999)
        self.expiration_time = 120
        self.expired = False
        self.timer = threading.Thread(target=self.expire_otp)
        self.timer.start()

    def expire_otp(self):
        time.sleep(self.expiration_time)
        self.expired = True

    def send_otp(self):
        message = client.messages.create(
            body=f"Your OTP is: {self.otp}",
            from_="",
            to=self.phone_number
        )
        print(message.sid)

    def verify_otp(self, user_otp):
        if self.expired:
            return False
        if int(user_otp) == self.otp:
            return True
        return False

    def resend_otp(self):
        self.otp = random.randint(1000, 9999)
        self.expired = False
        self.timer = threading.Thread(target=self.expire_otp)
        self.timer.start()
        self.send_otp()

    def change_phone_number(self, phone_number):
        self.phone_number = phone_number
