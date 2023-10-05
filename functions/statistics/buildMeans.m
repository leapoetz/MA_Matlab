function [means_per_condition, std_per_condition] = buildMeanCurves(cycle_parameters)


%% predefs
subjNames = fieldnames(cycle_parameters);
nSubj = numel(subjNames);
fprintf('...start calculating parameters...\n')

sides = {'left', 'right'};


for iSubj = 1:nSubj
    conditions = fieldnames(cycle_parameters.(subjNames{iSubj}));
    nCondition = numel(conditions);
    fprintf(['...for ', subjNames{iSubj}, '\n'])

    for iCondition = 1:nCondition
        trials = fieldnames(cycle_parameters.(subjNames{iSubj}).(conditions{iCondition}));
        nTrials = numel(trials);
        fprintf(['...for ', conditions{iCondition}, '\n'])


        parameter_names = fieldnames(cycle_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{1}));

        for iParameter = 1 : length(parameter_names)
            parameter_name = parameter_names{iParameter};

            for iSide = 1 : length(sides)
                thisSide = sides{iSide};

                all_trials = nan(nTrials,100);
                for iTrial = 1:nTrials
                    fprintf(['...for ', trials{iTrial}, '\n'])

                    this_cycle_parameters = cycle_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial});

                    all_trials(iTrial,:) = this_cycle_parameters.(parameter_name).(thisSide);
                end
                means_per_condition.(parameter_name).(thisSide){iSubj,iCondition} = mean(all_trials);
            end
        end
    end
end

end