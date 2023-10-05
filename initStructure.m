function initStructure(projectPath)
%% create folder dependencies

% Get a list of all files and folders in this folder.
files    = dir(projectPath);
names    = {files.name};
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
% Extract only those that are directories.
subDirsNames = names(dirFlags);

% add subfolders to working path
for i = 1:numel(subDirsNames)
    fprintf(['...adding subfolder...', subDirsNames{i}, '\n'])
    cd(subDirsNames{i});
    addpath(genpath(pwd));
    cd(projectPath);
end

fprintf('...finished...go ahead...\n');
end