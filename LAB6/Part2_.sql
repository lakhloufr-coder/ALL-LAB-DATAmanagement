use rlms;

-- part 2 : population
insert into Person values
(1,"youssef","alami","youssef.alami@um6p.ma","CC","2022-09-01",null),
(2,"salma","bennani","salma.bennani@um6p.ma","FMS","2022-09-01",null),
(3,"omar","tazi","omar.tazi@um6p.ma","GUP","2023-09-01",null),
(4,"hind","kabbaj","hind.kabbaj@gmail.com","CC","2023-02-01",null),
(5,"rachid","idrissi","rachid.idrissi@um6p.ma","GUP","2023-09-01",null),
(6,"nadia","chraibi","nadia.chraibi@um6p.ma","FMS","2024-01-15",null),
(7,"amine","fassi","amine.fassi@um6p.ma","CC","2025-09-01",null),
(8,"sara","mansouri","sara.mansouri@um6p.ma","FMS","2025-09-01",null),
(9,"lina","berrada","lina.berrada@emines.um6p.ma","EMINES","2025-09-01","2026-08-31");


insert into Employee values
(1,"0600000001","b12","dean",null),
(2,"0600000002","b13","professor",1),
(3,"0600000003","b14","postdoc",1),
(4,"0600000004","b01","secretary",1),
(5,"0600000005","g02","technician",1),
(6,"0600000006","f02","technician",2);

insert into Student values (7,"phd")
                         ,(8,"master")
                         ,(9,"phd");

insert into Academic values (1)
						   ,(2)
                           ,(3);

insert into Faculty values (1)
                          ,(2);

insert into Administrative values (4);

insert into Technical values (5)
                              ,(6);

insert into Advises values (1,7)
                           ,(2,8)
                           ,(3,9);


insert into Laboratory values
(1,"Physics Laboratory","Riad5","r1","physics",1),
(2,"chimie lab","GUP","g3","chemistry",2),
(3,"bio lab","FMS","f2","biology",2),
(4,"optic lab","Riad5","r2","physics",1);


insert into Attached values (1,1)
							,(5,1)
                            ,(3,2)
                            ,(6,3)
                            ,(7,1)
                            ,(8,3)
                            ,(2,4);

insert into ResearchProject values
("p1","gravity box simulation","2026-01-01","2026-12-31","Active"),
("p2","water tank level experience","2026-02-01","2027-01-31","Active"),
("p3","plant growth simulation test","2026-03-01","2026-10-31","Cancelled"),
("p4","small robot line following","2026-06-01","2027-06-01","Active");


insert into Participates values
(1,"p1","PI"),(7,"p1","Member"),
(2,"p2","PI"),(3,"p2","Co-PI"),
(2,"p3","PI"),(8,"p3","Member"),
(3,"p4","PI");

insert into Budget values
("ll1",50000.00,12000.00,"2026-01-01","2026-12-31",1),
("ll2",30000.00,5000.00,"2026-02-01","2027-01-31",3),
("ll3",20000.00,0.00,"2026-03-01","2026-12-31",3);


insert into FundsPrj values ("ll1","p1")
                             ,("ll2","p2")
                             ,("ll3","p2"),
                             ("ll3","p3"),
                             ("ll1","p4");
insert into FundsLab values ("ll1",1)
                             ,("ll1",4)
                             ,("ll2",2),
                               ("ll3",3);

insert into EquipmentModel values
(1,"microscope x1","brand a","Optical Microscope","clean room",true),
(2,"microscope x2","brand a","Optical Microscope","clean room",true),
(3,"thermo t1","brand b","Thermometer","room temperature",false),
(4,"spectro s1","brand c","Spectrometer","dark room",false);

insert into EquipmentUnit values
("sn1","2024-02-10",15000.00,"available",false,1,1),
("sn2","2024-03-05",12000.00,"available",false,1,1),
("sn3","2025-01-20",20000.00,"available",false,2,1),
("sn4","2025-06-15",350.00,"available",true,3,1),
("sn5","2025-09-01",300.00,"available",true,3,2),
("sn6","2025-10-12",18000.00,"in repair",false,2,3);

insert into Certification values
("c1","microscope basic","university",3,"low"),
("c2","laser safety","university",2,"high"),
("c3","chemical handling","university",2,"medium");

insert into Requires values (1,"c1")
                           ,(1,"c2")
                           ,(2,"c1");

