function [data_removed_offset] = removeOffset(data, settings, VPNr)

data_removed_offset = data; 
baseline_exists = false; 
n_frames = length(data.M_left); 

% -----> split data in static and dynamic phase: 

%% STATIC

idx_start_right = 2; 
idx_start_left = 2; 

% find time of point when subject starts driving 
for i_frame = 2 : n_frames-1
    if data.Speed_left(i_frame-1) <= 0.3 && data.Speed_left(i_frame) >= 0.3
        while data.Speed_left(i_frame) <= data.Speed_left(i_frame+1) && i_frame < n_frames-1
            i_frame = i_frame - 1;
        end
        idx_start_left = i_frame; 
        break;
    end 
end 
for i_frame = 2 : n_frames-1
    if data.Speed_right(i_frame-1) <= 0.3 && data.Speed_right(i_frame) >= 0.3
        while data.Speed_right(i_frame) <= data.Speed_right(i_frame+1) && i_frame < n_frames-1
            i_frame = i_frame - 1;
        end
        idx_start_right = i_frame; 
        break;
    end 
end 

idx_start_dynamic = round(min([idx_start_right-1, idx_start_left-1])); 
interval_static = 1:idx_start_dynamic-1; 

%approach: differentiate between groups in handling the static phase 
if strcmp(VPNr,'VP10') || strcmp(VPNr,'VP11')
%     load("data\interim\Coefficients_Remove_Offset.mat")
    data_removed_offset = correctSWData(data, interval_static); %removeStaticOffset(data, settings, interval_static); 
else
    data_removed_offset = data; 
end 

%% DYNAMIC
interval_dynamic = idx_start_dynamic:n_frames; 

% figure 
% yyaxis left
% plot(data.F_left(:,1),'b')
% hold on 
% yyaxis right
% plot(data.Speed_left,'r')
% xline(idx_start_dynamic,'k',LineWidth=1.5)

%% left side 

% do regression
if baseline_exists
    % use data from baseline measurement
    load("data\interim\Data_Offset.mat")
    F_left_offset = data_offset.F_left;
    M_left_offset = data_offset.M_left;
    Angle_left_offset = data_offset.Angle_left;
else
    % find indices of recovery phase
    indices_recovery_left = findRecovery(data.M_left(interval_dynamic,3), settings);
    indices_recovery_left = logical([zeros(length(interval_static),1); indices_recovery_left]); 

    % extract data with no force to calculate the offset 
    F_left_offset = data.F_left(indices_recovery_left,:);
    M_left_offset = data.M_left(indices_recovery_left,:);
    Angle_left_offset = data.Angle_left(indices_recovery_left);
end

% figure
% plot(indices_recovery_left)
% hold on 
% plot(data.M_left(:,3))

f_offset = [F_left_offset, M_left_offset];
Q = [sin(Angle_left_offset), cos(Angle_left_offset), ones(length(Angle_left_offset), 1)];
tolerance = eps * max(size(f_offset)); 
for ctr = 1 : size(f_offset, 2)
    A(:,ctr) = lsqr(Q, f_offset(:,ctr), tolerance);
end

f = [data.F_left(interval_dynamic,:), data.M_left(interval_dynamic,:)];
q = [sin(data.Angle_left(interval_dynamic)), cos(data.Angle_left(interval_dynamic)), ones(length(data.Angle_left(interval_dynamic)), 1)];
f = f - q * A; 

% test = q * A; 
% figure
% for iCol = 1 : width(test)
%     plot(test(:,iCol))
%     hold on
% end 

data_removed_offset.F_left(interval_dynamic,:) = f(:,1:3);
data_removed_offset.M_left(interval_dynamic,:) = f(:,4:6);

% figure()
% plot(data.F_left(:,1))
% hold on
% plot(F_left_offset(:,1))
% plot(data_removed_offset.F_left(:,1),'--')
% legend('vorher','offset','nachher')

A = []; 

%% right side 

% do regression
if baseline_exists
    load("data\interim\Data_Offset.mat")
    F_right_offset = data_offset.F_right;
    M_right_offset = data_offset.M_right;
    Angle_right_offset = data_offset.Angle_right;
else
    % find indices of recovery phase
    indices_recovery_right = findRecovery(data.M_right(interval_dynamic,3), settings);
    indices_recovery_right = logical([zeros(length(interval_static),1); indices_recovery_right]); 

    % extract data with no force to calculate the offset 
    F_right_offset = data.F_right(indices_recovery_right,:);
    M_right_offset = data.M_right(indices_recovery_right,:);
    Angle_right_offset = data.Angle_right(indices_recovery_right);
end

% figure
% plot(indices_recovery_right)
% hold on 
% plot(data.M_right(:,3))

f_offset = [F_right_offset, M_right_offset];
Q = [sin(Angle_right_offset), cos(Angle_right_offset), ones(length(Angle_right_offset), 1)];
tolerance = eps * max(size(f_offset)); 
for ctr = 1 : size(f_offset, 2)
    A(:,ctr) = lsqr(Q, f_offset(:,ctr), tolerance);
end

f = [data.F_right(interval_dynamic,:), data.M_right(interval_dynamic,:)];
q = [sin(data.Angle_right(interval_dynamic)), cos(data.Angle_right(interval_dynamic)), ones(length(data.Angle_right(interval_dynamic)), 1)];

f = f - q * A; 

% test = q * A; 
% figure
% for iCol = 1 : width(test)
%     plot(test(:,iCol))
%     hold on
% end 

data_removed_offset.F_right(interval_dynamic,:) = f(:,1:3);
data_removed_offset.M_right(interval_dynamic,:) = f(:,4:6);

%% add start dynamic parameter for later use
data_removed_offset.start_dynamic = idx_start_dynamic; 


end