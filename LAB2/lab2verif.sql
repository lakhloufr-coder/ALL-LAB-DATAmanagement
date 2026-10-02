create database RLMS ;
use RLMS ;

create table Person(
pid int not null, 
firstName varchar(30) , 
lastName varchar(30) , 
email varchar(30) , 
affiliation varchar(30) , 
startdate date , 
endDate date default NULL , 
primary key (pid)  
) ; 

create table Student(
pid int not null ,
program varchar(4) check ( program in ('BSc' , 'BEng' , 'MSc' , 'PhD')), 
primary key (pid) , 
foreign key (pid) references Person(pid) on delete cascade
) ; 

create table Employee (
pid int not null, 
phone varchar(20) , 
office varchar(30) , 
pid_supervisor int default null ,
primary key (pid) , 
foreign key (pid) references Person(pid) on delete cascade, 
foreign key (pid_supervisor) references Employee(pid) on delete set null
) ; 

create table Academic(
pid int not null , 
primary key (pid) , 
foreign key (pid) references Employee(pid) on delete cascade
) ;

create table NonAcademic (
pid int not null , 
primary key (pid) , 
foreign key (pid) references Employee(pid) on delete cascade
) ;

create table Administrative (
pid int not null, 
position varchar(30) ,
primary key (pid) , 
foreign key (pid) references NonAcademic(pid) on delete cascade
) ;
CREATE TABLE Faculty (
    pid INT NOT NULL,
    position VARCHAR(30),
    PRIMARY KEY (pid),
    FOREIGN KEY (pid) REFERENCES Academic(pid) ON DELETE CASCADE
);

create table Technical (
pid int not null, 
position varchar(30) ,
primary key (pid) , 
foreign key (pid) references NonAcademic(pid) on delete cascade
) ;

create table Advises (
pid_stud int not null , 
pid_acad int not null , 
primary key (pid_stud , pid_acad) , 
foreign key (pid_stud) references Student(pid) , 
foreign key (pid_acad) references Academic(pid) on delete no action
) ; 

create table Laboratory (
labId int not null, 
name varchar(50) , 
building varchar(30) , 
roomNumber int , 
discipline varchar(50) ,
pid_supervisor int not null , 
primary key (labId) ,
foreign key (pid_supervisor) references Faculty(pid) on delete no action
) ;

create table Attached (
pid_person int not null, 
labId int not null ,
primary key (pid_person , labId) , 
foreign key (pid_person) references Person(pid) , 
foreign key (labId) references Laboratory(labId)
) ;

create table ResearchProject(
code int not null,
title varchar(100) , 
startDate date , 
endDate date , 
status varchar(15) check (status in ('Proposed' , 'Active' , 'Suspended' , 'Completed' , 'Cancelled')) , 
primary key (code)
) ;

create table Participates(
pid_person int not null , 
code_proj int not null , 
role varchar(15) check (role in ('PI' , 'Co-PI' , 'Collaborator')) , 
primary key (pid_person , code_proj) , 
foreign key (pid_person) references Person(pid) , 
foreign key (code_proj) references ResearchProject(code)
) ;

create table Budget(
budgetLine int not null , 
amountGranted decimal(15,2) , 
amountDisbursed decimal(15,2) , 
startDate date ,
endDate date , 
pid_manager int not null , 
primary key (budgetLine) , 
foreign key (pid_manager) references Academic(pid) on delete no action
) ;

create table FundsLab(
labId int not null , 
budgetLine int not null , 
primary key (labId , budgetLine) , 
foreign key (labId) references Laboratory(labId) , 
foreign key (budgetLine) references Budget(budgetLine)
) ;

create table FundsPrj (
code int not null , 
budgetLine int not null , 
primary key (code , budgetLine) ,
foreign key (code) references ResearchProject(code) , 
foreign key (budgetLine) references Budget(budgetLine)
) ;

create table EquipmentModel(
modelId int not null ,
commercialName varchar(50) , 
manufacturer varchar(50) , 
category varchar(30) , 
requiredEnvironment varchar(100) , 
trainingMandatory boolean , 
primary key (modelId)
) ;

