function [cont_parameters, cycles] = calcContinousParameters(data_processed, settings)
% calculate continous parameters
% additinally return cycles for further data analysis

% predefs
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

            data = data_processed.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}); 

            %% calculating continous parameters

            % kinematic PFA (left and right) 
            parameters.PFA_kinematic = calcDynamicKinematicPFA(data,settings); 

%             % force in x-direction
%             parameters.F_x.left = data.F_left(:,1); 
%             parameters.F_x.right = data.F_right(:,1); 

%             % force in y-direction
%             parameters.F_y.left = data.F_left(:,2); 
%             parameters.F_y.right = data.F_right(:,2);

            % total force 
            parameters.F_tot.left = sqrt(data.F_left(:,1).^2 + data.F_left(:,2).^2 + data.F_left(:,3).^2); 
            parameters.F_tot.right = sqrt(data.F_right(:,1).^2 + data.F_right(:,2).^2 + data.F_right(:,3).^2); 

            % estimated tangential force 
            parameters.F_tan_est.left = data.M_left(:,3) / settings.radius; 
            parameters.F_tan_est.right = data.M_right(:,3) / settings.radius; 

            % exact tangential force 
            parameters.F_tan.left = sind(parameters.PFA_kinematic.left)' .* data.F_left(:,1) - cosd(parameters.PFA_kinematic.left)' .* data.F_left(:,2); 
            parameters.F_tan.right = sind(parameters.PFA_kinematic.right)' .* data.F_right(:,1) - cosd(parameters.PFA_kinematic.right)' .* data.F_right(:,2); 

            % estimated power ouput 
            parameters.PO_est.left = parameters.F_tan_est.left .* data.Speed_left'; 
            parameters.PO_est.right = parameters.F_tan_est.right .* data.Speed_right'; 

            % exact power ouput 
            parameters.PO.left = parameters.F_tan.left .* data.Speed_left'; 
            parameters.PO.right = parameters.F_tan.right .* data.Speed_right';             

            % estimated radial force 
            parameters.F_rad_est.left = parameters.F_tot.left - parameters.F_tan_est.left - data.F_left(:,3); 
            parameters.F_rad_est.right = parameters.F_tot.right - parameters.F_tan_est.right - data.F_right(:,3); 

            % exact radial force
            parameters.F_rad.left =  - cosd(parameters.PFA_kinematic.left)' .* data.F_left(:,1) - sind(parameters.PFA_kinematic.left)' .* data.F_left(:,2);
            parameters.F_rad.right = sind(parameters.PFA_kinematic.right)' .* data.F_right(:,1) - cosd(parameters.PFA_kinematic.right)' .* data.F_right(:,2);

            % speed
            parameters.Speed.left = data.Speed_left; 
            parameters.Speed.right = data.Speed_right; 

            % mechanical efficiency
            parameters.Efficiency.left = parameters.F_tan.left ./ parameters.F_tot.left .* 100; 
            parameters.Efficiency.right = parameters.F_tan.right ./ parameters.F_tot.right .* 100;    

            % save for each trial
            cont_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}) = parameters; 

            % create cylce variable
            cycles.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}) = data.cycles;
        end 
    end 
end 
fprintf('...finished calculating continous parameters...\n')

if settings.doSave
    if settings.is_WCU
        save( fullfile( settings.projectPath,['data',filesep,'interim',filesep,'WCU',filesep],'continous_parameters.mat'), 'cont_parameters' )
        save( fullfile( settings.projectPath,['data',filesep,'interim',filesep,'WCU',filesep],'cycles.mat'), 'cycles' )
    else
        save( fullfile( settings.projectPath,['data',filesep,'interim',filesep,'AB',filesep],'continous_parameters.mat'), 'cont_parameters' )
        save( fullfile( settings.projectPath,['data',filesep,'interim',filesep,'AB',filesep],'cycles.mat'), 'cycles' )
    end
end

end