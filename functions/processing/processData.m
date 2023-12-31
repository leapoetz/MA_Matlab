function data_processed = processData(subjData,settings)

% predefs
subjNames = fieldnames(subjData);
nSubj = numel(subjNames);
fprintf('...start processing data...\n')

for iSubj = 1:nSubj
    conditions = fieldnames(subjData.(subjNames{iSubj}));
    nCondition = numel(conditions);
    fprintf(['...for ', subjNames{iSubj}, '\n'])

    for iCondition = 1:nCondition
        trials = fieldnames(subjData.(subjNames{iSubj}).(conditions{iCondition})); 
        nTrials = numel(trials); 
        fprintf(['...for ', conditions{iCondition}, '\n'])

        for iTrial = 1:nTrials
            fprintf(['...for ', trials{iTrial}, '\n'])

            % name to display for figures
            figureID = [subjNames{iSubj},'_',num2str(iCondition),'_',num2str(iTrial)]; 

            % extract data
            data = extractData(subjData.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}));

            % make all data positive
            data = cutAndAdjustData(data); 
            
%             showRawData(data, [figureID,'   Raw Data'])

            % remove offset -> does not work yet 
            data = removeOffset(data, settings, (subjNames{iSubj}));

            % showRawData(data, [figureID,'... removed Offset'])

            % interpolate and filter data
            data = interpolateAndFilterData(data);

            if settings.is_WCU
                data = synchData_WCU(data, settings);
                [cyles_to_analyze, n_cycles] = detectCycles_WCU(data, settings);
            else
                % synchronize data
                data = synchData(data, settings);
                % detect cycles
                [cyles_to_analyze, n_cycles] = detectCycles(data, settings);
            end
            %             showRawData(data, [figureID,'...Synched'])           
            % add cycle parameter to data
            data.cycles = cyles_to_analyze;
            data.nCycles = n_cycles;

            % save data for eacht trial
            data_processed.(subjNames{iSubj}).(conditions{iCondition}).(trials{iTrial}) = data;
        end
        
    end
    fprintf(['...finished data processing for ', subjNames{iSubj}, '\n']);
end

if settings.doSave
    if settings.is_WCU
        save( fullfile( settings.projectPath,['data',filesep,'interim',filesep,'WCU',filesep],'data_processed.mat'), 'data_processed' )
    else
        save( fullfile( settings.projectPath,['data',filesep,'interim',filesep,'AB',filesep],'data_processed.mat'), 'data_processed' )
    end
end



end