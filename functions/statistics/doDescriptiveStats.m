function results_stats = doDescriptiveStats(mean_curves)

%% predefs
fprintf('...do descriptive statistics for each condition...\n')
sides = {'left', 'right'};
parameter_names = fieldnames(mean_curves);

for iParameter = 1 : length(parameter_names)
    parameter_name = parameter_names{iParameter};

    for iSide = 1 : length(sides)
        thisSide = sides{iSide};
        nSubj = size(mean_curves.(parameter_name).(thisSide),1);

        for iSubj = 1:nSubj
            nCondition = size(mean_curves.(parameter_name).(thisSide),2);

            for iCondition = 1:nCondition

                thisCurve = mean_curves.(parameter_name).(thisSide){iSubj,iCondition};

                mean_value = mean(thisCurve);
                max_value = max(thisCurve);
                std_value = std(thisCurve);

                stat_matrix.Mean(iSubj,iCondition) = mean_value;
                stat_matrix.Max(iSubj,iCondition) = max_value;
                stat_matrix.Std(iSubj,iCondition) = std_value;
            end
        end
        results_stats.(parameter_name).(thisSide) = stat_matrix;
    end
end

fprintf('...finished descriptive statistics for each condition...\n')
end