insert into Holds values
(1,"c1","2025-01-10","2028-01-10","A"),
(1,"c2","2025-01-10","2027-01-10","A"),
(1,"c3","2025-02-01","2027-02-01",null),
(7,"c1","2025-09-15","2028-09-15","B"),
(7,"c2","2025-09-15","2027-09-15","B"),
(8,"c1","2025-10-01","2028-10-01",null),
(3,"c2","2025-03-01","2027-03-01","A"),
(5,"c3","2025-04-01","2027-04-01",null);


insert into Reservation values
(1, '2026-11-01', '2026-11-13 09:00:00', '2026-11-13 12:00:00', 'test the gravity box', 'Approved', 7, 'p1', 1),
(2,"2026-11-02","2026-11-20","2026-11-22","check plant sensors","Pending",8,"p3",null),
(3,"2026-11-02","2026-11-25","2026-11-26","water tank test","Pending",3,"p2",null),
(4,"2026-09-28","2026-10-05","2026-10-06","measure the light","Rejected",3,"p2",null),
(5,"2026-09-10","2026-09-15","2026-09-16","second try gravity box","Cancelled",7,"p1",null),
(6,"2026-09-25","2026-10-01","2026-10-03","temperature test","Completed",1,"p1",2);

insert into Reserves values
                         (1,"sn1"),
                         (1,"sn3"),
                         (2,"sn6"),
                         (3,"sn5"),
                         (4,"sn4"),
                         (5,"sn1"),
                         (6,"sn4");


insert into Maintenance values
("sn1","2026-06-01","2026-06-02","preventive","clean the lens",150.00,"done",5),
("sn3","2026-07-10","2026-07-12","corrective","change the lamp",800.00,"done",5),
("sn6","2026-10-28","2026-11-20","corrective","fix the focus",400.00,"in progress",6);

insert into CalibrationRecord values
("sn1","2026-05-20","alignment","pass","2027-05-20","ok"),
("sn4","2026-03-01","temperature","pass","2027-03-01","ok"),
("sn5","2026-04-15","temperature","pass","2027-04-15","ok");

insert into Consumable values
(1,"alcohol","liter","high",10.00),
(2,"gloves","box","low",5.00),
(3,"distilled water","liter","low",20.00),
(4,"salt","kg","low",8.00);

insert into Supplier values
(1,"supplier one","one@mail.com","0500000001"),
(2,"supplier two","two@mail.com","0500000002"),
(3,"supplier three","three@mail.com","0500000003"),
(4,"test supplier","test@mail.com","0500000004");

insert into Supplies values
(1,1,1,12.50),
(2,1,1,11.00),
(1,1,2,12.00),
(1,2,1,4.00),
(3,2,3,3.80),
(2,3,2,30.00),
(3,4,3,6.00);

insert into Stocks values
(1,1,4.00,"2026-10-01","cabinet",5,"2026-01-15"),
(1,2,40.00,"2026-09-12","shelf",5,"2026-01-15"),
(2,1,25.00,"2026-10-10","cabinet",5,"2026-03-01"),
(3,3,60.00,"2026-10-20","cold room",6,"2026-02-01"),
(3,2,12.00,"2026-09-30","shelf",6,"2026-02-01");

insert into Consumes values
(1,1,1,1.50),
(1,1,2,2.00),
(6,1,1,0.50),
(6,1,2,3.00);

-- part 2 : changes
-- op 1
insert into Person values (10,"yassine","ouali","yassine.ouali@um6p.ma","GUP","2026-10-01",null);
insert into Student values (10,"master");

insert into Advises values (1,10);
-- op 2
insert into EquipmentUnit values ("sn7","2026-10-15",320.00,"available",true,3,2);
-- op 3
-- changed: made by person 7 (participant of p1, holds c1 needed for sn3)
insert into Reservation (resId,submissionTS,plannedStart,plannedEnd,purpose,madeByPid,projectCode) values (7,"2026-11-03","2026-11-18","2026-11-19","dust measure",7,"p1");
insert into Reserves values (7,"sn7"),(7,"sn3");
-- op 4
update Reservation set status="Approved", approverPid=2 where resId=3 and status="Pending";
-- op 5
update Stocks set quantityOnHand=35.00 where labId=1 and consId=2;
-- op 6
insert into Consumes values (3,2,1,2.00);
-- op 7
update Reservation set status="Cancelled" where status="Pending" and projectCode in (select code from ResearchProject where status="Cancelled");
-- op 8
delete from Supplier where suppId=4;

