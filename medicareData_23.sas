/* Input file */

FILENAME REFFILE '/home/kd5660/respiratoryVent_medicare2015a.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=mediData
	REPLACE;
RUN;

* Print the first few rows to ensure data import was successful;
PROC PRINT DATA=mediData (OBS=5); 
RUN;

* Perform Linear Regression;
PROC REG DATA=mediData;
    MODEL AverageTotalPayments = TotalDischarges;
RUN;
QUIT;

'''* Perform ANOVA;
PROC GLM DATA=mediData;
    CLASS ProviderState;
    MODEL AverageTotalPayments = ProviderState / SOLUTION;
    LSMEANS ProviderState / ADJUST=TUKEY;
RUN;
QUIT;

