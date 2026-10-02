create database RLMS ;
use RLMS ;
create table Person(
pid int not null, 
firstName varchar(30)  , 
lastName varchar(30) , 
email varchar(30) , 
affiliation varchar(30) , 
startdate date , 
endDate date default NULL , 
primary key (pid)  
) ; 

create table student(
pid int not null ,
program varchar(4) check ( program in ('BSc' , 'BEng' , 'MSc' , 'PhD')), 
primary key (pid) , 
foreign key (pid) references Person(pid) on delete cascade
) ; 

create table Employee (
pid int not null, 
phone varchar(20) , 
office varchar(30) , 
pid_supervisor int default null , -- because null for dean  
primary key (pid) , 
foreign key (pid) references Person(pid) , 
foreign key (pid_supervisor) references Employee(pid) ); 

create table Academic(
pid int not null , 
primary key (pid) , 
foreign key (pid) references Employee(pid));

create table NonAcamdeic (
pid int , 
primary key (pid) , 
foreign key (pid) references Employee(pid));

create table Administrative (
pid int not null, 
primary key (pid) , 
foreign key (pid) references NonAcademic(pid));

create table Technical (
pid int not null, 
primary key (pid) , 
foreign key (pid) references NonAcademic(pid));

create table Advises (
pid_stud int not null , 
pid_acad int Not null , 
primary key (pid_student , pid_acad ) , 
foreign key (pid_student) references Student(pid) , 
foreign key (pid_acad ) references Academic (pid) ) ; 

create table  Laboratory (
 labId  int not null, 
name varchar(20) , 
building varchar(20) , 
roomNumber int , 
discipline varchar(20) ,
pid_supervis int not null  , 
foreign key (pid_supervis) references Faculty(pid) , 
primary key (labId) );

create table Attached (
pid_person int not null, 
lab_id int not null ,
primary key (pid_person , lab_id ) , 
foreign key (pid_person) references Person(pid) , 
foreign key (lab_id) references Laboratory(labId) );

create table ResearchProject(
code int not null,
title varchar(50) , 
startDate date , 
endDate date , 
status varchar(10) check (status in ('Proposed' , 'Active' , 'Suspended' , 'Completed' , 'Cancelled' )) , 
primary key (code) );

create table Participates(
code_proj int  not null , 
pid_person int  , 
role varchar(50) , 
primary key(code_proj , pid_person), 
foreign key (code_proj) references ResearchProject(code) , 
foreign key (pid_person) references Person(pid) );

create table Budget(
-- realtion merge as in the course
budgetLine int , 
amountGranted int , 
amountDisbursed int , 
endDate date , 
pid_manger int not null  , 
primary key (budgetLine) , 
foreign key (pid_manger) references Academic(pid) );

create table FundLab(
-- read requirements 
labbId int not null  , 
budgetLine int , 
primary key (labId , budgetLine) , 
foreign key (labId ) references Laboratory(labId) , 
foreign key (budgetLine) references Budget(budgetLine) );

create table FundsPrj (
code int  not null, 
budgetLine int , 
primary key (code , budgetLine) ,
foreign key (code) references ResearcheProject(code), 
foreign key (bugetLine) references Budget(budgetLine) );

create table EquimentModel(
 modeIId int not null,
 commercialName varchar(30) , 
 manufacturer varchar(30) , 
 category varchar(30) , 
 requiredEnvironment varchar(50) , 
 trainingMandatory varchar(50) , 
 primary key (modeIId) );

create table EquipmentUnit(
serialNO varchar(30)  not null, 
acquisitionDate date , 
purschaseCost int , 
status varchar(20) check (status in ('InService' , 'UnderMaintenance' ,'OutOfService' , 'Retired' )) ,
portable boolean ,
instanceof int not null ,
Locatedin int not null  ,  
foreign key (instanceof) references EquipmentModel(modelIId) , 
foreign key (Locatedin) references Laboratory(labId) ,  
primary key (instanceof , serialNO) ); 