-- part 3 : queries
-- 1
select pid, firstName, lastName, email
from Person
order by lastName, firstName;
-- 2
select distinct discipline
from Laboratory;
-- 3
select pid, firstName, lastName, email
from Person
where email like "%@um6p.ma";
-- 4
select pid, firstName, lastName
from Person
where endDate is null;
-- 5
select resId, plannedStart, plannedEnd, status
from Reservation
where plannedStart >= "2026-11-01" and plannedStart < "2026-12-01";
-- 6
select concat(P.firstName," ",P.lastName) as fullName, R.title, PA.role
from Participates PA, Person P, ResearchProject R
where PA.pid=P.pid and PA.projectCode=R.code;
-- 7
select B.budgetLine, B.amountGranted, concat(P.firstName," ",P.lastName) as manager
from Budget B, Person P
where B.managerPid=P.pid;
-- 8
select RS.resId, concat(P.firstName," ",P.lastName) as madeBy, R.title
from Reservation RS, Person P, ResearchProject R
where RS.madeByPid=P.pid and RS.projectCode=R.code;
-- 9
select R.resId, E.serialNo, EM.commercialName, L.name
from Reserves R, EquipmentUnit E, EquipmentModel EM, Laboratory L
where R.serialNo=E.serialNo and E.modelId=EM.modelId and E.labId=L.labId
order by R.resId;
-- 10
select RS.resId, RS.plannedStart, concat(P.firstName," ",P.lastName) as approver
from Reservation RS, Person P
where RS.status="Approved" and RS.approverPid=P.pid;
-- 11 (changed: column aliases)
select L.name as labName, C.name as consumableName, S.quantityOnHand, concat(P.firstName," ",P.lastName) as monitoredBy
from Stocks S, Laboratory L, Consumable C, Technical T, Person P
where S.labId=L.labId and S.consId=C.consId and S.technicalPid=T.pid and T.pid=P.pid;
-- 12
select L.name, count(E.serialNo) as units
from Laboratory L left join EquipmentUnit E on E.labId=L.labId
group by L.labId, L.name;
-- 13
select C.name, coalesce(sum(CS.quantityUsed),0) as totalUsed
from Consumable C left join Consumes CS on CS.consId=C.consId
group by C.consId, C.name;
-- 14 
select L.name, count(*) as cnt
from Laboratory L, EquipmentUnit E
where L.labId=E.labId
group by L.labId, L.name
having count(*) > 3;
-- 15
select R.title, coalesce(sum(B.amountGranted),0) as totalGranted
from ResearchProject R left join FundsPrj F on F.projectCode=R.code
left join Budget B on B.budgetLine=F.budgetLine
group by R.code, R.title;
-- 16
select L.name, M.category, count(U.serialNo) as units, avg(U.purchaseCost) as avgCost
from Laboratory L, EquipmentModel M, EquipmentUnit U
where M.modelId=U.modelId and U.labId=L.labId
group by L.labId, L.name, M.category;
-- 17
select S.name, count(distinct SP.consId) as consumables
from Supplier S, Supplies SP
where S.suppId=SP.suppId
group by S.suppId, S.name;
-- 18 
select L.name as labName, C.name as consumableName, min(SP.unitPrice) as lowestPrice
from Supplies SP, Laboratory L, Consumable C
where SP.labId=L.labId and SP.consId=C.consId
group by L.labId, L.name, C.consId, C.name;
-- 19
select R.resId, concat(P.firstName," ",P.lastName) as madeBy, sum(C.quantityUsed) as totalUsed
from Consumes C, Reservation R, Person P
where C.resId=R.resId and R.madeByPid=P.pid
group by R.resId, P.firstName, P.lastName;
-- 20 
select pid, firstName, lastName
from Person
where pid in (select supervisorPid from Laboratory)
and pid in (select managerPid from Budget);
-- 21
select pid, firstName, lastName
from Person
where pid not in (select madeByPid from Reservation);
-- 22
select E.serialNo
from EquipmentUnit E
where not exists (select * from Reserves R where R.serialNo=E.serialNo);
-- 23
select E.serialNo, E.purchaseCost
from EquipmentUnit E
where E.purchaseCost >= all (select purchaseCost from EquipmentUnit);
-- 24
select M.modelId, M.commercialName, P.pid, concat(P.firstName," ",P.lastName) as fullName
from EquipmentModel M, Person P
where exists (select * from Requires R1 where R1.modelId=M.modelId)
and not exists (select * from Requires R where R.modelId=M.modelId
  and not exists (select * from Holds H where H.pid=P.pid and H.certCode=R.certCode))
order by M.modelId, P.pid;