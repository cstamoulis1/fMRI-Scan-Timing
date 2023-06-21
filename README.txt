Description of codes associated with paper:
Linfeng Hu, Calli Smith, Eliot S Katz, Catherine Stamoulis
"Modulatory effects of fMRI Acquisition Time of Day, Week and 
Year on Adolescent Functional Connectomes Across Spatial Scales: 
Implications for Inference"
Codes last modified: May 30, 2023

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FILES:

run_statmodels.m: 
Script to load variables and run appropriate models

regression_mdls_multi_response.m: 
Function used to run linear (or logistic) regression for a given set of 
controls/covariates/predictors (including a single predictor of interest) 
across multiple response variables. Produces a table of statistics 
(FDR correction is performed as requested) and a map of models.

get_mdl_stats.m:
Function used to create a table of common statistics for a single model object 
and predictor of interest (called by regression_mdls_multi_response.m).

calculate_timeseries_props.m:
Function used to compute serial fluctuation properties (variation and dispersion).

Node_Groups.mat:
In functional network analyses at the node level, 
this file is needed for adjusting p-values for the False Discovery Rate (FDR).
In the case of node properties, FDR corrections are used across nodes belonging to a 
particular network. Nodes are grouped according to the networks identified 
in Yeo et al, 2011

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VARIABLES REQUIRED:

Independent variables: 
1) Control and covariate variables: propensity weights, sex, age, race, ethnicity, 
family income, BMI, physical activity (YRB), screen time (STQ), and percent of 
frames censored for motion

2) Predictor of Interest: 
    a) Time-of-day (in hours), rounded to the nearest hour in which scanning began 
    (variable in the range 8 - 20 in the dataset); 
    b) Time-of-week, a dichotomous variable (1 = weekday, 2 = weekend); 
    c) Time-of-year, a dichotomous variable (1 = school year, 2 = summer vacation). 
    School year was assumed to be September 1 - June 15, and summer vacation June 16 - 
    August 31, based on an average public school schedule for regions within 50 miles 
    from the ABCD sites.

Dependent Variables: 

In primary models: rs-fMRI topological network properties for whole brain, 
network, and node scales. 
In this study, fMRI analyses were conducted using participants' best and 
second best run from release R4.0.

Whole brain and network level properties: Efficiency, global clustering, 
median connectivity, modularity (Newman), small-worldness, robustness, 
stability. 
Node level: centrality, local clustering, degree.

In serial fluctuation models: rs-fMRI signal fluctuations 
(coefficient of dispersion and variation) 

In cognitive task models: cognitive task responses (NIH toolbox battery)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RUNNING MODELS: run_statmodels.m

After loading needed variables, run section-by-section to produce 
appropriate models and statistics.

Uses regression_mdls_multi_response and get_mdl_stats to run regression models
and calculate appropriate statistics for each set of models. 

Uses Node_Groups and Structure_Groups for appropriate FDR correction, based on node
or structure grouping according to the networks identified in Yeo et al, 2011. 