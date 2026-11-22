-- Part 1
-- 1
select concat(p1.firstName ,' ', p1.lastName) as employe_name , concat(p2.firstName,' ' , p2.lastName) as supervior_name
from Employee E join Person p1 on E.pid=p1.pid Left outer join Employee R on E.supervisorPid=R.pid left join Person p2 on  R.pid=p2.pid  ;


-- 2 
select R.resid ,concat(A.firstName, ' ',A.lastName) as approver_name 
from Reservation R left outer join Person A on R.approverpid=A.pid ;

-- where R.approvedpid is not null
-- is correct ? and also that because only we have to keep inapproved certification


-- 3 
select A.serialNO ,B.serialNO 
from EquipmentUnit A join EquipmentUnit B on A.labid <B.labid  and A.modelid =B.modelid ;

-- 4

select M.modelid , M.commercialName ,count(E.serialNO)
from EquipmentModel M left outer join EquipmentUnit E on M.modelid=E.modelid 
group by M.modelid , M.commercialName ;

-- 5
-- doit marche cela  ??
select E.labid ,E.serialNo
from EquipmentUnit E
where E.purchaseCost >= all (
                     select E2.purchaseCost
                     from EquipmentUnit E2 
                     where E2.labid=E.labid )
order by E.labid ;

-- 6 
SELECT L.labId, L.name, SUM(S.quantityOnHand) AS sum_S
FROM Laboratory L
JOIN Stocks S ON L.labId = S.labId
GROUP BY L.labId, L.name
HAVING SUM(S.quantityOnHand) > (
    (SELECT SUM(quantityOnHand) FROM Stocks) / (SELECT COUNT(*) FROM Laboratory)
);
-- assuming tehere is laboratory not /0
-- a verifier 

-- 7 
select * 
from Consumable C
where not exists (
select L.labid
from Laboratory L
where not exists (
select *
from Stocks S
where S.labid=L.labid and S.consid = C.consid )) ;