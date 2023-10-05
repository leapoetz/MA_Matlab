function [force_application_intervals] = detectEvents(data, settings)

data_left = settings.dataUsed_forEventDetecting_left;
data_right = settings.dataUsed_forEventDetecting_right; 
n_frames_final = length(data_left); 


%% determine resting level
first_start_force_left = find( abs(diff(data_left)) > settings.threshold_firstStart, 1, "first");
first_start_force_right = find( abs(diff(data_right)) > settings.threshold_firstStart, 1, "first");

resting_level_left = mean(data_left(1:first_start_force_left))+5*std(data_left(1:first_start_force_left));
resting_level_right = mean(data_right(1:first_start_force_right))+5*std(data_right(1:first_start_force_right));

% last_force_left = find( abs(diff(data_left)) > settings.threshold_firstStart, 1, "last");
% last_force_right = find( abs(diff(data_right)) > settings.threshold_firstStart, 1, "last");
% resting_level_left = mean(data_left(last_force_left:length(data_left)))+5*std(data_left(last_force_left:length(data_left)));
% resting_level_right = mean(data_right(last_force_right:length(data_right)))+5*std(data_right(last_force_right:length(data_right)));

% detect events
% try out new algorithm for finding events of force application
%% left side 
is_phase = true;
i_event = 1;
events_left = {};
for i_frame = 2 : n_frames_final
    if data_left(i_frame-1) <= settings.threshold && data_left(i_frame) >= settings.threshold
        while data_left(i_frame) > resting_level_left && i_frame > 1
            i_frame = i_frame - 1;
        end
        while data_left(i_frame) <= data_left(i_frame+1) && i_frame > 1
            i_frame = i_frame - 1;
        end
        while data_left(i_frame) < 0.2
            i_frame = i_frame - 1; 
        end 
        if is_phase %&& ~ismember(num2str(i_frame),events)
            events_left{i_event,1} = i_frame;
            events_left{i_event,2} = 'start';
            is_phase = false;
            i_event = i_event + 1;
        end
    end

    if i_frame == 1 % in case first part is cut off and first interval starts immediately 
        i_frame = 2; 
    end 

    if data_left(i_frame-1) >= settings.threshold && data_left(i_frame) <= settings.threshold
        while data_left(i_frame) > resting_level_left && i_frame < n_frames_final-1
            i_frame = i_frame + 1;
        end
        while data_left(i_frame) >= data_left(i_frame+1) && i_frame < n_frames_final-1
            i_frame = i_frame + 1;
        end
        while data_left(i_frame) < 0.2
            i_frame = i_frame + 1;
        end
        if ~is_phase
            events_left{i_event,1} = i_frame;
            events_left{i_event,2} = 'end';
            %                         start_recovery = [start_recovery, i_frame];
            is_phase = true;
            i_event = i_event + 1;
        end
    end
end

%% right side
is_phase = true;
i_event = 1;
settings.threshold = 10;
events_right = {};
for i_frame = 2 : n_frames_final
    if data_right(i_frame-1) <= settings.threshold && data_right(i_frame) >= settings.threshold
        while data_right(i_frame) > resting_level_right && i_frame > 1
            i_frame = i_frame - 1;
        end
        while data_right(i_frame) <= data_right(i_frame+1) && i_frame > 1
            i_frame = i_frame - 1;
        end
        if is_phase %&& ~ismember(num2str(i_frame),events)
            events_right{i_event,1} = i_frame;
            events_right{i_event,2} = 'start';
            is_phase = false;
            i_event = i_event + 1;
        end
    end

    if i_frame == 1
        i_frame = 2; 
    end 

    if data_right(i_frame-1) >= settings.threshold && data_right(i_frame) <= settings.threshold
        while data_right(i_frame) > resting_level_right && i_frame < n_frames_final-1
            i_frame = i_frame + 1;
        end
        while data_right(i_frame) <= data_right(i_frame+1) && i_frame < n_frames_final-1
            i_frame = i_frame + 1;
        end
        if ~is_phase
            events_right{i_event,1} = i_frame;
            events_right{i_event,2} = 'end';
            %                         start_recovery = [start_recovery, i_frame];
            is_phase = true;
            i_event = i_event + 1;
        end
    end
end

% valid events
[~, idx] = unique([events_left{:,1}]);
events_left = events_left(idx,:);
[~, idx] = unique([events_right{:,1}]);
events_right = events_right(idx,:);

% if no cycle, cut off last event
if strcmp(events_left{length(events_left),2},'start')
    events_left = events_left(1:end-1,:);
end
if strcmp(events_right{length(events_right),2},'start')
    events_right = events_right(1:end-1,:);
end

events.left = events_left; 
events.right = events_right; 


%% find intervals of force application 
i_interval = 1;
force_application_intervals_right = cell(length(events_left)/2,1);
force_application_intervals_left = cell(length(events_left)/2,1);

for i_event = 1 : 2 : length(events_left)-1
    force_application_intervals_left{i_interval,:} = events_left{i_event,1}:events_left{i_event+1,1};
    force_application_intervals_right{i_interval,:} = events_right{i_event,1}:events_right{i_event+1,1};
    i_interval = i_interval + 1;
end

force_application_intervals.right = force_application_intervals_right; 
force_application_intervals.left = force_application_intervals_left; 

% mean from left and right side
events = events_left;
for i_event = 1 : length(events_left)
    events{i_event,1} = mean([events_left{i_event,1},events_right{i_event,1}]);
end

%% plot results 

if settings.doPlot
    figure()
    subplot(2,1,1)
    plot(data_left)
    hold on
    plot(data_right)
    xlabel('Frames')
    ylabel('Force (N)')
    title('Data Used for Detecting Events')
    for i_event = 1 : length(events)
        xline(events{i_event,1})
    end
    xlim([0 2500])
    legend('Left', 'Right')
    subplot(2,1,2);
    plot(data.LFIN2(:,3))
    hold on
    plot(data.RFIN2(:,3))
    xlabel('Frames')
    ylabel('Position (mm)')
    title('2nd MPJ Marker (z coordinate)')
    for i_event = 1 : length(events)
        xline(events{i_event,1})
    end
    xlim([0 2500])
    legend('Left', 'Right')
end



end