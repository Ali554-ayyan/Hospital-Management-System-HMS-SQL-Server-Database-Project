create database hsp

use hsp

create table patient(
Patient_ID int primary key ,
Patient_Name varchar(100) not null,
Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
Age int ,
DateOfBirth DATE 
);

Select * from Patient

Create table Doctor(
Doctor_ID int primary key ,
Doctor_Name varchar (20) not null ,
Speciality varchar(10) not null ,
Experience int 
);

select * from Doctor

create table Appointment(
App_ID int primary key , 
Patient_ID int,
Doctor_ID int ,

AppointmentDate Date not  null ,
status  varchar (100) not null ,
Foreign key(Patient_ID) references patient(Patient_ID) ,
Foreign key(Doctor_ID) references  Doctor(Doctor_ID) 
);


select * from Appointment

Create table Bills(
BillID int primary key ,
App_ID  int ,

Foreign key(App_ID) references Appointment(App_ID) ,

Amount int ,
Payment_Staus varchar (100) not null 
);

select * from Bills



INSERT INTO Patient (Patient_ID, Patient_Name, Gender, Age, DateOfBirth)
VALUES
(1, 'Ali Khan', 'M', 22, '2004-02-15'),
(2, 'Sara Ahmed', 'F', 25, '2001-07-10'),
(3, 'Usman Shah', 'M', 30, '1996-11-21'),
(4, 'Ayesha Malik', 'F', 28, '1998-05-18'),
(5, 'Bilal Hassan', 'M', 35, '1991-09-30');

INSERT INTO Doctor (Doctor_ID, Doctor_Name, Speciality, Experience)
VALUES
(101, 'Dr. Ahmed', 'Cardio', 10),
(102, 'Dr. Fatima', 'Dental', 8),
(103, 'Dr. Hamza', 'Neuro', 12),
(104, 'Dr. Areeba', 'ENT', 6),
(105, 'Dr. Salman', 'Ortho', 15);

INSERT INTO Appointment (App_ID, Patient_ID, Doctor_ID, AppointmentDate, Status)
VALUES
(1001, 1, 101, '2026-08-10', 'Completed'),
(1002, 2, 102, '2026-08-11', 'Pending'),
(1003, 3, 103, '2026-08-12', 'Completed'),
(1004, 4, 104, '2026-08-13', 'Cancelled'),
(1005, 5, 105, '2026-08-14', 'Pending');


INSERT INTO Bills (BillID, App_ID, Amount, Payment_Staus)
VALUES
(5001, 1001, 5000, 'Paid'),
(5002, 1002, 3000, 'Unpaid'),
(5003, 1003, 7000, 'Paid'),
(5004, 1004, 2000, 'Refunded'),
(5005, 1005, 4500, 'Unpaid');




SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointment;
SELECT * FROM Bills;



Select Patient_Name , Age from patient 


Select Doctor_Name , Speciality from Doctor


--Where Show patients whose age is greater than 25.

Select * from patient Where Age > 25 ;

Select * from patient Where Gender = 'F' ;

Select * From Doctor Where Experience > 8 ;

Select * From Appointment where status = 'Pending' ;

Select * From Bills where Amount > 4000 ;

-- order by 

--Show patients ordered by age (ascending).

Select * From patient order by Age Asc ;

-- Show doctors ordered by experience (descending).

Select * From doctor order by Experience desc ;

 -- Show bills ordered by amount. 

 Select * From Bills order by Amount


 -- Aggregate Functions

 -- Count total patients.

 Select Count( Patient_ID) as Patinet_Count from patient

 --Max Bill Amount 


 Select * from Bills

 Select max ( Amount) as max from Bills

 Select min (Patient_Name) as Min_Patient from patient


 Select * from Doctor

 Select avg ( Experience) as Avg_Exp from doctor 

 Select sum (Amount) as Toal_Amount from patient

 --5. String Functions (4 Questions)
--Show patient names in uppercase.
--Show doctor names in lowercase.
--Find length of each patient name.
--Concatenate Doctor_Name and Speciality.

Select upper(Patient_Name) from patient

select * from Doctor


select lower(Doctor_Name) from Doctor

select Patient_Name , len (Patient_Name) as Patient_Name_Length from patient


SELECT 
    Doctor_Name, 
    Speciality,  
    CONCAT_WS(':', Doctor_Name, Speciality) AS Doctor_special 
FROM Doctor;


--Date Functions (3 Questions)
--Show current date using GETDATE()
--Show birth year of each patient.
--Show appointment year.

Select * from patient

SELECT DATEPART(year, DateOfBirth) as date_of_birth FROM patient;

select * from Appointment

select datepart(year , AppointmentDate) as Appoint_Year from Appointment


--LIKE, BETWEEN, IN (4 Questions)
--Find patients whose name starts with 'A'.
--Find patients whose age is between 20 and 30.
--Find doctors whose speciality is Cardio or Neuro.
--Find bills whose amount is in (3000, 5000).

SELECT * 
FROM Patient 
WHERE Patient_Name LIKE 'A%';

SELECT * FROM patient WHERE age between 20 and 30;

select * from Doctor

select * from Doctor where Speciality = 'cardio' or  Speciality = 'Neuro' ;

select * from bills

select * from bills where Amount in (3000 , 5000);

--JOIN Queries

--Show Patient Name with Appointment Date.

Select * from patient

select * from Appointment

select 

P.Patient_Name ,
A.AppointmentDate

from patient P

inner join Appointment A

on P.Patient_ID = A.Patient_ID


--Show Doctor Name with Appointment Date.


select * from Doctor
select * from Appointment

Select 
D.Doctor_Name,
A.AppointmentDate

from Doctor D 
inner join Appointment A

on D.Doctor_ID = A.Doctor_ID


--Advanced SQL Practice Questions

--GROUP BY
--Count the total appointments for each doctor.
--Count the total appointments for each appointment status.
--Find the total bill amount for each payment status.


select 
D.Doctor_Name ,
count(A.AppointmentDate) as Appointments

from Doctor D

inner join Appointment A

on D.Doctor_ID = A.Doctor_ID

group by D.Doctor_Name

select * from Appointment

select AppointmentDate , count(status) as Apoint_status from Appointment group by AppointmentDate

select * from Bills

select Payment_Staus , sum(Amount) as Amount_Status from bills group by Amount , Payment_Staus

--HAVING
--Show doctors who have more than 1 appointment.
--Show payment statuses where the total bill amount is greater than 5000.
--Show doctors whose total bill amount is greater than 5000


SELECT Doctor_ID, COUNT(App_ID) AS count
FROM Appointment 
GROUP BY Doctor_ID 
HAVING COUNT(App_ID) > 0;



Select Payment_Staus , sum(Amount) as Total_bill from Bills group by Payment_Staus having sum(Amount)>5000; 



SELECT a.Doctor_ID, SUM(b.Amount) AS Total_Bill_Amount
FROM Bills b
JOIN Appointment a ON b.App_ID = a.App_ID
GROUP BY a.Doctor_ID
HAVING SUM(b.Amount) > 5000;


SELECT DISTINCT Gender FROM Patient;


Select Distinct Speciality from Doctor;

--Left Join

--Show all patients with their appointment details.

Select
P.Patient_ID
from Patient P
left join Appointment A
on P.Patient_ID = A.Patient_ID;

Select
D.Doctor_ID
from Doctor D
left join Appointment A
on D.Doctor_ID = A.Doctor_ID;


--Show all patients with their bill amount.

Select 
P.Patient_ID
from Patient P
left join Bills B
on P.Patient_ID=B.Amount;
