/* Load Data */
PROC IMPORT 
	DATAFILE='/home/kd5660/ebolaConfirDeathMar2019.csv'
    OUT=mydata 
    DBMS=CSV 
    REPLACE;
RUN;

/* Get Mean STD Min Max */
PROC MEANS data=mydata N MEAN STD MIN MAX;
    VAR confirmCases;
RUN;

/* Perform Linear regression - Predict deaths vs Confirmed Cases */
proc reg data=mydata;
    model deaths = confirmCases;
    title 'Linear Regression to Predict Deaths based on Confirmed Cases';
run;
quit;

