--Create the student table
CREATE TABLE homework_db.student12 (
  studentId  INT NOT NULL,
  name       VARCHAR(100) NOT NULL,
  age        INT,
  department VARCHAR(100),
  PRIMARY KEY (studentId)
);



--Create the course table
CREATE TABLE homework_db.course (
  courseID INT NOT NULL,
  name     VARCHAR(45),
  credits  INT,
  PRIMARY KEY (courseID)
);



--Create the Enrollments table

CREATE TABLE homework_db.Enrollments (
  eID   INT NOT NULL AUTO_INCREMENT,
  sID   INT NOT NULL,
  cID   INT NOT NULL,
  grade VARCHAR(45),
  PRIMARY KEY (eID),
  INDEX fk_enrollments_courses_idx (cID),
  CONSTRAINT fk_enrollments_students
    FOREIGN KEY (sID) REFERENCES homework_db.student12 (studentId)
      ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_enrollments_courses
    FOREIGN KEY (cID) REFERENCES homework_db.course (courseID)
      ON DELETE NO ACTION ON UPDATE NO ACTION
);



--Populate student12 table
INSERT INTO student12 (studentId, name, age, department)
VALUES
(1, 'Mohamed', 27, 'Computer Science'),
(2, 'Sara', 22, 'Mathematics'),
(3, 'David', 24, 'Physics'),
(4, 'Aisha', 21, 'Biology'),
(5, 'John', 23, 'Computer Science');


--Populate course table
INSERT INTO course (courseId, courseName, credits)
VALUES
(1, 'Database Systems', 3),
(2, 'Algorithms', 4),
(3, 'Operating Systems', 3),
(4, 'Linear Algebra', 3),
(5, 'Organic Chemistry', 4);



--Populate enrollments table
INSERT INTO enrollments (eID, sID, cID, grade)
VALUES
(1, 1, 1, 'A'),  
(2, 2, 2, 'B'),  
(3, 3, 3, 'A'),  
(4, 4, 4, 'C'),  
(5, 5, 5, 'B');  


--SQL query to read all row/column
SELECT * FROM student12;
SELECT * FROM course;
SELECT * FROM enrollments;



--Query: names of students and the courses they are enrolled in
--(Inner join = enrolled pairs only.)

SELECT s.studentId,
       s.name       AS student_name,
       c.courseID,
       c.name       AS course_name,
       e.grade
FROM   homework_db.Enrollments e
JOIN   homework_db.student12 s ON e.sID = s.studentId
JOIN   homework_db.course    c ON e.cID = c.courseID
ORDER  BY s.name, c.name;

--Query: all courses and the students enrolled (including courses with no students)
SELECT c.courseID,
       c.name       AS course_name,
       s.studentId,
       s.name       AS student_name,
       e.grade
FROM   homework_db.course c
LEFT JOIN homework_db.Enrollments e ON e.cID = c.courseID
LEFT JOIN homework_db.student12  s ON s.studentId = e.sID
ORDER  BY c.name, student_name;


