import sqlite3
from flask_restful import Resource, reqparse
from flask_jwt import JWT, jwt_required
from name import name_code
from symp_main import symp_code
from prescription import pres_code



class User:
    def __init__(self, _id, username, password,  doctor_name, doctor_designation, doctor_contact, hospital_name, hospital_address, image_filepath):
        self.id = _id
        self.username = username
        self.password = password
        self.doctor_name = doctor_name
        self.doctor_designation = doctor_designation
        self.doctor_contact = doctor_contact
        self.hospital_name = hospital_name
        self.hospital_address = hospital_address
        self.image_filepath = image_filepath


    @classmethod
    def find_by_username(cls, username):
        connection = sqlite3.connect('doctor.db')
        cursor = connection.cursor()

        query = "SELECT * FROM users WHERE username=?"
        result = cursor.execute(query, (username,))
        row = result.fetchone()
        if row is not None:
            user = cls(*row)
        else:
            user = None

        connection.close()
        return user

    @classmethod
    def find_by_id(cls, _id):
        connection = sqlite3.connect('doctor.db')
        cursor = connection.cursor()

        query = "SELECT * FROM users WHERE id=?"
        result = cursor.execute(query, (_id,))
        row = result.fetchone()
        if row is not None:
            user = cls(*row)
        else:
            user = None

        connection.close()
        return user


class UserRegister(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('password',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('doctor_name',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('doctor
    parser.add_argument('hospital_address',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('image_filepath',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    def post(self):

        request_data = UserRegister.parser.parse_args()

        #request_data = request.get_json()
        if User.find_by_username(request_data["username"]):
            return {"message": "A user with that username already exists"}, 400
        connection = sqlite3.connect('doctor.db')
        cursor = connection.cursor()
        query = "INSERT INTO users VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?)"
        cursor.execute(query, (
        request_data["username"], request_data["password"], request_data["doctor_name"], request_data["doctor_designation"], request_data["doctor_contact"], request_data["hospital_name"], request_data["hospital_address"], request_data['image_filepath']))

        query = "SELECT * FROM users WHERE username=?"
        result = cursor.execute(query, (request_data["username"],))
        row = result.fetchone()

        connection.commit()
        connection.close()

        return {"id": row[0]}, 201


class SetProfile(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('doctor_name',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('doctor_designation',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('doctor_contact',
                        type=int,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('hospital_name',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('hospital_address',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('image_filepath',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    @jwt_required()
    def post(self):
        data= SetProfile.parser.parse_args()
     #  user = User.find_by_username(data['username'])

        connection = sqlite3.connect('doctor.db')
        cursor = connection.cursor()
        query = "UPDATE users SET doctor_name = ? , doctor_designation = ? , doctor_contact = ? , hospital_name = ? , hospital_address = ? , image_filepath = ? WHERE username = ?"
        lol = (data['doctor_name'], data['doctor_designation'], data['doctor_contact'], data['hospital_name'], data['hospital_address'], data['image_filepath'], data['username'])
        cursor.execute(query, lol)

        connection.commit()
        connection.close()

        return True, 201




class GetProfile(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")


    def get(self):
        data = GetProfile.parser.parse_args()
        save = User.find_by_username(data['username'])

        if save is None:
            return {"message": "username invalid"}, 404
        else:
            return {"id" : save.id,
                    "doctor_name" : save.doctor_name,
                    "doctor_designation": save.doctor_designation,
                    "doctor_contact" : save.doctor_contact,
                    "hospital_name" : save.hospital_name,
                    "hospital_address" : save.hospital_address,
                    "image_filepath" : save.image_filepath
                    }, 200


class Symptoms(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('patient_details',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    parser.add_argument('symptoms',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")


    def post(self):
        data = Symptoms.parser.parse_args()
        sym = data['symptoms']
        diagnosis = str(symp_code(sym))

        dyu= data['patient_details']
        final_details = name_code(dyu)

        return {"diagnosis": diagnosis, "final_details": final_details}, 200


class Prescription(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('prescription',
                        type=str,
                        required=True,
                        help="This field cannot be left blank.")

    def post(self):
        data = Prescription.parser.parse_args()
        pres= data['prescription']

        final_pres= pres_code(pres)

        if final_pres is None:
            return {"message": "error formatting"}, 400
        else:
            return {"final_pres": final_pres}, 200












