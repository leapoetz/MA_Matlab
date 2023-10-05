function data_synched = synchData(data, settings)

data_synched = data; 

% which data to use for synchronisation
dataUsed_left = data.F_left(:,2); 
dataUsed_right = data.F_right(:,2); 

% change signs in case of negative data
if mean(dataUsed_right, 'omitnan')<0
    dataUsed_right = -dataUsed_right; 
end 
if mean(dataUsed_left, 'omitnan')<0
    dataUsed_left = -dataUsed_left; 
end

n_frames = length(dataUsed_left); 

%% case 1: synch pulse was not performed correctly -> hands are already on the push rim when measurement was started

if data.LFIN2(1,3) < 700 && data.RFIN2(1,3) < 700 % if hand is already on push rim 

    % search for last contact to push rim 
    start_kinematic_left = find(data.LFIN2(:,3) > (data.LWCENTRE(:,3)+settings.height_pushrim), 1, "first");
    start_kinematic_right = find(data.RFIN2(:,3) > (data.RWCENTRE(:,3)+settings.height_pushrim), 1, "first");

    % find last index with force application 
    % tried several approaches: inspired by Annika's algorithm

    % LEFT 
    for i_frame = 2 : n_frames-1
        if dataUsed_left(i_frame-1) >= settings.threshold_synch && dataUsed_left(i_frame) <= settings.threshold_synch
%             while dataUsed_left(i_frame) >= dataUsed_left(i_frame+1) && i_frame < n_frames-1
%                 i_frame = i_frame + 1;
%             end

            % find point of time when force changes first time
            while abs(diff([dataUsed_left(i_frame), dataUsed_left(i_frame+1)])) > 0.5 && i_frame < n_frames-1
                i_frame = i_frame + 1;
            end 

%             while dataUsed_left(i_frame) < -0.25 && i_frame < n_frames_final-1
%                 i_frame = i_frame + 1;
%             end
            start_kinetic_left = i_frame; % if first start was found, exit loop 
            break; 
        end
    end

    % RIGHT
    for i_frame = 2 : n_frames-1
        if dataUsed_right(i_frame-1) >= settings.threshold_synch && dataUsed_right(i_frame) <= settings.threshold_synch
%             while dataUsed_right(i_frame) >= dataUsed_right(i_frame+1) && i_frame < n_frames-1
%                 i_frame = i_frame + 1;
%             end
            while abs(diff([dataUsed_left(i_frame), dataUsed_left(i_frame+1)])) > 0.5 && i_frame < n_frames-1
                i_frame = i_frame + 1;
            end
%             while dataUsed_right(i_frame) < -0.25 && i_frame < n_frames_final-1
%                 i_frame = i_frame + 1;
%             end
            start_kinetic_right = i_frame; 
            break; 
        end
    end

%% case 2: normal synch pulse with hands starting in the air 

else % normal synch pulse

    % searching for point when MPJ2 touches push rim first time -> estimating push rim with wheel axle
    start_kinematic_left = find(data.LFIN2(:,3) < (data.LWCENTRE(:,3)+settings.height_pushrim), 1, "first");
    start_kinematic_right = find(data.RFIN2(:,3) < (data.RWCENTRE(:,3)+settings.height_pushrim), 1, "first");

    % LEFT
    for i_frame = 2 : n_frames-1
        if dataUsed_left(i_frame-1) <= settings.threshold_synch && dataUsed_left(i_frame) >= settings.threshold_synch
            %         while dataUsed_left(i_frame) > resting_level_left
            %             i_frame = i_frame - 1;
            %         end
            %             while dataUsed_left(i_frame) <= dataUsed_left(i_frame+1) && i_frame > 1
            %                 i_frame = i_frame - 1;
            %             end
            while abs(diff([dataUsed_left(i_frame), dataUsed_left(i_frame+1)])) > 0.5 
                i_frame = i_frame - 1;
            end
            start_kinetic_left = i_frame;
            break;
        end
    end

    % RIGHT
    for i_frame = 2 : n_frames-1
        if dataUsed_right(i_frame-1) <= settings.threshold_synch && dataUsed_right(i_frame) >= settings.threshold_synch
            %         while dataUsed_right(i_frame) > resting_level_right && i_frame < n_frames_final
            %             i_frame = i_frame - 1;
            %         end
            %             while dataUsed_right(i_frame) <= dataUsed_right(i_frame+1) && i_frame > 1
            %                 i_frame = i_frame - 1;
            %             end
            while abs(diff([dataUsed_left(i_frame), dataUsed_left(i_frame+1)])) > 0.5
                i_frame = i_frame - 1;
            end
            start_kinetic_right = i_frame;
            break;
        end
    end

end 


%% calculating the temporal difference

% kinematic
if abs(start_kinematic_right-start_kinematic_left) > 20 % in case one of both was detected incorrectly 
    start_kinematic = round(min([start_kinematic_right, start_kinematic_left]));
else
    start_kinematic = round(mean([start_kinematic_right, start_kinematic_left]));
end

% kinetic 
if abs(start_kinetic_right-start_kinetic_left) > 20 % one of both is wrong 
    start_kinetic = round(min([start_kinetic_left, start_kinetic_right]));
else
    start_kinetic = round(mean([start_kinetic_left, start_kinetic_right]));
end

temporal_diff = round(start_kinetic - start_kinematic);

