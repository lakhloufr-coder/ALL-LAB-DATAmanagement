import mysql.connector
from mysql.connector import Error

def foundnamelab(con, labn):
    cursor = con.cursor()
    query = ("select E.serialNo, M.commercialName "
             "from EquipmentUnit E "
             "inner join Laboratory L on L.labId = E.labId "
             "inner join EquipmentModel M on M.modelId = E.modelId "
             "where L.name = %s and E.status = 'InService'")
    cursor.execute(query, (labn,))
    for row in cursor.fetchall():
        print(row[0], row[1])
    cursor.close()

def stocklevel(con):
    cursor = con.cursor()
    cursor.execute("select * from LaboratoryStockSummary where stockLevel = %s", ('LOW',))
    for row in cursor.fetchall():
        print(row)
    cursor.close()

def restocklab(con, labid, consid, qty):
    cursor = con.cursor()
    try:
        result = cursor.callproc("RestockLab", [labid, consid, qty, 0])
        con.commit()
        print("new quantity:", result[3])
    except Error as er:
        print("restock error:", er.msg)
    finally:
        cursor.close()

def insertreserveshandle(con, resid, serialNo):
    cursor = con.cursor()
    try:
        cursor.execute("insert into Reserves values (%s, %s)", (resid, serialNo))
        con.commit()
        print("insertion reussie")
    except Error as er:
        print("database error:", er.msg)
    finally:
        cursor.close()

try:
    con = mysql.connector.connect(host="localhost", user="root",
                                  password="redareda", database="rlms_lab6")
    foundnamelab(con, "Physics Laboratory")
    stocklevel(con)
    restocklab(con, 1, 1, 9)
    insertreserveshandle(con, 24, "U4")
    con.close()
except Error as er:
    print("connection error:", er.msg)