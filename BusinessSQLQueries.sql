--Displaying Core Course for the Programs
SELECT dd.DegreeName, dc.CourseCode, dc.CourseNumber, dc.CourseName, fd.TakeInFirstSemesterFlag FROM Fact_DegreeWiseCoreCourses fd
JOIN DIM_Course dc
ON fd.CourseID = dc.CourseID
JOIN DIM_Degree dd
ON fd.DegreeID = dd.DegreeID;

--Classes Student Completed in Semester and Grades
SELECT * FROM Fact_StudentCoursePerformance fp 
JOIN DIM_Student ds 
ON fp.StudentID = ds.StudentID
JOIN DIM_CourseOffering do 
ON fp.OfferingID = do.OfferingID

--Enrollment dates of Students in Courses (and Drop Date if Applicable)
SELECT fs.StudentID, ds.FirstName, ds.LastName, fs.OfferingID, do.CourseID, do.CRN, do.Section, do.SemesterID, fs.EnrollmentDate, fs.DropDate from Fact_StudentCourseEnrollment fs
JOIN DIM_Student ds 
ON fs.StudentID = ds.StudentID
JOIN DIM_CourseOffering do 
ON fs.OfferingID = do.OfferingID 

--Enrollments for StudentId 001004617
SELECT fs.StudentID, ds.FirstName, ds.LastName, fs.OfferingID, do.CourseID, do.CRN, do.Section, do.SemesterID, fs.EnrollmentDate, fs.DropDate from Fact_StudentCourseEnrollment fs
JOIN DIM_Student ds 
ON fs.StudentID = ds.StudentID
JOIN DIM_CourseOffering do 
ON fs.OfferingID = do.OfferingID

--Teachers that taught classes in SemesterID 2
SELECT * from Fact_FacultyTeachingCourse ff 
JOIN DIM_Faculty df
ON ff.FacultyID = df.FacultyID
JOIN DIM_CourseOffering do 
ON ff.OfferingID = do.OfferingID
WHERE do.SemesterID = 2

--Class Taught Each Semester
SELECT * from DIM_CourseOffering do 
JOIN DIM_Course dc 
ON do.CourseID = dc.CourseID 
JOIN DIM_Semester ds 
ON do.SemesterID = ds.SemesterID

--Students enrolled in a Degree Program
SELECT * from Fact_DegreeEnrollment fe 
JOIN DIM_Student ds 
ON fe.StudentID = ds.StudentID
JOIN DIM_Address da 
ON ds.CurrentAddressID = da.AddressID
WHERE fe.GraduationStatus = 0