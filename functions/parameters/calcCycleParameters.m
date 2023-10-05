function cycle_parameters = calcCycleParameters(cont_parameters, cycles, settings)
% create mean curves over cycles of one trial
% normalize these curves to 100 data points 

% predefs
subjNames = fieldnames(cont_parameters);
nSubj = numel(subjNames);
fprintf('...start calculating parameters...\n')

sides = {'left', 'right'};
goalLength = 100; % 1-100% of push phase 

for iSubj = 1:nSubj
    conditions = fieldnames(cont_parameters.(subjNames{iSubj}));
    nCondition = numel(conditions);
    fprintf(['...for ', subjNames{iSubj}, '\n'])

    for iCondition = 1:nCondition
        trials = fieldnames(cont_parameters.(subjNames{iSubj}).(conditions{iCondition}));
        nTrials = numel(trials);
        fprintf(['...for ', conditions{iCondition}, '\n'])

        for iTrial = 1:nTrials
            fprintf(['...for ', trials{iTrial}, '\n'])

            this_cont_parameters = cont_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial});
            this_cycles = cycles.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial});

            parameter_names = fieldnames(this_cont_parameters);

            for iParameter = 1 : length(parameter_names)
                parameter_name = parameter_names{iParameter};

                for iSide = 1 : length(sides)
                    thisSide = sides{iSide};
                    
                    cycles_per_trial = nan(length(this_cycles.(thisSide)),goalLength); 
                    for iCycle = 1 : length(this_cycles.(thisSide))
                        thisInterval = this_cycles.(thisSide){iCycle};
                        old_interval = 1 : length(thisInterval);

                        % time normalization to 1-100% of push phase 
%                         cycles_per_trial(iCycle,:) = interp1(old_interval, this_cont_parameters.(parameter_name).(thisSide)(thisInterval), new_interval);
                        cycles_per_trial(iCycle,:) = timeNormalization4vector(this_cont_parameters.(parameter_name).(thisSide)(thisInterval),old_interval,goalLength);
                    end

                    % mean of all cycles 
                    if size(cycles_per_trial,1) == 1
                        parameters.(parameter_name).(thisSide) = cycles_per_trial;
                    else
                        parameters.(parameter_name).(thisSide) = mean(cycles_per_trial, "omitnan");
                    end

                end
            end

            cycle_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}) = parameters; 
            parameters = []; 
        end
    end
end
fprintf('...finished calculating cycle parameters \n')

if settings.doSave
    cd(settings.projectPath);
    cd('data/interim')
    save('cycle_parameters.mat', 'cycle_parameters');
end

end