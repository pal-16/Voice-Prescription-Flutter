from flask import Flask, request
from flask_restful import Resource, Api
from flask_jwt import JWT, jwt_required

from security import authenticate, identity
from user import SetProfile, GetProfile, UserRegister, Prescription
from user import Symptoms


from datetime import timedelta

app = Flask(__name__)
app.secret_key = 'safety'
api = Api(app)

app.config['JWT_AUTH_URL_RULE'] = '/login'
app.config['JWT_EXPIRATION_DELTA'] = timedelta(seconds=99999999999)


jwt = JWT(app, authenticate, identity)    #authentication




api.add_resource(UserRegister, '/sign_up')
api.add_resource(SetProfile, '/set_profile')
api.add_resource(GetProfile, '/get_profile')
api.add_resource(Symptoms,'/symptoms')
api.add_resource(Prescription,'/prescription')





app.run(port=5000, debug=True)



