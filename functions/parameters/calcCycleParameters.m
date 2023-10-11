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


                    for iCycle = 1 : length(this_cycles.(thisSide))
                        thisInterval = this_cycles.(thisSide){iCycle};
                        l(iCycle) = length(thisInterval);
                    end

%                     cycles_per_trial = nan(max(l),length(this_cycles.(thisSide)));
                    cycles_per_trial = nan(goalLength,length(this_cycles.(thisSide)));
                    for iCycle = 1 : length(this_cycles.(thisSide))
                        thisInterval = this_cycles.(thisSide){iCycle};
                        old_interval = 1 : length(thisInterval);

                        % time normalization to 1-100% of push phase
                        addZeros = max(l) - length(thisInterval);
%                         cycles_per_trial(:,iCycle) = [this_cont_parameters.(parameter_name).(thisSide)(thisInterval); zeros(addZeros,1)];
                        cycles_per_trial(:,iCycle) = timeNormalization4vector(this_cont_parameters.(parameter_name).(thisSide)(thisInterval),old_interval,goalLength);
                    end
                    
                    % Time Synchronization
                    %                     timeSynchronization4matrix(cycles_per_trial, 100);
%                     cycles_per_trial_synched_normalized = doTimeSynchronisationAndNormalization(cycles_per_trial,l,goalLength); 
%                     figure()
%                     for iCycle = 1 : length(this_cycles.(thisSide))
% 
%                         plot(cycles_per_trial_synched_normalized(:,iCycle))
%                         hold on
%                     end

                    % mean of all cycles
                    if size(cycles_per_trial,2) == 1
                        parameters.(parameter_name).(thisSide) = cycles_per_trial;
                    else
                        parameters.(parameter_name).(thisSide) = mean(cycles_per_trial, 2, "omitnan");
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
    if settings.is_WCU
        save( fullfile( settings.projectPath,['data',filesep,'processed',filesep,'WCU',filesep],'cycle_parameters.mat'), 'cycle_parameters' )
    else
        save( fullfile( settings.projectPath,['data',filesep,'processed',filesep,'AB',filesep],'cycle_parameters.mat'), 'cycle_parameters' )
    end
end

end