function plotControlCycles(cont_parameters, cycles, settings)%% predefs

close all

subjNames = fieldnames(cont_parameters);
nSubj = numel(subjNames);
fprintf('...start plotting to check cycles...\n')

sides = {'left', 'right'};


for iSubj = 2:nSubj
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

            for iParameter = 1% 1: length(parameter_names)
                parameter_name = parameter_names{iParameter};

                for iSide = 1 %: length(sides)
                    thisSide = sides{iSide};

                    figure("Name",['Subj',num2str(iSide),' Condition',num2str(iCondition),' Trial',num2str(iTrial),' ',num2str(thisSide)])
                    plot(this_cont_parameters.(parameter_name).(thisSide))
                    hold on

                    % FORCE DISTRIBUTION
                    for iCycle = 1 : length(this_cycles.(thisSide))
                        thisInterval = this_cycles.(thisSide){iCycle};

                        xline(thisInterval(1))
                        xline(thisInterval(end))
                    end
                    ylabel(num2str(parameter_name))
                    xlabel('Frames')

                end
            end
        end 
    end 
end