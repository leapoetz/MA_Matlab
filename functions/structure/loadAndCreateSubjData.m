function subjData = loadAndCreateSubjData(settings)
%% create struct with subject et data from each day

cd('data/raw_WCU');
rawDataPath = pwd;
subj = dir(rawDataPath);
names    = {subj.name};
% Get a logical vector that tells which is a directory.
dirFlags = [subj.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
% Extract only those that are directories.
subDirsNames = names(dirFlags);

% iterate thorugh each subj
for iSubj = 1:numel(subDirsNames)
    fprintf(['...load subj...', subDirsNames{iSubj}, '\n'])
    cd(subDirsNames{iSubj});

    files = dir('Vicon/');
    names = {files.name};
    % Get a logical vector that tells which is a directory.
    dirFlags = ~strcmp(names, '.') & ~strcmp(names, '..');
    % Extract only those that are directories.
    subFileNames = names(dirFlags);
    [~, filenames, ~] = fileparts(subFileNames);
    
    for i_filename = 1 : length(filenames)
        filename = filenames{i_filename};
        subject = filename(1:4);
        conditionNr = filename(6); 
        condition = ['condition',num2str(conditionNr)]; 
        trialNr = filename(end-1:end);
        trial = ['trial',num2str(trialNr)]; 
    
        T_marker = readtable([fullfile('Vicon/'),filename,'.csv'], "TreatAsMissing", {''}, VariableNamingRule="preserve" );
        if isempty(T_marker)
            continue
        end
        T_marker.Var1 = [];
        T_marker.Var2 = [];
        T_marker(1,:) = [];
    
        n_markers = 16;
        marker_names = cell(1,n_markers);
        i_marker = 1;
        for i_variable = 1 : size(T_marker,2)
            this_variable_name = cell2mat(T_marker.Properties.VariableNames(i_variable));
            if ~strcmp(this_variable_name(1:3), 'Var')
                marker_names{i_marker} = this_variable_name(8:end);
                i_marker = i_marker + 1;
            end
        end
    
        marker_data = readmatrix([fullfile('Vicon/'),filename,'.csv']);
        marker_data(1:5,:) = [];
        marker_data(:,1:2) = [];
    
        new_data = nan(n_markers, length(marker_data), 3);
        i_marker = 1;
        for i_filename = 1:3:size(marker_data,2)-2
            new_data(i_marker,:,:) = marker_data(:,i_filename:i_filename+2);
            i_marker = i_marker + 1;
        end
        marker_data = permute(new_data, [2,1,3]);
        subjData.(subject).(condition).(trial).kinematic.markerData = marker_data;
        subjData.(subject).(condition).(trial).kinematic.markerNames = marker_names;
    
        % SW data
        data_SW1 = readmatrix([fullfile('SW/'),filename,' SW1.csv']);
        subjData.(subject).(condition).(trial).kinetic.left.force = data_SW1(:,19:21);
        subjData.(subject).(condition).(trial).kinetic.left.torque = data_SW1(:,22:24);
        subjData.(subject).(condition).(trial).kinetic.left.angle_rad = deg2rad(data_SW1(:,4));
        subjData.(subject).(condition).(trial).kinetic.left.speed = data_SW1(:,5);
    
        data_SW2 = readmatrix([fullfile('SW/'),filename,' SW2.csv']);
        subjData.(subject).(condition).(trial).kinetic.right.force = data_SW2(:,19:21);
        subjData.(subject).(condition).(trial).kinetic.right.torque = data_SW2(:,22:24);
        subjData.(subject).(condition).(trial).kinetic.right.angle_rad = deg2rad(data_SW2(:,4));
        subjData.(subject).(condition).(trial).kinetic.right.speed = data_SW2(:,5);
        
    end
    cd(rawDataPath);
    if settings.doSave
        save( 'subjData.mat', "subjData")
    end
%     cd(settings.projectPath);
end

