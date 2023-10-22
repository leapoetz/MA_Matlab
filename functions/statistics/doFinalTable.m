function T_results = doFinalTable(results_descriptive_stats, settings)

%% predefs
fprintf('...do final results table...\n')
sides = {'left', 'right'};
parameter_names = fieldnames(results_descriptive_stats);

for iParameter = 1 : length(parameter_names)
    parameter_name = parameter_names{iParameter};

    for iSide = 1 : length(sides)
        thisSide = sides{iSide};

        stats = fieldnames(results_descriptive_stats.(parameter_name).(thisSide)); 
        nStats = length(stats); 

        for iStat = 1 : nStats
            thisStat = stats{iStat}; 

            nCondition = width(results_descriptive_stats.(parameter_name).(thisSide).(thisStat));
            for iCondition = 1:nCondition

                thisMean = mean(results_descriptive_stats.(parameter_name).(thisSide).(thisStat)(:,iCondition)); 
                thisStd = std(results_descriptive_stats.(parameter_name).(thisSide).(thisStat)(:,iCondition)); 

                if iSide == 1
                    stats_left(iCondition,iStat) = thisMean;
                    stats_left(iCondition,iStat+2) = thisStd;
                else
                    stats_right(iCondition,iStat) = thisMean;
                    stats_right(iCondition,iStat+2) = thisStd;
                end
            end
        end
    end
    SI_mean = mean(results_descriptive_stats.(parameter_name).SI,1);
    SI_std = std(results_descriptive_stats.(parameter_name).SI,1);

    conditions = {'Condition1'; 'Condition2'; 'Condition3'};
    T_parameter = table(conditions,stats_left(:,1),stats_left(:,3),stats_left(:,2),stats_left(:,4),stats_right(:,1),stats_right(:,3),stats_right(:,2),stats_left(:,4),...
        SI_mean', SI_std');
    T_parameter.Properties.VariableNames = {'Condition','Mean L','Std Mean L','Max L','Std Max L','Mean R','Std Mean R','Max R','Std Max R', 'Mean SI','Std SI'};

    T_results.(parameter_name) = T_parameter;
end

fprintf('...finished descriptive statistics for each condition...\n')

if settings.doSave
    if settings.is_WCU
        save( fullfile( settings.projectPath,['data',filesep,'processed',filesep,'WCU',filesep],'T_results.mat'), 'T_results' )
    else
        save( fullfile( settings.projectPath,['data',filesep,'processed',filesep,'AB',filesep],'T_results.mat'), 'T_results' )
    end
end

end