create table Certification (
code int not null , 
title varchar(30) , 
issuingAutority varchar(30) , 
validatyPeriod int check (validatyPeriod >0) , -- i chosee tge period will be on month 
safetyLevel int  -- i chose with int example level 1 ? 
);

create table Requires(
code int , 
modeIId int ,
primary key (code , modeIId) , 
foreign key (code) references Certification(code) , 
foreign key (modeIId) references EquipmentModel(modeIId) );

create table Holds (
code int  , 
pid int , 
issueDate date ,
expirationDate date ,  
grade varchar(30) default null , 
constraint chk_dates check (expirationDate >= issueDate) , 
primary key (code , pid) , 
foreign key (code) references Certification(code) , 
foreign key (pid) references Person(pid) );

create table Reservation (
resId int , 
submissionTs timestamp default current_timestamp , 
plannedStart datetime not null , 
plannedEnd datetime not null , 
for_project int  not null, 
madeby int not null check (madeby not in (select pid from Administartive)),  -- debug ca 
pid_appr_pers int ,
purpose varchar(100) , 
primary key (resId) , 
staus varchar(10) check (status in ('Pending' , 'Approved' , 'Rejected' , 'Cancelled' , 'Completed')) ,
foreign key (madeby) references Person(pid) , 
foreign key (pid_appr_pers) references Person(pid) , 
foreign key (for_project) references ResearchProject(code) 
);

create table Reserves (
resId int not null , 
serailNO varchar(30) , 
primary key (resId , serialNO) ,
foreign key (resID) references Reservation (resId) , 
foreign key (serialNO) references EquipementsUnit(serialNO) ) ;

create table Maintenance(
serialNO varchar(30), 
StartTS timestamp , 
endTS timestamp , 
type varchar(30) check ( type in ('Preventive' , 'Corrective')) , 
description varchar(100) , 
cost int not null, 
outcome varchar(20) check ( outcome in ('Resolved' , 'FollowUpRequired') ) , 
Doneby_pid int not null , 
primary key (serialNO , StartTS)  , 
foreign key (Doneby_pid) references Technical(pid)  ON DELETE CASCADE 
);

create table CalibrationRecord(
calibDate date not null ,
serailNO varchar(30) not null , 
primary key (calibDate , serialNO) , 
foreign key (serialNO) references EquipmentUnit(serialNO) ON DELETE CASCADE );
 -- for these two relation is implicite in the table of the weak entity
 
 create table Consumable (
 consId int not null , 
 name varchar(30) , 
 unitofMeasure varchar(20) ,
 hazardLevel int not null , 
 reorderThreshold int , 
 primary key (consId) );
 
 create table Stocks (
 consId int not null , 
 labID int not null ,
 quantityOnHand int , 
 lastRestockDate date , 
 storageCondition varchar(50) default null , 
 monitoringsince datetime  , 
 pid_technical int , 
 primary key (consID , labId) , 
 foreign key  (consId) references Consumable(consId) , 
 foreign key (labID) references Laboratory(labId) , 
 foreign key (pid_technical) references Technical(pid) );
 
 create table Supplier(
 suppId int not null , 
 name varchar(30) , 
 contactEmail varchar(30) ,
 phone int , 
 primary key (suppId) );
 
 create table Supplies(
 consID int not null , 
 labID int not null , 
 suppID int not null ,
 unitPrice int not null ,
 primary key (consID , labID , suppID ) , 
 foreign key (consID) references Consumable(consId) , 
 foreign key (labID) references Laboratory(labId) , 
 foreign key (suppID) references Supplier(suppID) );
 
 create table Consumes (
 quantityUsed int not null,
 resId int not null , 
 consId int not null , 
 primary key (resId , consId) , 
 foreign key (resId) references Reservation(resId) , 
 foreign key (consId) references Consumable(consId) );
 
 
 
 
 
 
 
 








  


























