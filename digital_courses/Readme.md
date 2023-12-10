how to run on your  local machine ?

change infos here in these 2 lines of code by right click on your database and get infos from 

"dsn_tns = cx_Oracle.makedsn('localhost', '1521', service_name='xe')"
"connection = cx_Oracle.connect(user='sys', password='*******',mode=cx_Oracle.SYSDBA, dsn=dsn_tns)"


do also : 
pip install streamlit
pip install firebase_admin
pip install oracledb
conda install cx_oracle ( you have to have conda installed in your computer, if you still get errors message me, it took me long time to solve it xD)

finally : 

to run do on the terminal the following command : 

streamlit run main.py


