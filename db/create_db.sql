CREATE DATABASE cool_db;

grant all privileges on cool_db.* to 'webapp'@'%';

CREATE USER 'student1'@'%' IDENTIFIED BY 'student1_password';
CREATE USER 'professor1'@'%' IDENTIFIED BY 'professor1_password';
CREATE USER 'advisor1'@'%' IDENTIFIED BY 'advisor1_password';
GRANT SELECT ON cool_db.* to 'student1'@'%';
GRANT SELECT ON cool_db.* to 'professor1'@'%';
GRANT ALL PRIVILEGES ON cool_db.student_section_table TO 'professor1'@'%';
GRANT ALL PRIVILEGES ON cool_db.professor_table to 'professor1'@'%';
GRANT ALL PRIVILEGES ON cool_db.* TO 'advisor1'@'%';
FLUSH PRIVILEGES;

USE cool_db;
CREATE TABLE department_table (

    DepartmentID INT(7) zerofill not null AUTO_INCREMENT,
    Name VARCHAR(40) NOT NULL,
    -- DepartmentHead INT,
    PRIMARY KEY(DepartmentID)
);

CREATE TABLE professor_table (
    ProfessorID INT(7) zerofill AUTO_INCREMENT,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(40) NOT NULL,
    DepartmentID INT(7) zerofill NOT NULL,
    PRIMARY KEY(ProfessorID),
        CONSTRAINT fk_01 FOREIGN KEY (DepartmentID)
        REFERENCES department_table (DepartmentID)
        ON UPDATE cascade ON DELETE restrict
);

ALTER TABLE department_table
ADD DepartmentHead INT(7) zerofill;

ALTER TABLE department_table
ADD FOREIGN KEY (DepartmentHead) REFERENCES professor_table (ProfessorID)
ON UPDATE cascade ON DELETE restrict;

CREATE TABLE major_table (
    MajorID INT NOT NULL CHECK (MajorID BETWEEN 0000000 AND 9999999),
    Name VARCHAR(40) NOT NULL,
    DepartmentID INT(7) zerofill NOT NULL,
    PRIMARY KEY(MajorID),
        CONSTRAINT fk_02 FOREIGN KEY (DepartmentID)
        REFERENCES department_table (DepartmentID)
        ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE minor_table
(
    MinorID INT NOT NULL CHECK(MinorID BETWEEN 0000000 AND 9999999),
    Name VARCHAR(40),
    DepartmentID INT(7) zerofill NOT NULL,
    PRIMARY KEY(MinorID),
    CONSTRAINT fk_03 FOREIGN KEY (DepartmentID)
        REFERENCES department_table(DepartmentID)
        ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE advisor_table (

    AdvisorID INT(7) zerofill NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(40) NOT NULL,
    DepartmentID INT(7) zerofill NOT NULL,
    PRIMARY KEY(AdvisorID),
    CONSTRAINT fk_04 FOREIGN KEY (DepartmentID)
        REFERENCES department_table (DepartmentID)
        ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE course_table (

    CourseID int NOT NULL CHECK (CourseID BETWEEN 0000000 AND 9999999),
    Name varchar(40) NOT NULL,
    DepartmentID int(7) zerofill NOT NULL,
    Credits int NOT NULL,
    PRIMARY KEY (CourseID),
    CONSTRAINT fk_05 FOREIGN KEY (DepartmentID)
      REFERENCES department_table(DepartmentID)
      ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE prerequisites_table (

    NextCourse INT NOT NULL,
    RequiredCourse INT NOT NULL,
    DateAdded DATE,
    CONSTRAINT fk_06 FOREIGN KEY (NextCourse)
        REFERENCES course_table (CourseID)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_07 FOREIGN KEY (RequiredCourse)
        REFERENCES course_table (COURSEID)
        ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE corequisites_table (

    Course1 INT,
    Course2 INT,
    CONSTRAINT fk_08 FOREIGN KEY (Course1)
        REFERENCES course_table (CourseID)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_09 FOREIGN KEY (Course2)
        REFERENCES course_table (CourseID)
        ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE section_table (

    SectionID int NOT NULL CHECK (SectionID BETWEEN 0000000 AND 9999999),
    Semester varchar(20) NOT NULL,
    ProfessorID int(7) zerofill NOT NULL,
    CourseID int NOT NULL,
    SectionYear int NOT NULL,
    PRIMARY KEY (SectionID),
    CONSTRAINT fk_10 FOREIGN KEY (ProfessorID)
      REFERENCES professor_table(ProfessorID)
      ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_11 FOREIGN KEY (CourseID)
      REFERENCES course_table(CourseID)
      ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE instruction_period (

    PeriodID INT(7) zerofill NOT NULL AUTO_INCREMENT,

    InstructionalMethod VarChar(40),
    InstructionDate DATE,
    InstructionTime TIME,
    SectionID INT,
    PRIMARY KEY(PeriodID),
    CONSTRAINT fk_13 FOREIGN KEY (SectionID)
      REFERENCES section_table(SectionID)
      ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE student_table
(
    StudentID INT(9) zerofill NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(40),
    LastName VARCHAR(40),
    MiddleInitial VARCHAR(1),
    GPA DOUBLE(5, 4) NOT NULL,
    StartYear YEAR NOT NULL,
    GraduationYear YEAR NOT NULL,
    BirthDate DATE NOT NULL,
    Age INT NOT NULL,
    MajorID INT NOT NULL,
    MinorID INT,
    AdvisorID INT(7) zerofill NOT NULL,
    CreditsCompleted DOUBLE(4, 1) NOT NULL,
    Enrolled BOOLEAN NOT NULL,
    PRIMARY KEY(StudentID),
    CONSTRAINT fk_14 FOREIGN KEY (MajorID)
        REFERENCES major_table(MajorID)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_15 FOREIGN KEY (MinorID)
        REFERENCES minor_table(MinorID)
        ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_16 FOREIGN KEY (AdvisorID)
        REFERENCES advisor_table(AdvisorID)
        ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE sectionta_table (

    EmploymentID int(7) zerofill NOT NULL AUTO_INCREMENT,
    StudentID int(9) zerofill NOT NULL,
    SectionID int NOT NULL,
    TotalPay Decimal(2) NOT NULL,
    DollarPerHour Decimal(2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalHours Decimal(2) NOT NULL,
    PRIMARY KEY (EmploymentID),
    CONSTRAINT fk_17 FOREIGN KEY (StudentID)
      REFERENCES student_table(StudentID)
      ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_18 FOREIGN KEY (SectionID)
      REFERENCES section_table(SectionID)
      ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE student_section_table (

    StudentID INT(9) zerofill,
    SectionID INT NOT NULL,
    Grade DOUBLE(6, 4) NOT NULL,
    Passing BOOLEAN,
    PRIMARY KEY (StudentID, SectionID),
    CONSTRAINT fk_19 FOREIGN KEY (StudentID)
      REFERENCES student_table(StudentID)
      ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_20 FOREIGN KEY (SectionID)
      REFERENCES section_table(SectionID)
      ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE weeklypayment_table (

    PaymentID int(7) zerofill NOT NULL AUTO_INCREMENT,
    EmploymentID int(7) zerofill NOT NULL,
    WeekHours Decimal(2) NOT NULL,
    WeekStartDate DATE NOT NULL,
    PRIMARY KEY (PaymentID),
    CONSTRAINT fk_21 FOREIGN KEY (EmploymentID)
      REFERENCES sectionta_table(EmploymentID)
      ON UPDATE cascade ON DELETE restrict

);

INSERT INTO department_table(Name) VALUES ('Mathematics');
INSERT INTO department_table(Name) VALUES ('Physics');
INSERT INTO department_table(Name) VALUES ('Computer Science');
INSERT INTO department_table(Name) VALUES ('Accounting');
INSERT INTO department_table(Name) VALUES ('MISM');
INSERT INTO department_table(Name) VALUES ('Data Science');
INSERT INTO department_table(Name) VALUES ('Political Science');
INSERT INTO department_table(Name) VALUES ('English');
INSERT INTO department_table(Name) VALUES ('Music');
INSERT INTO department_table(Name) VALUES ('Media Arts');
INSERT INTO department_table(Name) VALUES ('Communications');
INSERT INTO department_table(Name) VALUES ('MSCR');
INSERT INTO department_table(Name) VALUES ('Italian');
INSERT INTO department_table(Name) VALUES ('Cybersecurity');
INSERT INTO department_table(Name) VALUES ('Finance');

INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Rey','Robertucci',14);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Prentice','Rassmann',10);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Clarence','Dumberrill',13);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Shep','Mottram',10);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Wadsworth','Snare',2);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Elvera','Haime',9);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Alysia','Gabby',4);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Jorie','Browncey',15);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Idell','Iaduccelli',9);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Michelina','Coveny',1);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Evey','Rossi',4);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Katusha','Bogue',1);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Jammal','Ladbrooke',11);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Keefer','Millichap',7);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Miranda','Louthe',13);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Elvis','Sheeres',14);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Drusi','Smitheram',4);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Darbie','Goodram',9);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Hew','Stripling',9);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Marybelle','McCart',9);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Jess','Radloff',14);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Dorey','Meneux',15);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Maegan','Whitrod',6);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Jorry','Tewkesbury.',13);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Amil','Morgan',5);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Amabelle','Klampk',13);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Merilee','Townley',13);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Baxie','Dreng',7);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Adriaens','Huish',3);
INSERT INTO professor_table(FirstName,LastName,DepartmentID) VALUES ('Sephira','Panther',14);

INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6129283,'Applied Finance',12);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (2184625,'Political Science',14);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6583401,'Computer Science',6);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (7725579,'Data Science',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6687189,'Cybersecurity',2);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (4375773,'Supply Chain Management',12);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (5663476,'Accounting',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8597469,'Communications',13);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3294284,'Biology',9);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6192056,'Bioinformatics',15);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3098253,'Informatics',8);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3296267,'Chemistry',7);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (1101582,'Physics',7);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6797946,'Mathematics',3);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8325655,'Applied Mathematics',13);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8032888,'Chemical Engineering',15);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (2203103,'Electrical Engineering',2);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8936353,'Mechanical Engineering',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3995021,'Civil Engineering',10);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8570211,'Software Engineering',13);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (7906555,'Criminology',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (2815777,'Psychology',5);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8083491,'Anthropology',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (5661758,'Economics',12);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (456341,'Geography',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3359504,'Sociology',14);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (8393724,'History',8);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6922268,'Animal Sciences',4);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (995324,'Zoology',2);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (4962890,'Microbiology',3);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (7621991,'Geology',5);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (81868,'Agriculture',11);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3629805,'Child Development',6);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (5441356,'Public Health',1);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (6428773,'Theatre Arts',10);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3636443,'Film Studies',10);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (5826315,'Graphic Design',6);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (3565876,'Architecture',2);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (7090452,'Photography',8);
INSERT INTO major_table(MajorID,Name,DepartmentID) VALUES (4522544,'Studio Arts',11);

INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (4657287,'Physics',12);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (8726302,'Chemistry',10);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (717950,'Computer Science',1);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (2646590,'Communications',2);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (3205823,'French',4);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (7121794,'English',12);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (4653959,'Spanish',5);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (4641613,'Japanese',2);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (9488331,'Italian',13);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (3347646,'Accounting',3);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (2548516,'Innovation',11);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (2109778,'Finance',14);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (4840223,'Supply Chain',14);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (5521915,'Screen Studies',6);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (4703667,'Art',6);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (1763078,'Photography',4);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (9624246,'Theatre Arts',4);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (3027830,'Public Health',7);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (196724,'Data Science',3);
INSERT INTO minor_table(MinorID,Name,DepartmentID) VALUES (4358051,'Mathematics',2);

INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Karyn','Lamping',6);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Giles','Skakunas',7);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Hedwig','Fowlestone',15);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Kynthia','Ezzle',8);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Arney','Hegges',2);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Rosaline','Loxdale',5);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Korney','Henningham',7);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Harlie','Huws',8);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Penn','Granleese',2);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Cassie','Queyos',8);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Johnathan','Capey',10);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Lind','Donovan',15);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Dione','Skpsey',6);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Alasteir','MacMeeking',3);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Doreen','Kinlock',11);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Dewey','Reinhart',8);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Brigham','Venard',14);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Viki','Petris',2);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Perle','Sanches',9);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Tracey','Astling',1);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Gustaf','Giraudo',15);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Brigham','Beldum',13);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Christophorus','Bottjer',5);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Dania','Goldes',1);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Judie','Housbey',8);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Morten','Gibbeson',1);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Freddie','Maplethorpe',11);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Stirling','Lambertson',12);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Tate','Roubert',2);
INSERT INTO advisor_table(FirstName,LastName,DepartmentID) VALUES ('Loy','Allred',15);

INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (3633419,'Intro to Earth Sciences',14,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (5953493,'User Interface Design',3,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (1655449,'Human Interaction With Tech',3,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (3991019,'Social Work Principles',2,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (1984381,'Cryptography',9,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (9652437,'Claymation',9,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (7081050,'Dynamic Earth',11,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (2977490,'Strategy in Action',7,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (2534039,'Soil and Rocks',8,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (5652623,'High Level Management',4,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (622801,'Mobile Development',5,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (710326,'Hostage Negotiation',13,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4818312,'Architecture 1',4,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (1009770,'Sports Arena Management',9,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (5398377,'Orchestral Instrumentation',2,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4354166,'Developing a Business',14,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (7512334,'Object-Oriented Design',5,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (1101331,'Management Information Systems',9,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (6722675,'Financial Management',12,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (3687096,'Government and Military',15,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4893066,'National Security',12,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4433616,'Intro to Film Studies',8,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (3514397,'Film Composition',15,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4877306,'Environmental Studies 1',13,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (918553,'Foreign Affairs',1,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (5065723,'Dance',14,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4468428,'Networks',3,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (4942663,'Interdimensional Portals',5,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (8616686,'Project Management',15,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (7260266,'Orchestration',7,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (6449008,'Organic Chemistry',2,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (6366305,'Intro to Cybersecurity',15,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (8106635,'Intro to Photography',13,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (3441424,'Political Ideations',4,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (2781079,'US History',3,4);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (2427123,'Circuits and Signals',12,1);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (2510321,'Calculus 1',4,3);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (8901177,'Calculus 2',7,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (5307310,'Optimized Design',7,2);
INSERT INTO course_table(CourseID,Name,DepartmentID,Credits) VALUES (8484156,'Multi-state Organizations',5,1);

INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (3991019,6449008,'2022-09-19');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (1655449,7081050,'2022-07-21');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (5652623,3991019,'2022-07-03');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (4354166,3514397,'2022-12-06');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (5307310,4468428,'2022-11-23');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (2977490,1655449,'2022-06-01');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (9652437,622801,'2022-04-27');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (1009770,710326,'2022-06-23');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (6722675,7512334,'2022-08-14');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (3441424,918553,'2022-06-18');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (8616686,1655449,'2022-03-10');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (3514397,4877306,'2022-04-06');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (5953493,6722675,'2022-02-22');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (6449008,5065723,'2022-03-27');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (4468428,3687096,'2022-06-10');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (1655449,2534039,'2022-02-28');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (918553,4818312,'2022-07-20');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (5953493,1101331,'2022-09-10');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (8616686,1984381,'2022-11-19');
INSERT INTO prerequisites_table(NextCourse,RequiredCourse,DateAdded) VALUES (2534039,1655449,'2022-11-28');

INSERT INTO corequisites_table(Course1,Course2) VALUES (5652623,918553);
INSERT INTO corequisites_table(Course1,Course2) VALUES (2534039,5307310);
INSERT INTO corequisites_table(Course1,Course2) VALUES (4893066,4893066);
INSERT INTO corequisites_table(Course1,Course2) VALUES (7081050,6449008);
INSERT INTO corequisites_table(Course1,Course2) VALUES (4818312,1009770);
INSERT INTO corequisites_table(Course1,Course2) VALUES (3687096,4354166);
INSERT INTO corequisites_table(Course1,Course2) VALUES (5652623,2510321);
INSERT INTO corequisites_table(Course1,Course2) VALUES (4468428,5398377);
INSERT INTO corequisites_table(Course1,Course2) VALUES (1009770,4877306);
INSERT INTO corequisites_table(Course1,Course2) VALUES (6722675,710326);
INSERT INTO corequisites_table(Course1,Course2) VALUES (8484156,7512334);
INSERT INTO corequisites_table(Course1,Course2) VALUES (5065723,2510321);
INSERT INTO corequisites_table(Course1,Course2) VALUES (8484156,7512334);
INSERT INTO corequisites_table(Course1,Course2) VALUES (2534039,4818312);
INSERT INTO corequisites_table(Course1,Course2) VALUES (4942663,2427123);

INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4463489,'Fall',16,2427123,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5225322,'Spring',3,3687096,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5528197,'Summer 1',30,1655449,2022);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (96757,'Summer 2',28,5307310,2015);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (703490,'Spring',9,3514397,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5484503,'Fall',3,5307310,2023);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3880540,'Fall',12,8901177,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (2854732,'Summer 1',25,3991019,2022);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (8077317,'Fall',25,8106635,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4720742,'Summer 2',14,4893066,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1307026,'Spring',3,3441424,2018);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4236633,'Summer 2',11,5652623,2020);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9169929,'Spring',30,1009770,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5043748,'Summer 2',30,2781079,2012);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4349997,'Summer 1',15,710326,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (6991880,'Summer 2',12,4942663,2018);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9370509,'Summer 1',14,918553,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5153928,'Spring',19,1655449,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4504819,'Summer 1',18,2534039,2022);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (2838693,'Fall',6,5953493,2019);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (2100422,'Summer 1',20,1984381,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7735308,'Summer 1',10,9652437,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1047745,'Fall',12,5652623,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4507063,'Summer 1',6,2510321,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (247763,'Fall',4,7081050,2018);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7039655,'Summer 1',5,710326,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1884957,'Summer 2',17,3514397,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5023508,'Fall',21,4877306,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (119003,'Summer 1',28,918553,2023);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9544464,'Spring',15,7260266,2013);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1068418,'Spring',23,4468428,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1311904,'Fall',8,2977490,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (829946,'Spring',13,5065723,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9048206,'Summer 2',11,1009770,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9381854,'Summer 1',1,2781079,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1051317,'Spring',26,7260266,2015);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3580985,'Spring',5,5953493,2015);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (6717554,'Spring',3,5307310,2022);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4567888,'Fall',14,5065723,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1730574,'Spring',26,5398377,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3703069,'Summer 1',27,2781079,2018);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (2525482,'Summer 2',6,3991019,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7336831,'Spring',25,3687096,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (6806802,'Summer 2',20,918553,2011);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (6743270,'Fall',24,8106635,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9895288,'Summer 1',8,4468428,2013);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (350692,'Summer 2',3,3687096,2015);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (956292,'Summer 1',16,622801,2015);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7194156,'Fall',20,6366305,2018);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3890273,'Spring',6,5307310,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4940595,'Summer 2',6,1984381,2019);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1883292,'Summer 2',24,3441424,2011);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (6425830,'Spring',9,9652437,2023);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7178375,'Summer 1',3,2977490,2013);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3366280,'Fall',1,8484156,2017);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1812489,'Summer 2',21,1009770,2012);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7662191,'Summer 2',14,8106635,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (2533106,'Spring',28,1984381,2018);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5524759,'Summer 2',25,3687096,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9381464,'Summer 1',29,8484156,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1962118,'Fall',18,3991019,2010);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (8194815,'Spring',1,4942663,2023);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5850192,'Fall',18,8616686,2020);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4121702,'Fall',30,5307310,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (1405695,'Spring',23,5398377,2010);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3108044,'Fall',6,3441424,2011);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (619310,'Fall',3,1009770,2010);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (9085858,'Summer 2',2,4893066,2015);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (25818,'Fall',20,7081050,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4120483,'Spring',7,918553,2019);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5786947,'Spring',5,710326,2022);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (594221,'Summer 2',8,2781079,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3885645,'Fall',20,2510321,2010);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (3835453,'Fall',1,4468428,2014);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (4282420,'Summer 2',29,710326,2021);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (904822,'Summer 1',21,7512334,2022);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (2102251,'Summer 1',2,1009770,2011);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (7704199,'Summer 1',21,918553,2016);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (6713002,'Fall',6,6366305,2013);
INSERT INTO section_table(SectionID,Semester,ProfessorID,CourseID,SectionYear) VALUES (5031525,'Summer 1',22,8616686,2019);

INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-06-23','6:30:00',904822);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-01-20','10:45:00',7039655);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-01-14','1:00:00',5153928);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-05-20','1:00:00',956292);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2021-12-19','9:30:00',1812489);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-05-13','6:30:00',96757);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-12-07','9:30:00',5786947);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-10-17','5:15:00',1405695);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-03-29','9:30:00',1812489);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-07-07','2:30:00',8077317);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-01-14','6:30:00',1884957);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-10-11','10:45:00',4567888);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-03-17','9:30:00',1047745);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-07-26','2:30:00',3890273);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-04-04','1:00:00',6425830);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-07-10','10:45:00',829946);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-04-01','5:15:00',5524759);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-01-21','5:15:00',9370509);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2021-12-28','1:00:00',3366280);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-03-07','5:15:00',4121702);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-02-05','6:30:00',350692);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-11-07','9:30:00',1047745);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-09-23','5:15:00',619310);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-09-14','5:15:00',9370509);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-06-21','5:15:00',2854732);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-03-26','10:45:00',7704199);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-05-13','5:15:00',8077317);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-08-23','1:00:00',7039655);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-10-21','9:30:00',829946);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-07-04','9:30:00',25818);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-07-09','2:30:00',3835453);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-01-19','2:30:00',4463489);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-06-29','10:45:00',1047745);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-04-18','10:45:00',247763);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-01-07','1:00:00',829946);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-11-10','10:45:00',3885645);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-08-16','9:30:00',350692);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-04-09','1:00:00',6425830);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-06-15','5:15:00',7704199);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-01-06','5:15:00',9169929);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-12-01','9:30:00',5023508);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-07-02','9:30:00',1883292);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-09-13','9:30:00',9895288);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-07-29','1:00:00',4567888);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-04-11','5:15:00',4720742);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-07-10','2:30:00',9370509);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-10-12','9:30:00',1962118);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-10-24','5:15:00',3880540);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-10-24','1:00:00',4504819);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-07-18','2:30:00',829946);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-05-03','10:45:00',7178375);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-10-06','5:15:00',3885645);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-08-19','2:30:00',5225322);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-06-21','2:30:00',7735308);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-08-01','9:30:00',1883292);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-10-04','2:30:00',3108044);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-07-31','5:15:00',7735308);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-03-25','5:15:00',9381464);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2021-12-18','10:45:00',2100422);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-03-04','10:45:00',5023508);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-05-13','1:00:00',247763);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-07-09','5:15:00',1068418);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-07-08','10:45:00',3890273);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-01-28','5:15:00',1307026);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-07-03','5:15:00',350692);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-06-09','10:45:00',1068418);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-05-10','1:00:00',703490);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2021-12-13','10:45:00',4504819);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-09-28','6:30:00',6991880);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-11-10','6:30:00',5528197);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2021-12-15','2:30:00',6717554);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-05-30','9:30:00',2100422);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-10-09','1:00:00',8077317);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-04-02','9:30:00',2525482);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-09-22','2:30:00',3885645);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-05-28','2:30:00',6743270);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-09-22','2:30:00',2854732);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-11-11','2:30:00',5786947);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-05-12','5:15:00',5153928);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-03-06','5:15:00',619310);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-07-30','1:00:00',5225322);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-09-11','5:15:00',3880540);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-12-04','6:30:00',5023508);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-07-04','1:00:00',1311904);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-01-05','2:30:00',96757);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2021-12-31','2:30:00',4567888);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-01-28','9:30:00',6425830);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-02-26','10:45:00',7735308);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-10-03','6:30:00',9544464);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-11-12','9:30:00',1047745);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-09-06','9:30:00',1307026);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-09-13','5:15:00',904822);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-08-28','10:45:00',3580985);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-01-25','9:30:00',9048206);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-01-30','10:45:00',829946);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-05-13','2:30:00',350692);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('In Person','2022-07-28','5:15:00',6806802);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Asynchronous','2022-10-10','10:45:00',904822);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-01-10','6:30:00',2102251);
INSERT INTO instruction_period(InstructionalMethod,InstructionDate,InstructionTime,SectionID) VALUES ('Remote','2022-06-15','9:30:00',1962118);

INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Elita','Perassi','A',3.7594,2022,2027,'2004-02-29',22,6192056,2646590,14,39.4,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Celestia','Lewnden','C',0.7144,2022,2027,'2013-01-26',18,7725579,NULL,24,17.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Carmencita','d''Arcy','B',3.3193,2019,2025,'2004-02-04',17,5663476,NULL,21,18.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Abran','Midgely','B',0.2616,2019,2023,'2014-12-29',22,2203103,NULL,30,186.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Elane','Lidyard','C',0.1447,2022,2026,'2022-01-08',22,3359504,NULL,16,181,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Levey','Boxhall','C',1.1995,2018,2025,'2006-04-15',17,6129283,9488331,27,115.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Shawnee','Meanwell','A',3.4534,2019,2024,'2018-09-12',20,5661758,NULL,28,88.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Amabelle','Sanzio','B',2.5626,2020,2027,'2006-06-10',17,6797946,NULL,27,74.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Kare','Bendon','A',0.7248,2018,2025,'2012-02-17',19,6687189,3027830,1,123.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jasmin','Barnes','C',0.5041,2022,2025,'2014-12-16',20,456341,7121794,22,47.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Lanae','Hatch','B',0.4803,2018,2023,'2020-06-16',19,3629805,2646590,24,33.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Bent','Nott','B',2.5379,2019,2026,'2009-04-20',17,3098253,NULL,24,59.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Liva','MacMoyer','C',2.0457,2021,2024,'2022-05-16',17,3359504,2548516,15,3.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Heather','Lippitt','C',0.3586,2018,2023,'2019-01-28',20,3294284,NULL,12,146.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Katie','Hillyatt','A',3.4109,2022,2023,'2013-03-01',18,6583401,NULL,25,136.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Sheppard','Jozef','A',2.3895,2019,2026,'2014-10-19',17,4522544,1763078,20,43.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Karlotta','Bangham','B',1.0105,2019,2027,'2009-07-16',22,7906555,NULL,15,72.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Kelsi','Venour','B',3.7332,2022,2026,'2012-03-08',22,3359504,NULL,18,91,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Belle','Carleman','C',1.2062,2021,2027,'2021-01-23',19,8325655,NULL,1,105.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Alane','Edmonston','B',3.7105,2018,2026,'2004-04-11',21,6428773,NULL,16,173.8,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Anthia','Pygott','B',0.6163,2021,2026,'2006-09-01',19,2815777,NULL,29,188.8,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Elli','Sahlstrom','B',3.144,2020,2023,'2008-06-23',18,8393724,4358051,14,64.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Fidole','Durram','B',2.9315,2018,2025,'2021-05-25',20,995324,NULL,17,39.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Bondie','Learmonth','B',2.4873,2021,2023,'2018-05-27',22,5826315,2109778,14,79.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Dolores','Bellelli','B',3.4728,2022,2023,'2017-03-05',19,6428773,4641613,8,37.6,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Greta','Niblo','C',0.7866,2021,2023,'2011-09-30',19,3294284,NULL,6,5.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Kylynn','Whorf','B',2.0842,2022,2023,'2014-01-21',19,6922268,NULL,20,178.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Alvira','Haythorn','A',3.0497,2019,2024,'2021-08-09',17,7090452,NULL,10,142.3,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Cristobal','Pietersma','B',0.5773,2019,2023,'2004-12-08',21,4522544,NULL,4,58,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Douglas','Inott','C',0.7679,2019,2023,'2016-02-12',19,2815777,NULL,29,172.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Padraig','Godson','C',3.9055,2018,2025,'2009-03-18',18,6922268,NULL,4,106.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Byram','Conkling','A',1.7657,2018,2027,'2016-06-17',20,5663476,NULL,12,15.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Christopher','Galvin','C',2.0785,2021,2025,'2007-03-04',21,2184625,NULL,3,110.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Dana','McGeoch','A',3.2265,2022,2024,'2022-07-17',21,6428773,NULL,12,4.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Stephani','Fryett','A',1.3038,2018,2024,'2011-03-13',21,8393724,NULL,1,155.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jo','Devonport','B',2.1896,2022,2023,'2022-05-02',18,3296267,2548516,1,68.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Mollee','Costy','B',2.0473,2020,2023,'2011-06-18',22,3995021,3347646,25,108.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Durante','Fruen','B',0.1002,2019,2026,'2010-07-25',20,8083491,4641613,26,75.9,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Janene','Stanlock','B',3.0609,2019,2025,'2016-12-16',18,8393724,5521915,23,161.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Moyra','McKeighen','B',3.1275,2019,2027,'2016-11-15',18,4375773,NULL,8,83.8,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Annora','Guyonneau','C',0.3663,2018,2025,'2012-01-16',18,6192056,NULL,12,186.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Roth','Mary','A',2.1555,2022,2023,'2004-03-01',22,5661758,NULL,19,6.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Euphemia','Boulds','A',2.1248,2021,2023,'2019-06-05',21,6129283,5521915,3,12.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Haleigh','O'' Dornan','A',3.759,2019,2025,'2019-04-25',18,7090452,3347646,4,58.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Marcelia','Greeson','B',2.2716,2018,2027,'2006-01-26',18,7725579,2548516,5,45.9,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Brandi','Meert','B',3.8001,2018,2025,'2009-08-19',21,5826315,NULL,3,107.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Reagen','Couvert','A',2.8009,2018,2025,'2018-12-15',22,3359504,NULL,16,189.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Dahlia','Menat','C',1.3751,2022,2025,'2022-08-19',17,4375773,NULL,30,156,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Dex','Iskowicz','B',2.6768,2018,2027,'2020-07-31',18,81868,NULL,1,157.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Charo','Karpinski','C',3.9557,2020,2024,'2016-10-13',22,6129283,9488331,9,168.6,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Melodee','Seleway','B',3.801,2021,2023,'2013-01-01',20,3629805,196724,9,100.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Emilie','Larham','A',0.9898,2018,2027,'2008-07-18',19,7725579,NULL,12,186.4,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Chilton','Cannop','C',2.6269,2020,2027,'2022-07-27',21,6687189,NULL,18,78.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Barn','Dusting','B',0.4616,2021,2023,'2020-03-07',19,5826315,NULL,8,81.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Zondra','de Mullett','B',3.3416,2019,2023,'2013-10-20',20,8325655,NULL,5,193.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Cesare','Estable','C',1.9141,2022,2026,'2012-08-16',20,456341,NULL,9,136.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Christal','Cristoforetti','A',2.2788,2018,2023,'2004-12-11',21,8325655,9488331,26,77.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Brose','Eversley','C',1.8299,2018,2023,'2020-06-07',18,7906555,2646590,3,173.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Phaedra','Ruxton','B',3.6039,2018,2025,'2008-01-21',18,6583401,7121794,24,72.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Annie','Kerss','A',1.7719,2020,2026,'2010-12-11',22,3636443,8726302,22,46.9,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Owen','Baynes','B',1.5894,2018,2026,'2021-09-22',19,3296267,2109778,10,83.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Elfreda','Bristow','A',1.7946,2022,2027,'2014-06-05',18,8597469,NULL,13,156,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Greer','Laverock','C',3.3851,2019,2024,'2007-03-09',22,7090452,NULL,3,74.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Lynde','Hearley','C',1.8433,2021,2025,'2006-04-03',18,3296267,NULL,14,101.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Rip','Brydson','A',3.3218,2020,2024,'2008-02-05',20,995324,NULL,6,28,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Lyn','Daintry','A',1.428,2020,2023,'2014-05-25',20,6583401,4840223,20,88.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Mel','Klesel','B',0.1935,2022,2027,'2009-07-13',18,8325655,4358051,28,59.6,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Seamus','Ksandra','B',1.0369,2021,2026,'2007-10-10',20,3098253,NULL,21,21.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Phebe','Windybank','B',1.6622,2021,2026,'2019-04-10',20,1101582,NULL,9,73.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Faith','Strooband','C',2.2544,2021,2023,'2019-10-17',17,456341,1763078,30,3.5,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Krishnah','Bogue','C',1.325,2019,2025,'2018-07-12',19,3636443,4703667,25,168.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Stace','Greenless','A',2.9364,2022,2024,'2007-10-18',17,6797946,NULL,16,187.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Betsy','Rosettini','B',3.3889,2022,2025,'2006-12-26',22,6687189,2548516,11,78.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Robenia','Schoolcroft','B',3.2038,2018,2024,'2019-03-18',18,3359504,717950,25,101.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Shelly','Kamenar','C',1.6044,2022,2025,'2018-10-03',22,8597469,7121794,12,79.8,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Tawsha','Campelli','A',1.325,2021,2025,'2021-06-12',18,6583401,NULL,13,61.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Pacorro','Dombrell','B',0.3191,2020,2023,'2022-03-18',19,6428773,NULL,23,85.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Merell','Gadaud','C',0.1484,2021,2027,'2007-11-17',22,1101582,NULL,11,122.3,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Shea','Kingsnoad','A',0.2192,2020,2023,'2011-07-07',18,8570211,196724,17,49.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Arlen','Gravells','C',1.8571,2018,2023,'2020-10-14',21,3296267,2548516,22,143.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Tiebold','Wort','C',0.9113,2018,2026,'2016-01-13',21,4375773,7121794,1,160,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Danice','Crichton','A',2.3223,2018,2026,'2012-06-06',21,5661758,NULL,14,134.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Fee','Doy','B',0.239,2019,2023,'2017-08-15',22,7621991,NULL,14,7.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Carri','Mullin','A',1.4455,2018,2026,'2021-04-12',20,5826315,9488331,14,131.9,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Trstram','Varvara','B',3.9817,2020,2023,'2011-09-07',18,1101582,NULL,28,63.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Juliane','Giacomucci','B',2.5917,2022,2027,'2014-05-19',21,995324,4653959,21,102,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Malva','Althorpe','A',3.173,2019,2025,'2007-02-21',22,8083491,1763078,29,177.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Flint','Broddle','B',3.3813,2018,2025,'2008-09-11',20,8032888,NULL,3,55.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Morissa','Bridgman','C',3.2773,2022,2026,'2012-05-31',19,3995021,3347646,24,196.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Kailey','Laddle','B',2.9306,2022,2026,'2015-04-30',21,6687189,NULL,7,29,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Tyne','Backhurst','B',2.8929,2018,2026,'2019-11-03',22,3296267,NULL,20,74.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Chelsy','Kelby','A',1.7365,2019,2026,'2018-10-21',17,3294284,5521915,21,77.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Tabitha','Vickarman','A',0.2427,2019,2023,'2003-12-13',19,2203103,NULL,22,78.3,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jasun','Bidnall','C',0.225,2021,2026,'2017-04-13',22,8393724,NULL,5,97.6,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Onfre','Winman','A',1.0108,2021,2026,'2019-11-11',19,2815777,NULL,28,175.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Ted','Brower','C',2.1927,2022,2025,'2022-05-20',20,8032888,NULL,7,131,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Brandyn','Titherington','C',2.7985,2021,2024,'2004-09-19',22,5663476,4840223,2,37.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Gretel','Chicco','A',1.2097,2019,2024,'2012-03-04',21,4962890,NULL,21,1.4,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Novelia','Ashfull','C',2.9137,2022,2026,'2015-10-02',19,8936353,717950,1,15.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Andrea','Mariotte','A',0.6922,2019,2027,'2008-05-17',18,456341,NULL,13,154.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Nance','Cobain','A',2.2823,2022,2026,'2005-04-03',19,3296267,NULL,1,92.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Mollie','Oulner','A',2.3742,2021,2024,'2004-09-17',17,6192056,NULL,30,77.3,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Marys','Southgate','A',3.8196,2021,2023,'2020-07-24',17,6428773,NULL,24,50.8,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Yovonnda','Negus','B',2.1043,2020,2025,'2004-05-04',18,3636443,NULL,26,189.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Ali','Armer','C',2.8094,2021,2026,'2011-05-19',17,8597469,4703667,4,149.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Archibaldo','Olechnowicz','C',1.0233,2018,2024,'2020-04-15',17,8325655,NULL,25,59.2,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Lane','Churchman','B',3.1083,2019,2024,'2019-04-03',22,1101582,NULL,26,43.6,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Hallsy','Jelleman','B',0.2976,2018,2024,'2021-07-23',17,3294284,NULL,17,54.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Carlye','June','A',1.9195,2021,2023,'2020-09-13',19,3565876,4703667,16,133,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Levin','Kilpatrick','C',2.2772,2018,2026,'2017-09-10',20,81868,3027830,14,106,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Aguistin','Bale','A',1.4989,2020,2027,'2007-03-09',17,7090452,NULL,26,110.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Janaye','Sykes','B',2.6211,2020,2026,'2013-09-30',18,5661758,NULL,11,171.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Aliza','Govern','A',1.0993,2019,2026,'2009-01-22',18,5663476,NULL,12,58.5,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Val','Tempest','C',3.1763,2020,2024,'2018-01-15',18,3629805,NULL,11,196.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jonell','Featherbie','B',0.7088,2020,2026,'2013-07-31',20,6922268,3205823,15,107.9,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Viva','Cunnow','C',0.8039,2018,2025,'2011-05-29',21,3098253,NULL,18,147.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Gwennie','Weeke','A',1.0489,2019,2027,'2004-10-18',19,6428773,NULL,24,147.9,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Carmelita','Calbrathe','A',1.0214,2021,2026,'2009-07-09',17,3294284,NULL,26,177.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Rodi','Eskell','A',3.1898,2022,2026,'2015-03-08',17,2184625,NULL,30,98.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Esta','Forsard','A',3.9422,2021,2026,'2022-12-07',20,7906555,NULL,21,20.1,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Padraic','McNeish','B',0.585,2018,2024,'2010-02-21',22,3629805,717950,15,71.8,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Erda','Dargavel','B',3.3084,2018,2025,'2010-01-29',21,6583401,9624246,9,60.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Ophelia','Phipard-Shears','B',2.165,2018,2024,'2006-10-29',19,4375773,NULL,29,166.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Nicolis','Challis','C',0.8454,2020,2027,'2010-04-04',20,8597469,2646590,18,139.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Revkah','Malshinger','A',0.4808,2022,2027,'2010-01-17',20,6687189,4657287,5,98.8,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Amabel','Cavie','C',0.6947,2021,2026,'2015-11-28',19,3636443,NULL,2,167.2,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Dode','Daniells','B',2.9999,2019,2023,'2014-07-22',17,3565876,NULL,26,121.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Briana','Kanwell','B',1.9155,2018,2023,'2013-03-20',17,6797946,NULL,12,127.7,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Clemens','Acutt','B',1.6818,2019,2024,'2014-11-12',21,5826315,4703667,4,37.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Tisha','O''Nowlan','C',2.453,2021,2026,'2005-03-06',21,8936353,2109778,15,143.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Candida','Mabe','C',0.6578,2019,2023,'2007-09-19',22,3359504,4358051,20,11.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Eleanore','Mendenhall','C',2.232,2020,2026,'2005-08-07',20,995324,4657287,16,135.8,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jessy','Brewett','C',3.554,2018,2026,'2011-04-09',21,3629805,NULL,25,170.1,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Abbe','Ferroli','C',1.3359,2022,2027,'2012-10-15',19,8032888,NULL,1,66,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Rafael','Fumagallo','A',0.5762,2019,2023,'2018-09-04',19,3995021,5521915,6,66.6,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Hobie','Ledgeway','A',3.3403,2019,2023,'2018-11-26',20,4375773,1763078,5,183.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Maxy','Jiroudek','C',0.1819,2022,2023,'2012-03-10',17,7906555,4703667,26,61.4,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Raymund','Sherrett','B',1.0624,2018,2024,'2012-09-12',22,456341,NULL,29,86.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Burlie','Newlan','A',3.392,2020,2023,'2006-09-21',21,7090452,4840223,20,148.8,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Meghann','Offill','A',0.5529,2018,2023,'2005-10-06',20,7621991,NULL,20,174.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Enoch','McCurley','A',1.2804,2018,2026,'2021-12-09',22,81868,NULL,18,130.3,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Rycca','Warrington','A',0.7477,2018,2026,'2016-06-09',22,6192056,NULL,2,55,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Wolfie','Gutcher','C',1.31,2018,2025,'2007-10-29',20,5663476,9488331,4,125.8,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Milicent','Childerley','C',3.9994,2018,2025,'2011-02-18',22,6583401,NULL,9,113.6,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Hester','Wilne','A',2.8133,2021,2023,'2022-03-26',20,5826315,4641613,16,48.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Rosana','Hammerton','C',0.0945,2022,2024,'2017-04-13',17,1101582,3027830,11,26.9,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Akim','Pont','A',2.3273,2019,2025,'2005-11-16',22,6797946,NULL,14,167.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Madelin','Pendre','A',2.2573,2020,2026,'2021-05-20',18,7725579,NULL,1,72.3,1);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jacob','Matejovsky','C',1.9932,2020,2024,'2009-03-22',18,3294284,NULL,7,104.7,0);
INSERT INTO student_table(FirstName,LastName,MiddleInitial,GPA,StartYear,GraduationYear,BirthDate,Age,MajorID,MinorID,AdvisorID,CreditsCompleted,Enrolled) VALUES ('Jeremiah','Dankersley','A',1.9215,2019,2024,'2016-03-14',20,3098253,NULL,19,139.4,0);

INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (113,1884957,20.97,18.71,'2019-10-11','2020-10-11',88.46);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (79,4720742,18.54,21.14,'2020-08-28','2021-08-28',61);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (27,4236633,19.97,20.17,'2021-04-14','2022-04-14',75.04);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (1,3885645,16.24,16.58,'2021-08-20','2022-08-20',58.18);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (16,5031525,26.62,16.06,'2020-02-20','2021-02-20',10.76);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (30,4720742,23.62,21.42,'2020-04-27','2021-04-27',42.71);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (2,2838693,45.77,21.83,'2022-05-06','2023-05-06',42.31);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (120,904822,44.79,16.09,'2022-05-06','2023-05-06',19.35);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (134,7336831,23.13,21.83,'2019-06-07','2020-06-07',47.87);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (60,6717554,25.98,21.33,'2019-08-04','2020-08-04',41.86);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (83,3366280,13.58,18.15,'2019-06-02','2020-06-02',4.92);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (139,1405695,36.32,15.07,'2020-06-07','2021-06-07',93.77);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (105,4349997,43.02,17.45,'2019-12-25','2020-12-25',47.6);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (23,3880540,48.5,18.08,'2020-08-12','2021-08-12',36.51);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (86,5225322,21.57,21.11,'2019-11-07','2021-08-12',67.01);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (75,119003,34.96,17.96,'2020-12-20','2021-12-20',47.58);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (39,4121702,47.61,16.71,'2021-12-15','2022-12-15',45.56);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (118,3703069,28.7,18.03,'2020-05-29','2021-05-29',50.37);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (122,8077317,27.71,16.87,'2020-08-01','2022-08-01',8.58);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (44,6806802,26.19,21.56,'2019-12-06','2020-12-06',33.56);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (12,9544464,48.66,18.81,'2020-10-17','2021-10-17',23.4);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (53,9048206,20.42,19.53,'2021-05-30','2022-05-30',74.9);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (119,5524759,24.61,18.74,'2019-10-31','2020-10-31',23.5);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (57,7178375,54.72,16.1,'2020-06-05','2021-06-05',79.06);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (113,594221,19.47,16.86,'2022-04-21','2023-04-21',40.7);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (97,7735308,33.15,20.44,'2022-04-09','2023-04-09',59.92);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (113,7735308,36.79,19.46,'2019-12-16','2020-12-16',53.72);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (101,3580985,80.91,15.43,'2022-01-03','2023-01-03',49.2);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (60,5043748,10.34,18.98,'2019-10-12','2020-10-12',29.26);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (14,1962118,34.98,16.23,'2022-04-13','2023-04-13',19.13);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (63,1812489,24.8,18.25,'2021-05-15','2022-05-15',69.51);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (64,5850192,46.79,19.29,'2022-01-24','2023-01-24',65.48);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (118,4463489,45.35,16.8,'2022-06-12','2023-06-12',17.55);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (139,5023508,15.1,15.09,'2021-10-28','2022-10-28',88.02);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (137,7662191,34.44,15.17,'2021-03-16','2022-03-16',43.17);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (31,3880540,45.13,19.46,'2019-07-24','2020-07-24',60.03);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (54,4463489,26.27,19.95,'2020-06-08','2021-06-08',32.99);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (95,3890273,49.74,15.31,'2022-08-05','2023-08-05',95.99);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (28,4504819,12.41,21.17,'2020-02-10','2021-02-10',17.06);
INSERT INTO sectionta_table(StudentID,SectionID,TotalPay,DollarPerHour,StartDate,EndDate,TotalHours) VALUES (31,1405695,6.9,19.65,'2018-12-11','2019-12-11',17.94);

INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (138,956292,37.5367,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (97,4349997,28.6558,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (6,3880540,51.1242,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (21,9169929,16.9779,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (4,7704199,38.0533,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (9,4507063,5.662,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (134,3890273,16.9189,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (10,1962118,9.5778,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (111,5528197,41.9516,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (89,119003,3.5878,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (63,6713002,49.836,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (128,6425830,25.3873,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (133,6806802,2.9019,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (40,829946,39.7813,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (53,3580985,57.7458,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (121,4463489,53.1734,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (16,9085858,40.1532,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (36,9895288,11.3827,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (72,3835453,99.6464,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (93,5043748,91.2438,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (65,7194156,55.2543,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (131,703490,61.6967,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (84,7178375,1.0392,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (114,7704199,26.9805,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (24,594221,37.4889,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (43,1051317,21.3951,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (146,4282420,24.3272,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (29,1405695,48.6869,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (60,1068418,13.9401,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (43,3835453,71.781,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (126,1311904,99.1935,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (140,7704199,89.461,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (77,1962118,93.5551,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (128,956292,79.787,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (4,3366280,87.4858,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (11,7194156,96.326,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (57,3835453,13.3885,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (48,3703069,60.7842,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (144,7662191,4.968,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (113,4121702,87.6013,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (80,3366280,2.5305,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (15,1730574,63.266,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (65,3885645,90.8402,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (24,4567888,65.7842,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (77,8194815,59.9658,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (41,1047745,64.386,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (115,119003,75.7634,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (128,4120483,83.8898,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (114,703490,30.811,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (112,247763,81.6333,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (67,9544464,56.3871,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (6,7194156,26.7322,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (40,1068418,20.3569,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (7,2102251,26.9581,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (100,9169929,9.6084,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (76,2100422,2.2025,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (131,96757,48.889,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (33,1884957,10.0742,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (104,5225322,34.8717,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (127,4282420,69.2697,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (127,9370509,74.2873,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (119,5524759,4.4426,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (128,904822,10.9198,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (124,9085858,20.6823,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (136,2525482,25.8168,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (134,7704199,70.6322,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (77,3885645,22.4582,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (125,4120483,46.4498,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (110,9895288,5.7637,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (146,6713002,30.6433,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (42,25818,87.393,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (44,2525482,95.2446,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (47,6425830,36.4536,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (11,4236633,36.5933,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (110,594221,56.489,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (103,9381854,73.8484,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (61,3703069,22.2886,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (18,9370509,50.7001,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (10,96757,13.9815,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (90,7735308,70.1336,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (3,6713002,69.9815,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (124,619310,52.9608,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (28,7336831,88.754,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (87,4940595,86.0315,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (56,956292,42.6988,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (17,247763,51.2996,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (139,8194815,82.7488,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (42,119003,33.5972,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (77,7194156,44.3178,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (121,904822,13.8403,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (149,3366280,43.0096,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (60,7194156,74.0624,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (39,8077317,49.8597,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (58,5153928,52.3229,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (51,2533106,83.9632,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (65,904822,63.0541,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (131,2102251,18.365,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (118,1884957,90.9726,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (106,1405695,40.4193,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (113,6713002,41.2544,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (88,904822,26.102,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (99,9381854,32.6298,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (50,5850192,67.5418,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (7,7178375,54.8809,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (145,5225322,10.837,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (41,4504819,91.7503,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (50,2533106,51.2569,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (146,8194815,30.2268,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (95,2525482,63.3164,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (141,4236633,99.3881,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (7,2100422,34.6453,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (48,8194815,38.0646,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (110,4120483,60.6957,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (56,4504819,66.7393,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (4,5850192,70.9338,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (40,1962118,94.5664,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (80,7039655,48.7278,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (7,3890273,71.8118,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (74,4507063,61.8395,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (70,4349997,2.062,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (4,1068418,28.5523,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (100,7194156,30.0512,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (35,4282420,12.4407,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (143,4940595,51.1045,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (52,9370509,59.821,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (81,96757,89.3614,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (122,2100422,18.8328,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (144,956292,48.4212,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (41,2525482,19.4569,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (6,5524759,1.8712,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (94,4720742,45.6568,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (116,1311904,71.6081,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (62,9085858,73.537,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (56,6743270,59.1878,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (31,904822,7.599,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (92,7194156,48.9806,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (27,1730574,5.8038,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (40,1405695,83.0759,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (58,9370509,97.1882,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (120,829946,92.0324,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (47,1405695,48.9846,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (42,96757,53.6807,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (9,829946,96.2601,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (86,5225322,63.8225,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (32,703490,1.076,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (6,2854732,53.2509,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (117,3885645,75.0884,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (142,4121702,70.9564,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (107,1068418,85.6545,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (133,3366280,47.199,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (37,1311904,21.0433,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (33,4940595,91.4307,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (103,4282420,53.8797,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (118,7662191,21.3716,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (43,3366280,65.5561,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (111,3108044,87.9865,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (57,5031525,84.7488,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (45,1307026,43.6643,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (29,25818,65.6641,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (46,1884957,43.7136,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (17,8077317,54.8397,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (115,1405695,48.997,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (126,3890273,76.0993,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (98,3366280,35.3091,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (50,7178375,51.6892,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (138,1068418,52.6672,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (69,9381854,54.9327,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (118,594221,18.8526,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (127,25818,56.6377,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (55,9370509,25.1452,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (47,7662191,74.9939,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (71,3880540,44.1986,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (126,1307026,98.6049,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (60,5528197,33.117,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (10,619310,11.5731,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (85,6425830,9.0367,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (68,3835453,48.5174,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (103,5043748,54.1993,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (6,9048206,48.4183,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (110,350692,38.7621,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (34,9085858,44.96,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (130,7194156,97.3884,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (107,4720742,66.6441,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (79,2533106,9.7916,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (34,5484503,11.9644,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (124,4236633,25.6973,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (7,6713002,78.6948,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (52,5528197,22.9323,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (16,3366280,85.7439,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (149,594221,19.2574,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (39,1962118,44.2162,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (81,7336831,20.9287,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (50,9085858,56.8129,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (89,7662191,46.2774,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (99,96757,40.2917,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (33,5043748,30.4554,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (111,7178375,93.8773,1);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (17,1812489,7.2876,0);
INSERT INTO student_section_table(StudentID,SectionID,Grade,Passing) VALUES (14,8194815,34.0435,1);

INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (8,11.81,'2022-04-24');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (23,16.93,'2021-01-27');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (25,4.9,'2022-07-21');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (2,8.47,'2022-04-30');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (3,0.59,'2022-09-15');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (3,4.61,'2021-01-31');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (20,6.98,'2021-07-09');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (7,14.61,'2022-06-08');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (25,13.29,'2021-10-19');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (31,1.64,'2022-03-10');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (29,2.92,'2021-12-30');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (38,16.42,'2021-06-23');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (17,6.82,'2021-07-21');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (9,0.19,'2021-08-05');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (13,15.29,'2021-06-09');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (33,10.78,'2022-06-23');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (9,15.63,'2022-07-28');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (20,14.74,'2021-06-28');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (23,9.51,'2022-07-21');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (17,11.2,'2022-08-16');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (32,16.22,'2022-09-18');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (9,18.43,'2021-03-02');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (5,19.57,'2022-11-16');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (13,11.32,'2021-03-15');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (16,1.15,'2021-05-10');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (24,12.49,'2021-11-09');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (19,10.73,'2021-04-01');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (33,10.05,'2022-03-09');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (27,8.93,'2022-02-18');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (32,9.27,'2022-02-19');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (22,5.19,'2021-06-10');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (18,1.67,'2021-10-30');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (29,18.5,'2021-05-26');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (28,3.2,'2021-07-22');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (40,10.78,'2021-09-01');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (6,1.2,'2022-04-04');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (11,11.07,'2022-08-15');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (9,8.51,'2021-10-31');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (33,12.85,'2021-06-19');
INSERT INTO weeklypayment_table(EmploymentID,WeekHours,WeekStartDate) VALUES (19,5.59,'2021-05-16');
