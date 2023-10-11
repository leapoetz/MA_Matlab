function results_stats = doDescriptiveStats(mean_curves, settings)

dominantSides = {'right', 'right', 'right', 'right', 'right','left','right','right'}; 
nonDominantSides = {'left','left','left','left','left','right','left','left'}; 

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
    results_stats.(parameter_name).SI = abs(1 - (results_stats.(parameter_name).(dominantSides{iSubj}).Mean ./ ...
        results_stats.(parameter_name).(nonDominantSides{iSubj}).Mean)); 
end

fprintf('...finished descriptive statistics for each condition...\n')

if settings.doSave
    if settings.is_WCU
        save( fullfile( settings.projectPath,['data',filesep,'processed',filesep,'WCU',filesep],'results_stats.mat'), 'results_stats' )
    else
        save( fullfile( settings.projectPath,['data',filesep,'processed',filesep,'AB',filesep],'results_stats.mat'), 'results_stats' )
    end
end

end