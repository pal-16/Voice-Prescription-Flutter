import sqlite3

connection = sqlite3.connect('doctor.db')

cursor = connection.cursor()

create_table = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username text, password text, doctor_name text, doctor_designation text, doctor_contact int, hospital_name text, hospital_address text, image_filepath text)"

cursor.execute(create_table)


connection.commit()

connection.close()