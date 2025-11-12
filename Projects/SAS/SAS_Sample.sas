*CIND119 D30;
*Elizabeth Esnard;
*Assignment 1;

*Question 1;
proc import 
out = heart
datafile = '/home/u64024635/CIND119/Assignment 1/heart.csv'
dbms = csv replace;
getnames = yes;
run;

proc print data = heart (obs = 10);
run;

*Question 2;
proc means data = heart;
CLASS sex cp fbs restecg exang slope thal;
VAR age trestbps chol thalach oldpeak ca target; 
run;

*Question 3;
proc stdize 
data = heart
out = stan_hearts
method = std;
var age trestbps chol thalach oldpeak ca target;
run;

proc print data = stan_hearts (obs = 10);
run;

*Question 4;
%macro myFastClus;
	%do k=2 %to 5;
		title 'Clusters and their' &k 'Means';
		proc fastclus 
			data = stan_hearts
			out = cluster_hearts
			maxclusters = &k
			maxiter = 50
			summary;
		
		proc sgplot; 
			scatter y = chol x = age
			/ datalabel = cluster group = target;
		run;
	%end;
%mend;
%myFastClus;

proc print data = cluster_hearts;
run;

*Comment: From the k-clusters, where k = (2,3,4,5), the Observed Over-All R-Squared indicates the 
strength between our model and the dependent variable (y=chol). Of the four returned values 
for R-Squared, k = 5 resulted in the value = 0.36061, the highest of the four returned values. 
For R-squared, we seek a value close to 1, thus k = 5 is the best cluster. 



