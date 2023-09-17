-- Top 10 characteristics assoicated with malignancy

/* Import Data */
PROC IMPORT 
	DATAFILE='/home/kd5660/breastCancerDx1.csv'
    OUT=dataBCDx 
    DBMS=CSV 
    REPLACE;
RUN;

/* Compute correlation */
proc corr data=dataBCDx noprint out=corr_matrix;
run;

/* Extract correlation with diagnosis */
data diag_corr;
    set corr_matrix;
    diagnosis_corr = diagnosis;
    keep _name_ diagnosis_corr;
run;

/* Sort and select top 10 correlated variables with diagnosis */
proc sort data=diag_corr out=sorted_diag_corr; 
    by descending diagnosis_corr; 
run;

data top10_vars (keep=_name_);
    set sorted_diag_corr (obs=11);
    counter + 1;
    if counter > 1; /* Exclude 'diagnosis' itself */
run;


/* Create a list of top 10 variables for the correlation matrix */
proc corr data=dataBCDx noprint out=top10_corr_matrix;
    var &varlist;
run;

/* Convert to a long format for the heatmap */
data long_format_top10;
    set top10_corr_matrix;
    array vars {*} &varlist;
    do i = 1 to dim(vars);
        variable = vname(vars{i});
        value = vars{i};
        output;
    end;
    drop i &varlist;
run;

/* Compute correlation matrix for top 10 variables */
proc corr data=breastCancerDx noprint out=top10_corr_matrix;
    var &varlist;
run;

/* Convert to a long format for the heatmap */
data long_format_top10;
    set top10_corr_matrix;
    array vars {*} &varlist;
    do i = 1 to dim(vars);
        variable = vname(vars{i});
        value = vars{i};
        output;
    end;
    drop i &varlist;
run;

/* Create the heatmap */
ods graphics on;
proc sgplot data=long_format_top10;
    heatmapcont x=variable y=_name_ / colormodel=twoColorRamp colorresponse=value;
    gradlegend / title='Correlation';
run;
ods graphics off;









