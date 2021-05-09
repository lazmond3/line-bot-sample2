import pymysql
import os
Database_endpoint = os.environ['ENDPOINT']
Username = os.environ['USER']
Password = os.environ['PASS']
PORT = int(os.environ['PORT'])
try:
    print("Connecting to "+Database_endpoint)
    db = pymysql.connect(host=Database_endpoint,user=Username,password=Password, port=PORT)
    print ("Connection successful to "+Database_endpoint)
    with db:
        with db.cursor() as cursor:
            # Create a new record
            sql = "SELECT 1+1"
            cursor.execute(sql)
            result = cursor.fetchone()
            print("result: ", result)


except Exception as e:
    print ("FAILED: Connection unsuccessful due to "+str(e))
