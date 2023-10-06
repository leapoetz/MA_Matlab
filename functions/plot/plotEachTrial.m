function plotEachTrial(continous_parameters, whichParameter)


%% predefs
subjNames = fieldnames(continous_parameters);
nSubj = numel(subjNames);
% fprintf('...start calculating parameters...\n')

sides = {'left', 'right'};

for iSubj = 2%1:nSubj
    conditions = fieldnames(continous_parameters.(subjNames{iSubj}));
    nCondition = numel(conditions);
    fprintf(['...for ', subjNames{iSubj}, '\n'])

    for iCondition = 1:nCondition
        fprintf(['...for ', conditions{iCondition}, '\n'])

        trials = fieldnames(continous_parameters.(subjNames{iSubj}).(conditions{iCondition}));
        nTrials = numel(trials);

        figure("Name",[whichParameter,' of VP',num2str(iSubj),'_',num2str(iCondition)])


        for iSide = 1 : length(sides)
            thisSide = sides{iSide};

            subplot(1,2,iSide)
            for iTrial = 1:nTrials
                thisData = continous_parameters.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}).(whichParameter).(thisSide);
                plot(thisData)
                hold on
            end
        end
    end
end 
end 


