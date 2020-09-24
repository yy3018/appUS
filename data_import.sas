/* Further Cleaning will be done below*/
FILENAME raw_data '/folders/myfolders/appendicitisUS/appUS.csv';

PROC IMPORT DATAFILE=raw_data DBMS=CSV OUT=appus_raw replace;
	GETNAMES=Yes;
RUN;
