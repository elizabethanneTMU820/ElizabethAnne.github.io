*The dataset contains information about various cardiovascular disease indicators for patients;
*with 13 numerical/categorical attributes and 1 binary target attribute indicating the presence or absence of heart disease;

*Question 1 Read the file in SAS and display the contents, print only the first 10 observations;
proc import 
out = heart
datafile = '/home/u64024635/CIND119/Assignment 1/heart.csv'
dbms = csv replace;
getnames = yes;
run;

proc print data = heart (obs = 10);
run;

*Question 2 Perform basic Data analysis using;
proc means data = heart;
CLASS sex cp fbs restecg exang slope thal;
VAR age trestbps chol thalach oldpeak ca target; 
run;

*Question 3 Apply standardization to the numerical attributes and print the data;
proc stdize 
data = heart
out = stan_hearts
method = std;
var age trestbps chol thalach oldpeak ca target;
run;

proc print data = stan_hearts (obs = 10);
run;

*Question 4 Apply k-means clustering. Scatter plot cluster labels to visualize and compare with the original data labels;
*Choose the best K value based on the RMS Std. Deviation.;
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



