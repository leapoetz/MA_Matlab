function cycle_parameters = calcCycleParameters(cont_parameters,settings)

%% predefs
subjNames = fieldnames(data_processed);
nSubj = numel(subjNames);
fprintf('...start calculating parameters...\n')


for iSubj = 1:nSubj
    conditions = fieldnames(data_processed.(subjNames{iSubj}));
    nCondition = numel(conditions);
    fprintf(['...for ', subjNames{iSubj}, '\n'])

    for iCondition = 1:nCondition
        trials = fieldnames(data_processed.(subjNames{iSubj}).(conditions{iCondition})); 
        nTrials = numel(trials); 
        fprintf(['...for ', conditions{iCondition}, '\n'])

        for iTrial = 1:nTrials
            fprintf(['...for ', trials{iTrial}, '\n'])

            cont_parameters = cont_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}); 

            parameter_names = fieldnames(parameter_names); 

            for iParameter = 1 : length(parameter_names)
                parameter_name = parameter_names{iParameter}; 


                % FORCE DISTRIBUTION
                for iCycle = 1 : length(data.cycles.left)
                    thisInterval = data.cycles.left{iCycle};
                    new_interval = 1 : 100;
                    old_interval = 1 : length(thisInterval); 

                    cycles(iCycle,:) = interp1(old_interval, cont_parameters.(parameter_name).left(thisInterval), new_interval, "linear", "extrap"); 
                end 
                parameters.(parameter_name).left = mean(cycles, "omitnan"); 

            end 

            cycle_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}) = parameters; 

        end 






%             SPEED
%             build mean over all cycles 
%             for iCycle = 1 : length(data.cycles.left)
%                 mean_speed_left(iCycle) = mean(data.Speed_left(data.cycles.left{iCycle})); 
%                 max_speed_left(iCycle) = max(data.Speed_left(data.cycles.left{iCycle})); 
%                 mean_speed_right(iCycle) = mean(data.Speed_right(data.cycles.left{iCycle})); 
%                 max_speed_right(iCycle) = max(data.Speed_right(data.cycles.left{iCycle}));                 
%             end 
% 
%             build mean for each trial 
%             mean_speed_left_per_trial(iTrial) = mean(mean_speed_left); 
%             max_speed_left_per_trial(iTrial) = mean(max_speed_left); 
%             mean_speed_right_per_trial(iTrial) = mean(mean_speed_right); 
%             max_speed_right_per_trial(iTrial) = mean(max_speed_right);
%         end
%         build mean for each condition 
%         cont_parameters.mean_speed.left(iSubj,iCondition) = mean(mean_speed_left_per_trial); 
%         cont_parameters.max_speed.left(iSubj,iCondition) = mean(max_speed_left_per_trial); 
%         cont_parameters.mean_speed.right(iSubj,iCondition) = mean(mean_speed_right_per_trial);
%         cont_parameters.max_speed.right(iSubj,iCondition) = mean(max_speed_right_per_trial);
    end 
end

end