/* BuildUniversityDimensionalModel.SQL - Creates the UNIVERSITY MODEL schema */ 
/* Group 12 - University Dimensional Model */
/* All Rights Reserved with Group 12. */

raiserror('BEGINNING BuildUniversityDimensionalModel.SQL...',1,1) with nowait
GO

if exists (select * from sysdatabases where name='universitymodel')
begin
  raiserror('DROPPING EXISTING universitymodel DATABSE...',0,1)
  DROP database universitymodel
end
GO

CHECKPOINT
GO

raiserror('CREATING universitymodel SCHEMA...',0,1)
GO

CREATE DATABASE universitymodel
GO

USE universitymodel
GO

if db_name() <> 'universitymodel'
   raiserror('ERROR IN BuildUniversityDimensionalModel.SQL, ''USE universitymodel'' FAILED!!  KILLING THE SPID NOW.',22,127) with log
GO

raiserror('STARTING TABLE CREATION...',0,1)
GO


CREATE TABLE [DIM_Address] (
	[AddressID] int NOT NULL,
	[Street] varchar(255) NOT NULL,
	[City] varchar(50) NULL,
	[State] varchar(50) NULL,
	[ZipCode] varchar(10) NOT NULL,
	[Country] varchar(30) NOT NULL,
	CONSTRAINT [pk_DIM_Address] PRIMARY KEY ([AddressID])
);

CREATE TABLE [DIM_Course] (
	[CourseID] int NOT NULL,
	[Credits] int NOT NULL,
	[CourseCode] varchar(10) NOT NULL,
	[CourseNumber] varchar(10) NOT NULL,
	[CourseName] varchar(100) NOT NULL,
	[CourseDescription] varchar(2000) NULL,
	CONSTRAINT [pk_DIM_Course] PRIMARY KEY ([CourseID])
);

CREATE TABLE [DIM_Semester] (
	[SemesterID] int NOT NULL,
	[Term] varchar(20) NOT NULL,
	[StartDate] date NOT NULL,
	[EndDate] date NOT NULL,
	[MaxCreditsAllowed] int NOT NULL,
	CONSTRAINT [pk_DIM_Semester] PRIMARY KEY ([SemesterID])
);

CREATE TABLE [DIM_CourseOffering] (
	[OfferingID] int NOT NULL,
	[CourseID] int NOT NULL REFERENCES [DIM_Course] ([CourseID]),
	[SemesterID] int NOT NULL REFERENCES [DIM_Semester] ([SemesterID]),
	[CRN] int NOT NULL,
	[Section] varchar(5) NULL,
	CONSTRAINT [pk_DIM_CourseOffering] PRIMARY KEY ([OfferingID])
);

CREATE TABLE [DIM_Date] (
	[DateValue] date NOT NULL,
	[Day] varchar(12) NOT NULL,
	[WeekInYear] int NOT NULL,
	CONSTRAINT [pk_DIM_Date] PRIMARY KEY ([DateValue])
);

CREATE TABLE [DIM_Degree] (
	[DegreeID] int NOT NULL,
	[DegreeName] varchar(70) NOT NULL,
	[TotalCredits] int NOT NULL,
	[TypicalMonthDuration] int NOT NULL,
	[PossibleDegreeStartTerms] varchar(50) NULL,
	[TotalCoursesToComplete] int NULL,
	CONSTRAINT [pk_DIM_Degree] PRIMARY KEY ([DegreeID])
);

CREATE TABLE [DIM_Faculty] (
	[FacultyID] varchar(12) NOT NULL,
	[FirstName] varchar(50) NOT NULL,
	[LastName] varchar(50) NULL,
	[PhDFlag] bit NULL,
	[FacultyEmail] varchar(100) NOT NULL,
	[PersonalEmail] varchar(100) NULL,
	[DOB] date NOT NULL,
	[PhoneNumber] varchar(15) NULL,
	[CurrentAddressID] int NULL REFERENCES [DIM_Address] ([AddressID]),
	[ProgramDirectorFlag] bit NOT NULL,
	[FacultyLevel] varchar(20) NOT NULL,
	[Race] varchar(40) NULL,
	CONSTRAINT [pk_DIM_Faculty] PRIMARY KEY ([FacultyID])
);