create table EquipmentUnit(
serialNo varchar(30) not null , 
acquisitionDate date , 
purchaseCost decimal(12,2) , 
status varchar(20) check (status in ('InService' , 'UnderMaintenance' , 'OutOfService' , 'Retired')) ,
portable boolean ,
modelId int not null ,
labId int not null ,
primary key (serialNo) ,
foreign key (modelId) references EquipmentModel(modelId) on delete no action , 
foreign key (labId) references Laboratory(labId) on delete no action
) ; 

create table Certification (
code int not null , 
title varchar(50) , 
issuingAuthority varchar(50) , 
validityPeriod int check (validityPeriod > 0) , 
safetyLevel int ,
primary key (code)
) ;

create table Requires(
modelId int not null ,
code int not null ,
primary key (modelId , code) , 
foreign key (modelId) references EquipmentModel(modelId) , 
foreign key (code) references Certification(code)
) ;

create table Holds (
pid int not null , 
code int not null , 
issueDate date not null ,
expirationDate date ,  
grade varchar(30) default null , 
constraint chk_dates check (expirationDate is null or expirationDate >= issueDate) , 
primary key (pid , code) , 
foreign key (pid) references Person(pid) , 
foreign key (code) references Certification(code)
) ;

create table Reservation (
resId int not null , 
submissionTS timestamp not null default current_timestamp , 
plannedStart datetime not null , 
plannedEnd datetime not null , 
purpose varchar(200) , 
status varchar(15) check (status in ('Pending' , 'Approved' , 'Rejected' , 'Cancelled' , 'Completed')) ,
pid_madeby int not null ,
pid_approver int default null ,
code_project int not null ,
primary key (resId) , 
foreign key (pid_madeby) references Person(pid) on delete no action , 
foreign key (pid_approver) references Person(pid) on delete set null , 
foreign key (code_project) references ResearchProject(code) on delete no action
) ;

create table Reserves (
resId int not null , 
serialNo varchar(30) not null ,
primary key (resId , serialNo) ,
foreign key (resId) references Reservation(resId) on delete cascade , 
foreign key (serialNo) references EquipmentUnit(serialNo) on delete no action
) ;

create table Maintenance(
serialNo varchar(30) not null , 
startTS timestamp not null , 
endTS timestamp , 
type varchar(20) check (type in ('Preventive' , 'Corrective')) , 
description varchar(200) , 
cost decimal(10,2) not null , 
outcome varchar(20) check (outcome in ('Resolved' , 'FollowUpRequired')) , 
pid_doneby int not null , 
primary key (serialNo , startTS) , 
foreign key (serialNo) references EquipmentUnit(serialNo) on delete cascade ,
foreign key (pid_doneby) references Technical(pid) on delete no action
) ;

create table CalibrationRecord(
serialNo varchar(30) not null ,
calibDate date not null , 
calibrationType varchar(50) ,
result varchar(15) check (result in ('Pass' , 'Fail' , 'Adjusted')) ,
nextDueDate date ,
remarks varchar(200) ,
primary key (serialNo , calibDate) , 
foreign key (serialNo) references EquipmentUnit(serialNo) on delete cascade
) ;

create table Consumable (
consId int not null , 
name varchar(50) , 
unitOfMeasure varchar(20) ,
hazardLevel int not null , 
reorderThreshold int , 
primary key (consId)
) ;

create table Supplier(
suppId int not null , 
name varchar(50) , 
contactEmail varchar(50) ,
phone varchar(20) , 
primary key (suppId)
) ;

create table Stocks (
labId int not null ,
consId int not null , 
quantityOnHand int , 
lastRestockDate date , 
storageCondition varchar(100) default null , 
monitoringSince datetime , 
pid_technical int , 
primary key (labId , consId) , 
foreign key (labId) references Laboratory(labId) on delete no action ,
foreign key (consId) references Consumable(consId) on delete no action ,
foreign key (pid_technical) references Technical(pid) on delete set null
) ;

create table Supplies(
suppId int not null , 
consId int not null , 
labId int not null ,
unitPrice decimal(10,2) not null ,
primary key (suppId , consId , labId) , 
foreign key (suppId) references Supplier(suppId) , 
foreign key (consId) references Consumable(consId) , 
foreign key (labId) references Laboratory(labId)
) ;

create table Consumes (
resId int not null , 
consId int not null ,
quantityUsed int not null ,
primary key (resId , consId) , 
foreign key (resId) references Reservation(resId) on delete cascade , 
foreign key (consId) references Consumable(consId) on delete no action
) ;