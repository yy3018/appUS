/* Further Cleaning will be done below*/

*libname pocus XLSX '/folders/myfolders/appendicitisUS/POCUS.xlsx';

FILENAME raw_data '/folders/myfolders/appendicitisUS/appUS.csv';

PROC IMPORT DATAFILE=raw_data DBMS=CSV OUT=appus_raw replace;
	GETNAMES=Yes;
RUN;

data appus;
	set appus_raw(drop=Var1 var_84 var_91 var_93);
	
	/*rename*/
	rename var_1=site var_2=id var_4=abd_pain_to_us1 var_6=us1_to_us2 
		var_10=us2_to_surg var_24=gender var_33=us1_department 
		var_55=antibio_1 var_60=us2_department var_82=antibio_2 var_89=easiness 
		var_90=patient_tolerence;
		
	/* Extract time from time variable*/
	abd_pain_to_us1_h =  round(input(substr(var_4,1,3),best.)*24 + input(substr(var_4,5,2),best.)+input(substr(var_4,8,2),best.)/60,.01);
	us1_to_us2_h = round(input(scan(var_6,1),2.)*24+input(scan(var_6,3),2.)+input(scan(var_6,5),2.)/60,.01);
	us2_to_surg_h = round(input(scan(var_10,1),2.)*24+input(scan(var_10,3),2.)+input(scan(var_10,5),2.)/60,.01);
		
	/* Remove : from Yes for surgery performed column*/
	surg_performed=substr(var_17, 1,3);
	
	/* Correct data type for numeric column */
	us1_stage=input(var_12, 1.);
	us2_stage=input(var_14, 1.);
	change_stage=input(var_11, 1.);
	surg_stage=input(var_20, 1.);
	age=input(var_23, 2.);
	height=input(var_25, 3.);
	weight=input(var_26, 3.);
	us1_length=input(var_32, 3.);
	us2_length=input(var_59, 3.);
	
    /*  Creat an ID column for each subject	 */
	
	/* drop */
	drop var_11 var_12 var_14 var_17 var_23 var_20 var_25 var_26 var_32 var_59;
run;