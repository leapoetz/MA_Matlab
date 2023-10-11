function settings = chooseSettings(projectPath)
%% choose folder
settings.projectPath = projectPath;

%% do stuff
settings.doSave = 1;
settings.doPlot = 0;

%% hardware stuff
settings.windowSize = [1280 720];

%% criteria stuff
settings.threshold = 5; % N
settings.height_pushrim = 290; % mm
settings.offset_threshold = 2.2; % Nm 2.24
settings.threshold_firstStart = 0.03;
settings.threshold_synch = 15;

%% constants
settings.radius = 0.257; %mm


end