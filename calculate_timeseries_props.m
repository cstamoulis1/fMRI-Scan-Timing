
function timeseries_props = calculate_timeseries_props(subID, frames_threshold,RS_connectivity)
%   PURPOSE: Code for obtaining fluctuation statistics for individual mode
%   band raw data.

%   INPUT:
%   subID: individual identifier number for each participant
%   frames_threshold: upper limit of % of frames censored at which a
%   run of data is no longer satisfactory
%   RS_connectivity: connectivity matrix from ABCD data with all runs

%   OUTPUT: 
%   timeseries_props: matrix of signal fluctuation properties
%
%   Last modified: May 30, 2023

% load connectome data
S = dir(strcat(subID,'*',scan_year_str(5:end),'*'));
filename = S(1).name;
RS_net = load(filename,'RS_net');
% adjusts structure if necessary
if isfield(RS_net,'RS_net') == 1
    RS_net = RS_net.RS_net;
end
RS_fluctuation = cell(1,4);
for i = 1:numel(RS_fluctuation)
    my_struct = struct('variation', [], 'dispersion', []);
    RS_fluctuation{i} = my_struct;
end

% loads information on mode frequency and amplitude;
% adjusts structure if necessary

isNormalized = 0;
for run1 = 1:length(RS_net)
    % checks that run is not empty
    if ~isempty(RS_net{run1})
        RS_connectivity{run1}.percentCensored = RS_net{run1}.percentCensored;
        if RS_net{run1}.percentCensored < frames_threshold
            % creates cell array to store correlation matrix for each mode
            if isfield(RS_net{run1},'rawData_normalized')
                isNormalized = 1;
                if ~isempty(RS_net{run1}.rawData_normalized)
                    fs = 1/RS_net{run1}.TR;
                    rawData = RS_net{run1}.rawData_reduced_modes;
                    numNodes = size(rawData,1);

                    % calculate coefficient of variation
                    men = mean(rawData,2, 'omitnan');
                    stand = std(rawData,0,2,'omitnan');
                    RS_fluctuation{run1}.variation = stand./men;
                    % calculate coefficient of dispersion
                    pct75  = prctile(rawData,75,2);
                    pct25 = prctile(rawData,25,2);
                    RS_fluctuation{run1}.dispersion = (pct75 - pct25)./(pct75 + pct25);
                end
            end
        end
    end
end

if isNormalized
    timeseries_props = RS_fluctuation;
end

end