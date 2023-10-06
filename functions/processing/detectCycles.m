function [cycles_to_analyze, n_cycles] = detectCycles(data, settings)

data_left = data.M_left(:,3);
data_right = data.M_right(:,3);

% in case M_z is negative 
if mean(data_left) < 0
    data_left = - data_left; 
end 
% in case M_z is negative 
if mean(data_right) < 0
    data_right = - data_right; 
end 

n_frames_final = length(data_left);

% old approach: 
% %% determine resting level
% first_start_force_left = find( abs(diff(data_left)) > settings.threshold_firstStart, 1, "first");
% first_start_force_right = find( abs(diff(data_right)) > settings.threshold_firstStart, 1, "first");
% 
% resting_level_left = mean(data_left(1:first_start_force_left))+5*std(data_left(1:first_start_force_left));
% resting_level_right = mean(data_right(1:first_start_force_right))+5*std(data_right(1:first_start_force_right));

% last_force_left = find( abs(diff(data_left)) > settings.threshold_firstStart, 1, "last");
% last_force_right = find( abs(diff(data_right)) > settings.threshold_firstStart, 1, "last");
% resting_level_left = mean(data_left(last_force_left:length(data_left)))+5*std(data_left(last_force_left:length(data_left)));
% resting_level_right = mean(data_right(last_force_right:length(data_right)))+5*std(data_right(last_force_right:length(data_right)));


% inspired by Annika's algorithm
%% LEFT 

is_phase = true;
i_event = 1;
events_left = {};
for i_frame = 2 : n_frames_final
    if data_left(i_frame-1) <= settings.threshold && data_left(i_frame) >= settings.threshold
%         while data_left(i_frame) > 0
%             i_frame = i_frame - 1;
%         end
        while data_left(i_frame) <= data_left(i_frame+1)
            i_frame = i_frame - 1;
        end
%         while data_left(i_frame) < -0.25
%             i_frame = i_frame - 1;
%         end
        if is_phase %&& ~ismember(num2str(i_frame),events)
            events_left{i_event,1} = i_frame;
            events_left{i_event,2} = 'push';
            is_phase = false;
            i_event = i_event + 1;
        end
    end

    if data_left(i_frame-1) >= settings.threshold && data_left(i_frame) <= settings.threshold
%         while data_left(i_frame) > 0 && i_frame < n_frames_final-1
%             i_frame = i_frame + 1;
%         end
        while data_left(i_frame) <= data_left(i_frame-1) && i_frame < n_frames_final-1
            i_frame = i_frame + 1;
        end
%         while data_left(i_frame) < -0.25 && i_frame < n_frames_final-1
%             i_frame = i_frame + 1;
%         end
        if ~is_phase
            events_left{i_event,1} = i_frame;
            events_left{i_event,2} = 'recovery';
            is_phase = true;
            i_event = i_event + 1;
        end
    end
end

%% RIGHT
is_phase = true;
i_event = 1;
events_right = {};

for i_frame = 2 : n_frames_final

    % find start of push phase 
    if data_right(i_frame-1) <= settings.threshold && data_right(i_frame) >= settings.threshold
%         while data_right(i_frame) > 0 
%             i_frame = i_frame - 1;
%         end
        while data_right(i_frame) <= data_right(i_frame+1)
            i_frame = i_frame - 1;
        end
%         while data_right(i_frame) < -0.25
%             i_frame = i_frame - 1;
%         end
        if is_phase %&& ~ismember(num2str(i_frame),events)
            events_right{i_event,1} = i_frame;
            events_right{i_event,2} = 'push';
            is_phase = false;
            i_event = i_event + 1;
        end
    end

    % find end of push phase => start of recovery phase
    if data_right(i_frame-1) >= settings.threshold && data_right(i_frame) <= settings.threshold
%         while data_right(i_frame) > 0 && i_frame < n_frames_final-1
%             i_frame = i_frame + 1;
%         end
        while data_right(i_frame) <= data_right(i_frame-1) && i_frame < n_frames_final-1
            i_frame = i_frame + 1;
        end
%         while data_right(i_frame) < -0.25 && i_frame < n_frames_final-1
%             i_frame = i_frame + 1;
%         end
        if ~is_phase
            events_right{i_event,1} = i_frame;
            events_right{i_event,2} = 'recovery';
            is_phase = true;
            i_event = i_event + 1;
        end
    end
end

%% Find valid events 

% remove double events 
[~, idx] = unique([events_left{:,1}]);
events_left = events_left(idx,:);
[~, idx] = unique([events_right{:,1}]);
events_right = events_right(idx,:);

% if last cycle not complete, cut off last event
if strcmp(events_left{length(events_left),2},'push')
    events_left = events_left(1:end-1,:);
end
if strcmp(events_right{length(events_right),2},'push')
    events_right = events_right(1:end-1,:);
end


% left and right side has same number of cycles
if length(events_right) > length(events_left)
    while length(events_right) ~= length(events_left)
        events_right = events_right(1:end-1,:); % cut off 
    end
else
    while length(events_right) ~= length(events_left)
        events_left = events_left(1:end-1,:);
    end
end

%% Save only middle intervals 

n_events = length(events_left); 
n_cycles = n_events/2; 

event_numbers = 1 : n_events; 
events_to_analyze = event_numbers(5:n_events); % cut off first two and last two cycles
if length(events_to_analyze) > 6
    events_to_analyze = events_to_analyze(1:length(events_to_analyze)-2); 
end 

% create cycle intervals
i_interval = 1;
cycles_to_analyze_right = cell(length(events_to_analyze)/2,1);
cycles_to_analyze_left = cell(length(events_to_analyze)/2,1);

if ~isempty(events_to_analyze)
    for i_event = events_to_analyze(1) : 2 : events_to_analyze(end)
        cycles_to_analyze_left{i_interval,:} = events_left{i_event,1}:events_left{i_event+1,1};
        cycles_to_analyze_right{i_interval,:} = events_right{i_event,1}:events_right{i_event+1,1};
        i_interval = i_interval + 1;
    end
end

% save in variable 
cycles_to_analyze.right = cycles_to_analyze_right; 
cycles_to_analyze.left = cycles_to_analyze_left; 

%% Plot results

% mean from left and right side
events = events_left;
for i_event = 1 : length(events_left)
    events{i_event,1} = mean([events_left{i_event,1},events_right{i_event,1}]);
end

if settings.doPlot
    figure()
    subplot(2,1,1)
    plot(data_left)
    hold on
    plot(data_right)
    xlabel('Frames')
    ylabel('Moment (Nm)')
    title('M_z')
    for i_event = 1 : length(events)
        xline(events{i_event,1})
    end
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
    legend('Left', 'Right')
end

end