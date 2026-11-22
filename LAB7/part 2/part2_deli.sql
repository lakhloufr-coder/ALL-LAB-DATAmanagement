-- Part 2 :
-- 1 
-- how to relie that with lboatory the reservation don't have aucun relation with him

create or replace view UpcomingApprovedReservationsByLab as 
-- have to handle case for same riservation  have more than one equipment on the same lab
select L.labid as labid ,L.name as labname, date(R.plannedStart) as reservationdate ,count(distinct Rs.resid) as distinct_count
from Reserves Rs join Reservation R on R.resid=Rs.resid join EquipmentUnit E on E.serialNO=Rs.serialNo join Laboratory L on L.labId =E.labid
where R.plannedStart between curdate() and curdate() + interval 14 day and R.status='Approved'
-- not approved not null but status approved
group by L.labid,L.name ,date(R.plannedStart);

select * 
from UpcomingApprovedReservationsByLab UP where UP.labid =2 ;

-- this viewit will hep in this case for the person will now the lab that have to handle there tables like stocks ,conum ..

-- 2 

create or replace view  EquipmentInventoryByLab as 
select L.labid as labid ,L.name as namelab , M.modelid as modelid , M.commercialName as commercialName,M.category as Category ,count(E.serialNO) as total_units ,count(if(E.status='InService',E.serialNo,NULL)) as count_inservice,count(if(E.status='UnderMaintenance',E.serialNo,NULL)) as number_undermaintenance
from Laboratory L inner join EquipmentUnit E on L.labid=E.labid inner join EquipmentModel M on M.modelid=E.modelid 
group by L.labid , L.name , M.modelid , M.commercialName , M.category ;
-- a reverfier les choses detailles
select * from EquipmentInventoryByLab LB where LB.labid=1 ;
-- it will this view to see the unit how distribued in the boratory and coan copmaraiesd them or more than that 


-- 3
-- va etre une problme lorsuqe each preson pas meme seul personne

create or replace view PersonReservationSummary as
select P.pid as pid ,P.firstName as firstName ,P.lastName as lastName ,count(R.resid) as total_res ,count(if(R.status='Approved' ,1,NULL)) as  approved_res ,count(if(R.status='Pending' ,1,NULL)) as Pending_res ,count(if(R.status='Cancelled',1,NULL)) as Cancelled_res
from Person P left outer join Reservation R on P.pid=R.madeByPid 
group by P.pid , P.firstName , P.lastName ;
-- how about peron never do a reservation

select * from PersonReservationSummary ;

-- 4 
create or replace view  ProjectReservationSummary as 
select RP.code as projectcode , RP.title as projecttitle , RP.status as projectstatus , count(R.resid) as total_res ,count(if(R.status='Approved',1,NULL)) as total_approved_res ,min(if(R.status='Approved' and R.plannedStart >= now(),R.plannedStart,NULL)) as next_approved
from ResearchProject RP left outer join Reservation R on R.projectCode=RP.code 
group by RP.code , RP.title , RP.status;
-- i think may only the current or all possible reseration in the furtur apper ???
select * from ProjectReservationSummary  PS where PS.projectcode='P1';
-- it will help to seee all reservation relate to an proejct code 


-- 5 

create or replace view LaboratoryStockSummary as 
select L.labid as labid, L.name as labname , C.consid as consid ,C.name as consumablename  , C.unitofMeasure as unitmeasure , S.quantityOnHand as quantityOnHand,C.reorderThreshold as reorderThreshold ,S.technicalPid as technicalPid,S.monitoringSince  as monitoringSince , if( S.quantityOnHand <=C.reorderThreshold ,'LOW','OK') as stockLevel
-- the reanme as in each nooum of coulumn raly help
from Stocks S join Laboratory L on S.labid=L.labid join Consumable C on C.consid=S.consid ;
-- there is 3 relation that hold this view 
select * from LaboratoryStockSummary as LS where LS.labid=2;

-- this view will help to summarise for each laboratory the current consumbale