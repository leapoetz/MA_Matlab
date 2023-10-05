%% MA Lea Main Script
% LP 10/23

clc
clear
close all

%% init folder
projectPath = pwd;
initStructure(projectPath);
settings = chooseSettings(projectPath); 

%% load data
redo = 0; % use redo if data folder was updated, else load current files 

if redo
    subjData = loadAndCreateSubjData(settings); 
else
%     load('data/raw_WCU/subjData.mat') % for group WCU (wheelchair users)
    load('data/raw/subjData.mat') % for group AB (able-bodied)
end

%% process data
data_processed = processData(subjData,settings); 

%% calculate parameters

% continous parameters
[continous_parameters, cycles] = calcContinousParameters(data_processed, settings); 
% plotControlCycles(continous_parameters, cycles, settings)

% cycle parameters
cycle_parameters = calcCycleParameters(continous_parameters, cycles, settings); 
% plotEachTrial(cycle_parameters,'F_tot')

% build means 
results_curve_means = buildMeanCurves(cycle_parameters, settings); 
% plot mean curves for each subject and condition
plotMeanCurves(results_curve_means)

% do descriptive statistics for each subject
results_descriptive_stats = doDescriptiveStats(results_curve_means);

% final table with means over all subjects 
T_final = doFinalTable(results_descriptive_stats); 

%% statistics  


