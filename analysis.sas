proc univariate data=appus;
	var age;
	histogram age;
run;

/* Table 1: Gender Age Height Weight */
proc format;
	value overall 1='Overall';
run;

data tb1;
	set appus;
	overall=1;
run;

proc template;
	define style styles.janettables;
		parent=styles.minimal;
		style bodyDate from bodyDate / font=('Times', 8pt);
		style PagesDate from PagesDate / font=('Times', 8pt);
		style PagesTitle from PagesTitle / font=('Times', 8pt);
		style SystemTitle from SystemTitle / font=('Times', 12pt);
		style Data from Data / font=('Times, Times, Times', 8pt);
		style Header from HeadersAndFooters / font=('Times, Times, Times', 8pt);
		style RowHeader from HeadersAndFooters / font=('Times, Times, Times', 8pt);
	end;
	run;


ods rtf style=janettables file='/folders/myfolders/appendicitisUS/table1_category.rtf';
proc tabulate data=tb1;
	class gender overall;
	table (gender all), overall=''*(n  colpctn='%'*f=pctfmt.)/misstext='0' rts=15;
	format overall overall. ;
run;
ods rtf close;

	
ods rtf style=janettables file='/folders/myfolders/appendicitisUS/table1_numeric.rtf';
proc tabulate data=tb1 missing order=formatted;
 label age
 class overall;
 var age weight height ;
 tables age weight height,
 overall=''*(N Mean stddev='SD' min='Min' max=Max qrange='Range');
 format overall overall.;
run;
ods rtf close;
run;


/* Confusion Matrix */

data appus_us2_surg;
	set appus;
	where us2_stage IS NOT MISSING and
	surg_stage IS NOT MISSING;
	
	if us2_stage=surg_stage then do;
		us2_match_surg = 1;
		surg_match_us2 = 1;
	else then do;
		
run;

/* 4x4 */
proc freq data=appus_us2_surg;
   tables us2_stage*surg_stage / norow nocol nopct  fisher;
run;


/* It seems that US2 tends to lead worse diagnose than the actual */
/* Let's confirm this: if surg_stage<us2_stage=1 else 0*/

data appus_surg_us2_compar;
	set appus;
	where us2_stage IS NOT MISSING and
	surg_stage IS NOT MISSING;
	
	if surg_stage<us2_stage then us2Gsurg='> surgery';
	else us2Gsurg = '<= surgery';
run;

proc freq data=appus_surg_us2_compar;
   tables us2Gsurg  / norow nocol nopct  binomial(p=0.5);
run;