function T_results = doFinalTable(results_descriptive_stats)

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

                if iSide == 1
                    stats_left(iCondition,iStat) = thisMean;
                else
                    stats_right(iCondition,iStat) = thisMean;
                end

            end
        end
    end
    conditions = {'Condition1'; 'Condition2'; 'Condition3'};
    T_parameter = table(conditions,stats_left(:,1),stats_left(:,2),stats_left(:,3),stats_right(:,1),stats_right(:,2),stats_right(:,3));
    T_parameter.Properties.VariableNames = {'Condition','Mean L','Max L','Std L','Mean R','Max R','Std R'};

    T_results.(parameter_name) = T_parameter;
end


fprintf('...finished descriptive statistics for each condition...\n')

end