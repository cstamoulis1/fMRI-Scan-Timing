%   PURPOSE: run (fMRI) whole brain, network, and node level models (brain 
%   as outcome), obesity-sMRI-fMRI mediation models, and cognitive task models
%
%   REQUIRES: 
%   regression_multi_response.m (run models)
%   get_mdl_stats.m (get statistics)
%   Node_Groups.mat (FDR correction for node models)
%
%   Last modified: May 30, 2023
%% SETUP

%load table of controls/covariates/predictor of interest as pred_tbl

%pred_interest = string of variable name: 'time-of-day','time-of-week', 
% 'time-of-year', etc.

%load response variables:
%whole brain: propstable = table of whole-brain properties

%network: netprops: struct, one field per network, each containing a
%table of network properties

%node: nodeprops: struct, one field per property, each contains a table of
%node values

%serial fluctuation: obtain property values by finding median on that scale
%serialProp = table of rs-fMRI signal fluctuations 
%(absolute value of the coefficient of dispersion and variation);
%variation_hemis = table of absolute value of the coefficient of variation 
%on hemisphere level;
%dispersion_hemis = table of absolute value of the coefficient of
%dispersion on hemisphere level;
%variation_SN = table of absolute value of the coefficient of variation 
%for each sub-network;
%dispersion_SN = table of absolute value of the coefficient of dispersion
%for each sub-network

%cognitive task: cog_tasks = table of cognitive task results 

%Note: remove underweight subjects from models and make sure rows are the same
%across all tables

%% WHOLE BRAIN LEVEL

[wb_stats, wb_mdls] = regression_mdls_multi_response(pred_tbl, propstable, pred_interest, 1);

%% NETWORK LEVEL

net_stats = struct;
net_lst = fieldnames(netprops); %list of networks

for n=1:length(net_lst) 
    [net_stats.(net_lst{n}),~] = regression_mdls_multi_response(pred_tbl, netprops.(net_lst{n}), pred_interest);
end

%% NODE LEVEL

load('Node_Groups.mat', 'node_groups'); %for FDR correction

node_stats = struct;
prop_lst = fieldnames(nodeprops); %list of node properties

for p=1:length(prop_lst) 
    [node_stats.(prop_lst{p}),~] = regression_mdls_multi_response(pred_tbl, nodeprops.(prop_lst{p}), pred_interest, 0, node_groups.group_inds);
end

%% SERIAL FLUCTUATION
% whole-brain level
[wb_serial_stats, wb_serial_mdls] = regression_mdls_multi_response(pred_tbl, serialProp, pred_interest, 1);
% hemisphere level, properties based on coordinate
[hemis_disp_stats, hemis_disp_mdls] = regression_mdls_multi_response(pred_tbl, dispersion_hemis, pred_interest, 1);
[hemis_var_stats, hemis_var_mdls] = regression_mdls_multi_response(pred_tbl, variation_hemis, pred_interest, 1);
% network level
[SN_disp_stats, SN_disp_mdls] = regression_mdls_multi_response(pred_tbl, dispersion_SN, pred_interest, 1);
[SN_var_stats, SN_var_mdls] = regression_mdls_multi_response(pred_tbl, variation_SNs, pred_interest, 1);

 
%% COGNITIVE TASK OUTCOMES
%these models do not need to include percent of frames censored for motion
%since this variable is a relevant adjustment for models including brain parameters
pred_tbl_no_pc = pred_tbl;
pred_tbl_no_pc(:, 'percent_censored') = [];

[cog_stats, cog_mdls] = regression_mdls_multi_response(pred_tbl_no_pc, cog_tasks, pred_interest, 1);