CREATE TABLE [DIM_Student] (
	[StudentID] varchar(12) NOT NULL,
	[FirstName] varchar(50) NOT NULL,
	[LastName] varchar(50) NULL,
	[StudentEmail] varchar(100) NOT NULL,
	[PersonalEmail] varchar(100) NULL,
	[DOB] date NULL,
	[PhoneNumber] varchar(15) NULL,
	[CurrentAddressID] int NOT NULL REFERENCES [DIM_Address] ([AddressID]),
	[Race] varchar(40) NULL,
	CONSTRAINT [pk_DIM_Student] PRIMARY KEY ([StudentID])
);

CREATE TABLE [Fact_CoursePrerequisite] (
	[PrereqID] int NOT NULL,
	[CourseID] int NOT NULL REFERENCES [DIM_Course] ([CourseID]),
	[PrerequisiteCourseID] int NOT NULL REFERENCES [DIM_Course] ([CourseID]),
	CONSTRAINT [pk_Fact_CoursePrerequisite] PRIMARY KEY ([PrereqID])
);

CREATE TABLE [Fact_DegreeEnrollment] (
	[EnrollmentID] int NOT NULL,
	[StudentID] varchar(12) NOT NULL REFERENCES [DIM_Student] ([StudentID]),
	[DegreeID] int NOT NULL REFERENCES [DIM_Degree] ([DegreeID]),
	[EnrollDate] date NOT NULL REFERENCES [DIM_Date] ([DateValue]),
	[GraduationStatus] bit NOT NULL,
	CONSTRAINT [pk_Fact_DegreeEnrollment] PRIMARY KEY ([EnrollmentID])
);

CREATE TABLE [Fact_DegreeWiseCoreCourses] (
	[DegreeID] int NOT NULL REFERENCES [DIM_Degree] ([DegreeID]),
	[CourseID] int NOT NULL REFERENCES [DIM_Course] ([CourseID]),
	[TakeInFirstSemesterFlag] bit,
	CONSTRAINT [pk_Fact_DegreeWiseCoreCourses] PRIMARY KEY ([DegreeID], [CourseID])
);

CREATE TABLE [Fact_FacultyTeachingCourse] (
	[FacultyID] varchar(12) NOT NULL REFERENCES [DIM_Faculty] ([FacultyID]),
	[OfferingID] int NOT NULL REFERENCES [DIM_CourseOffering] ([OfferingID]),
	[CourseMode] varchar(30) NOT NULL,
	CONSTRAINT [pk_Fact_FacultyTeachingCourse] PRIMARY KEY ([FacultyID], [OfferingID])
);

CREATE TABLE [Fact_StudentCourseEnrollment] (
	[SEnrollmentID] int NOT NULL,
	[StudentID] varchar(12) NOT NULL REFERENCES [DIM_Student] ([StudentID]),
	[OfferingID] int NOT NULL REFERENCES [DIM_CourseOffering] ([OfferingID]),
	[EnrollmentDate] date NOT NULL REFERENCES [DIM_Date] ([DateValue]),
	[DropDate] date NOT NULL REFERENCES [DIM_Date] ([DateValue]),
	CONSTRAINT [pk_Fact_StudentCourseEnrollment] PRIMARY KEY ([SEnrollmentID])
);

CREATE TABLE [Fact_StudentCoursePerformance] (
	[StudentID] varchar(12) NOT NULL REFERENCES [DIM_Student] ([StudentID]),
	[OfferingID] int NOT NULL REFERENCES [DIM_CourseOffering] ([OfferingID]),
	[Result] varchar(10) NOT NULL,
	[Grade] varchar(5) NOT NULL,
	[GradePoints] float NOT NULL,
	CONSTRAINT [pk_Fact_StudentCoursePerformance] PRIMARY KEY ([StudentID], [OfferingID])
);

raiserror('SCHEMA CREATION COMPLETED SUCCESSFULLY...',0,1)
GO
