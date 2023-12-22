from flask import Blueprint, request, jsonify, make_response
import json
from src import db

students = Blueprint('students', __name__)

@students.route('/getStudentData', methods=['GET'])
def get_studentInfo():
    cursor = db.get_db().cursor()
    cursor.execute('select * from student_table')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


@students.route('/getStudentSections/<StudentID>', methods=['GET'])
def get_studentSections(StudentID):
    cursor = db.get_db().cursor()
    cursor.execute(
        f'select * from student_section_table natural join (select SectionID, CourseID from section_table) as t where studentID = {StudentID}')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)