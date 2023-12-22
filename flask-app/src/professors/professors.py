from flask import Blueprint, request, jsonify, make_response
import json
from src import db

professors = Blueprint('professors', __name__)
@professors.route('/getProfessorData')
def get_ProfessorData():
    cursor = db.get_db().cursor()
    cursor.execute('select * from professor_table')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@professors.route('/getSectionsTaught/<ProfessorID>', methods=['GET'])
def get_SectionsTaught(ProfessorID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from section_table where ProfessorID = {ProfessorID}')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@professors.route('/getStudentsInSection/<SectionID>', methods=['GET'])
def get_StudentsInSection(SectionID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from student_section_table where SectionID = {SectionID}')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@professors.route('/getTAsInSection/<SectionID>', methods=['GET'])
def get_TAsInSection(SectionID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from sectionta_table where SectionID = {SectionID}')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


