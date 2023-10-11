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
skipProcessing = 0; 
settings.is_WCU = 1; % 0 = AB, 1 = WCU

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
% plotEachTrial(cycle_parameters,'F_tan')

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

parameters = {'F_tot', 'F_tan','F_rad'};
side = 'left'; 
plotWithConfidenceBands(mean_curves_per_condition,parameters,side, settings)


% one factorial anova 
[p,t,stats] = anova1(results_descriptive_stats.Speed.left.Max); % are there differences between the three conditons? 
% if yes, which differences exist?
[c,m,h,gnames] = multcompare(stats);
% 
% % manova -> independent variable=gripping position, dependent variables=
% % Ftot, Ftan, Frad
% 
% species = [repmat("Front",8,1);repmat("Middle",8,1);repmat("Rear",8,1)]; 
% meas = [results_descriptive_stats.F_tot.left.Max(:),results_descriptive_stats.F_tan.left.Max(:),results_descriptive_stats.F_rad.left.Max(:)]; 
% 
% t = table(species,meas(:,1),meas(:,2),meas(:,3),...
% 'VariableNames',{'species','meas1','meas2','meas3'});
% Meas = table([1 2 3]','VariableNames',{'Measurements'});
% 
% rm = fitrm(t,'meas1-meas3~species','WithinDesign',Meas);
% 
% [ranovatbl,A,C,D] = ranova(rm); 
% [ranovatbl,A,C,D] = manova(rm); 
% manova(rm,'By','species')
% 
% % one way multivariate analysis of variances 
% [d, p, stats] = manova1(meas, species); 