% if start_kinetic < 10 || start_kinematic < 10
%     start_kinematic_left = find(data.LFIN2(:,3) > (data.LWCENTRE(:,3)+settings.height_pushrim), 1, "first");
%     start_kinematic_right = find(data.RFIN2(:,3) > (data.RWCENTRE(:,3)+settings.height_pushrim), 1, "first");
% 
%     for i_frame = 2 : n_frames_final-1
%         if dataUsed_left(i_frame-1) >= settings.threshold_synch && dataUsed_left(i_frame) <= settings.threshold_synch
%             while dataUsed_left(i_frame) >= dataUsed_left(i_frame+1) && i_frame < n_frames_final-1
%                 i_frame = i_frame + 1;
%             end
%             while dataUsed_left(i_frame) < -0.25 && i_frame < n_frames_final-1
%                 i_frame = i_frame + 1;
%             end
%             start_kinetic_left = i_frame; 
%             break; 
%         end
%     end
%     for i_frame = 2 : n_frames_final-1
%         if dataUsed_right(i_frame-1) >= settings.threshold_synch && dataUsed_right(i_frame) <= settings.threshold_synch
%             while dataUsed_right(i_frame) >= dataUsed_right(i_frame+1) && i_frame < n_frames_final-1
%                 i_frame = i_frame + 1;
%             end
%             while dataUsed_right(i_frame) < -0.25 && i_frame < n_frames_final-1
%                 i_frame = i_frame + 1;
%             end
%             start_kinetic_right = i_frame; 
%             break; 
%         end
%     end
% 
%     % calculating the temporal difference
%     start_kinematic = round(mean([start_kinematic_right, start_kinematic_left]));
%     start_kinetic = round(mean([start_kinetic_left, start_kinetic_right]));
% end 


%% Shifting data by the temporal difference 

if temporal_diff > 0
    % cut off first frames of kinetic data
    data_synched.F_left = data.F_left(temporal_diff:end,:);
    data_synched.F_right= data.F_right(temporal_diff:end,:);
    data_synched.M_left = data.M_left(temporal_diff:end,:);
    data_synched.M_right = data.M_right(temporal_diff:end,:);
    data_synched.Angle_left = data.Angle_left(temporal_diff:end);
    data_synched.Angle_right = data.Angle_right(temporal_diff:end);    
    data_synched.Speed_left = data.Speed_left(temporal_diff:end);
    data_synched.Speed_right = data.Speed_right(temporal_diff:end);

    % cutting kinematic data accordingly
    n_frames_synched = length(data_synched.F_left);
    if n_frames_synched < length(data.LFIN2)
        data_synched.LFIN2 = data.LFIN2(1:n_frames_synched,:);
        data_synched.RFIN2 = data.RFIN2(1:n_frames_synched,:);
        data_synched.LWCENTRE = data.LWCENTRE(1:n_frames_synched,:);
        data_synched.RWCENTRE = data.RWCENTRE(1:n_frames_synched,:);
    end

elseif temporal_diff < 0
    % cut off first frames of kinematic data
    data_synched.LFIN2 = data.LFIN2(abs(temporal_diff):end,:);
    data_synched.RFIN2 = data.RFIN2(abs(temporal_diff):end,:);
    data_synched.LWCENTRE = data.LWCENTRE(abs(temporal_diff):end,:);
    data_synched.RWCENTRE = data.RWCENTRE(abs(temporal_diff):end,:);

    % cutting kinetic data accordingly
    n_frames_synched = length(data_synched.LFIN2);
    if n_frames_synched < length(data.F_left)
        data_synched.F_left = data.F_left(1:n_frames_synched,:);
        data_synched.F_right= data.F_right(1:n_frames_synched,:);
        data_synched.M_left = data.M_left(1:n_frames_synched,:);
        data_synched.M_right = data.M_right(1:n_frames_synched,:);
        data_synched.Angle_left = data.Angle_left(1:n_frames_synched);
        data_synched.Angle_right = data.Angle_right(1:n_frames_synched);
        data_synched.Speed_left = data.Speed_left(1:n_frames_synched);
        data_synched.Speed_right = data.Speed_right(1:n_frames_synched);
    end
end


%% Plot Data

if settings.doPlot
    figure('Name', 'Synchronisation')
    subplot(3,1,1)
    plot(dataUsed_left)
    hold on
    plot(dataUsed_right)
    xline(start_kinetic_right, 'r')
    xline(start_kinetic_left, 'b')
    xlabel('Frames')
    ylabel('Force (N)')
    title('Force')
    legend('Left', 'Right')
    xlim([0 2500])

    subplot(3,1,2);
    plot(data.LFIN2(:,3))
    hold on
    plot(data.RFIN2(:,3))
    xline(start_kinematic_right, 'r')
    xline(start_kinematic_left, 'b')
    xlabel('Frames')
    ylabel('Position (mm)')
    title('2nd MPJ Marker (z coordinate)')
    legend('Left', 'Right')
    xlim([0 2500])

    subplot(3,1,3)
    yyaxis left
    plot(-data_synched.F_left(:,2))
    hold on
    plot(-data_synched.F_right(:,2),'--')
    ylabel('Force (N)')

    yyaxis right
    plot(data_synched.LFIN2(:,3))
    plot(data_synched.RFIN2(:,3),'--')    
    xlabel('Frames')
    ylabel('Position (mm)')

    xline(start_kinetic-temporal_diff, '-')
    xline(start_kinematic, '--')
    title('Synchronised')
    legend('Left', 'Right')
    xlim([0 2500])
end
end