-- 1.
SELECT CONCAT(P1.firstName, ' ', P1.lastName) AS employee_name,
       CONCAT(P2.firstName, ' ', P2.lastName) AS supervisor_name
FROM Employee E
JOIN Person P1 ON E.pid = P1.pid
LEFT OUTER JOIN Employee R ON E.supervisorPid = R.pid
LEFT OUTER JOIN Person P2 ON R.pid = P2.pid;

-- 2.
SELECT R.resId, CONCAT(A.firstName, ' ', A.lastName) AS approver_name
FROM Reservation R
LEFT OUTER JOIN Person A ON R.approverPid = A.pid;

-- 3.
SELECT A.serialNo AS unit_1, B.serialNo AS unit_2, A.modelId
FROM EquipmentUnit A
JOIN EquipmentUnit B ON A.modelId = B.modelId AND A.labId < B.labId;

-- 4.
SELECT M.modelId, M.commercialName, COUNT(E.serialNo) AS nb_units
FROM EquipmentModel M
LEFT OUTER JOIN EquipmentUnit E ON M.modelId = E.modelId
GROUP BY M.modelId, M.commercialName;

-- 5.
SELECT E.labId, E.serialNo
FROM EquipmentUnit E
WHERE E.purchaseCost >= ALL (SELECT E2.purchaseCost
                             FROM EquipmentUnit E2
                             WHERE E2.labId = E.labId)
ORDER BY E.labId;

-- 6.
SELECT L.labId, L.name, SUM(S.quantityOnHand) AS total_quantity
FROM Laboratory L
JOIN Stocks S ON L.labId = S.labId
GROUP BY L.labId, L.name
HAVING SUM(S.quantityOnHand) > (SELECT SUM(quantityOnHand) FROM Stocks)
                              / (SELECT COUNT(*) FROM Laboratory);

-- 7.
SELECT C.consId, C.name
FROM Consumable C
WHERE NOT EXISTS (SELECT L.labId
                  FROM Laboratory L
                  WHERE NOT EXISTS (SELECT 1
                                    FROM Stocks S
                                    WHERE S.labId = L.labId
                                      AND S.consId = C.consId));