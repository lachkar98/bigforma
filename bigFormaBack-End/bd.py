import cx_Oracle

class Db:
    def __init__(self) -> None:
        self.dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='XEPDB1')
        self.connection = cx_Oracle.connect(user='hr', password='hr', dsn=self.dsn_tns)

    def fetch_domain_formats(self):
        cursor = self.connection.cursor()
        cursor.execute("SELECT * FROM DOMAINEFORMATION ")
        for row in cursor:
            print(row)
        cursor.close()
        self.connection.close()

Db().fetch_domain_formats()