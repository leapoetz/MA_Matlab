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
skipProcessing = 1;  

if skipProcessing
    if settings.is_WCU
        load("data\interim\WCU\data_processed.mat")
    else
        load("data\interim\AB\data_processed.mat")
    end   

else

    if redo
        subjData = loadAndCreateSubjData(settings);
    else
        if settings.is_WCU % for group WCU (wheelchair users)
            load('data\raw\WCU\subjData.mat') 
        else % for group AB (able-bodied)
            load('data\raw\AB\subjData.mat') 
        end
    end

    %% process data
    data_processed = processData(subjData,settings);

end


%% calculate parameters

% continous parameters
[continous_parameters, cycles] = calcContinousParameters(data_processed, settings); 
% plotControlCycles(continous_parameters, cycles, settings)

% cycle parameters
cycle_parameters = calcCycleParameters(continous_parameters, cycles, settings); 
% plotEachTrial(cycle_parameters,'PFA_kinematic')

% build means 
mean_curves_per_condition = buildMeanCurves(cycle_parameters, settings); 
% plot mean curves for each subject and condition
plotMeanCurves(mean_curves_per_condition, settings)

% do descriptive statistics for each subject
results_descriptive_stats = doDescriptiveStats(mean_curves_per_condition, settings);

% final table with means over all subjects 
T_final = doFinalTable(results_descriptive_stats, settings); 

%% statistics  

close all 
load("data\processed\mean_curves_bothGroups.mat")

parameters = {'F_tot', 'F_tan','F_rad'};
side = 'left'; 
plotWithConfidenceBands(mean_curves_per_condition,parameters,side, settings)


