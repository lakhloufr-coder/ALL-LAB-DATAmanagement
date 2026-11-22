-- 1.
CREATE OR REPLACE VIEW UpcomingApprovedReservationsByLab AS
SELECT L.labId AS labId,
       L.name AS labName,
       DATE(R.plannedStart) AS reservationDate,
       COUNT(DISTINCT Rs.resId) AS approvedReservations
FROM Reserves Rs
JOIN Reservation R ON R.resId = Rs.resId
JOIN EquipmentUnit E ON E.serialNo = Rs.serialNo
JOIN Laboratory L ON L.labId = E.labId
WHERE R.status = 'Approved'
  AND R.plannedStart >= NOW()
  AND R.plannedStart < NOW() + INTERVAL 14 DAY
GROUP BY L.labId, L.name, DATE(R.plannedStart);

SELECT * FROM UpcomingApprovedReservationsByLab;

-- 2.
CREATE OR REPLACE VIEW EquipmentInventoryByLab AS
SELECT L.labId AS labId,
       L.name AS labName,
       M.modelId AS modelId,
       M.commercialName AS commercialName,
       M.category AS category,
       COUNT(E.serialNo) AS totalUnits,
       COUNT(IF(E.status = 'InService', E.serialNo, NULL)) AS inServiceUnits,
       COUNT(IF(E.status = 'UnderMaintenance', E.serialNo, NULL)) AS underMaintenanceUnits
FROM Laboratory L
JOIN EquipmentUnit E ON L.labId = E.labId
JOIN EquipmentModel M ON M.modelId = E.modelId
GROUP BY L.labId, L.name, M.modelId, M.commercialName, M.category;

SELECT * FROM EquipmentInventoryByLab WHERE labId = 1;

-- 3.
CREATE OR REPLACE VIEW PersonReservationSummary AS
SELECT P.pid AS pid,
       P.firstName AS firstName,
       P.lastName AS lastName,
       COUNT(R.resId) AS totalReservations,
       COUNT(IF(R.status = 'Approved', 1, NULL)) AS approvedReservations,
       COUNT(IF(R.status = 'Pending', 1, NULL)) AS pendingReservations,
       COUNT(IF(R.status = 'Cancelled', 1, NULL)) AS cancelledReservations
FROM Person P
LEFT OUTER JOIN Reservation R ON P.pid = R.madeByPid
GROUP BY P.pid, P.firstName, P.lastName;

SELECT * FROM PersonReservationSummary;

-- 4.
CREATE OR REPLACE VIEW ProjectReservationSummary AS
SELECT RP.code AS projectCode,
       RP.title AS projectTitle,
       RP.status AS projectStatus,
       COUNT(R.resId) AS totalReservations,
       COUNT(IF(R.status = 'Approved', 1, NULL)) AS approvedReservations,
       MIN(IF(R.status = 'Approved' AND R.plannedStart >= NOW(), R.plannedStart, NULL)) AS nextApprovedReservation
FROM ResearchProject RP
LEFT OUTER JOIN Reservation R ON R.projectCode = RP.code
GROUP BY RP.code, RP.title, RP.status;

SELECT * FROM ProjectReservationSummary;

-- 5.
CREATE OR REPLACE VIEW LaboratoryStockSummary AS
SELECT L.labId AS labId,
       L.name AS labName,
       C.consId AS consId,
       C.name AS consumableName,
       C.unitOfMeasure AS unitOfMeasure,
       S.quantityOnHand AS quantityOnHand,
       C.reorderThreshold AS reorderThreshold,
       S.technicalPid AS technicalPid,
       S.monitoringSince AS monitoringSince,
       IF(S.quantityOnHand <= C.reorderThreshold, 'LOW', 'OK') AS stockLevel
FROM Stocks S
JOIN Laboratory L ON S.labId = L.labId
JOIN Consumable C ON C.consId = S.consId;

SELECT * FROM LaboratoryStockSummary WHERE labId = 2;