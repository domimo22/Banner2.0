from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

advisors = Blueprint('advisors', __name__)

@advisors.route('/getDepartmentData')
def getDepartmentData():
    cursor = db.get_db().cursor()
    cursor.execute('select * from department_table')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


@advisors.route('/postDepartmentHead', methods=['POST'])
def postDepartmentHead():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    departmentId = request.form['departmentID']
    professorId = request.form['professorID']
    query = f'UPDATE department_table SET DepartmentHead = {professorId} where DepartmentID = {departmentId}'
    cursor.execute(query)
    db.get_db().commit()
    return ""

@advisors.route('/getAdvisorsStudentData/<advisorID>', methods=['GET'])
def get_AdvisorsStudentData(advisorID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from student_table WHERE advisorID = {advisorID}')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@advisors.route('/getCoursesData')
def getCoursesData():
    cursor = db.get_db().cursor()
    cursor.execute('select * from course_table')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@advisors.route('/getSectionData/<CourseID>')
def getSectionData(CourseID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from section_table where section_table.CourseID = {CourseID}')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

@advisors.route('/postSection', methods=['POST'])
def postSection():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    SectionId = request.form['SectionID']
    Semester = request.form['Semester']
    ProfessorID = request.form['ProfessorID']
    CourseID = request.form['CourseID']
    Year = request.form['Year']
    
    query = f'insert into section_table (SectionID, Semester, ProfessorID, CourseID, SectionYear) values ({SectionId}, {Semester}, {ProfessorID}, {CourseID}, {Year});'
    cursor.execute(query)
    db.get_db().commit()
    return ""
