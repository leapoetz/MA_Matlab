function data_filtered_interpolated = interpolateAndFilterData(data)

data_filtered_interpolated = data;

% sampling frequencies
f_SW = 240; % SW
f_marker = 200; % Vicon

%% Comments
% theoretisch sind SW data immer 3000 frames lang
% marker data sind ursprünglich immer länger, habe ich allerdings
% zugeschnitten: vorne und hinten etwas ab

% das heißt meist sind marker data kürzer
% folglich muss ich deren länge duration in sekunden bestimmen und die SW
% data ebenfalls auf diese dauer kürzen

% falls marker data allerdings noch länger sind als sw data
% muss ich aus sw data dauer bestimmen und marker data entsprechend kürzen

% um zu interpolieren müssen beide datensätze über die gleiche zeit gehen

%% Interpolation

% determine duration in seconds of each data set
duration_marker = length(data.LFIN2) /f_marker;
duration_SW = length(data.F_left) / f_SW;

if duration_marker < duration_SW % marker data shorter than SW data

    end_frame_SW = round(duration_marker * f_SW); % calculate index at which SW data has to be cut

    % cut off SW data
    data.F_left = data.F_left(1:end_frame_SW,:);
    data.F_right = data.F_right(1:end_frame_SW,:);
    data.M_left = data.M_left(1:end_frame_SW,:);
    data.M_right = data.M_right(1:end_frame_SW,:);
%     data.Speed_left = data.Speed_left(1:end_frame_SW);
%     data.Speed_right = data.Speed_right(1:end_frame_SW);
    data.Angle_left = data.Angle_left(1:end_frame_SW);
    data.Angle_right = data.Angle_right(1:end_frame_SW);

    t_marker = (1:length(data.LFIN2)) ./ f_marker; % time vector marker data
    t_SW = (1:length(data.F_left)) ./ f_SW; % time vector SW data

elseif duration_SW <= duration_marker % SW data shorter than marker data

    end_frame_marker = round( duration_SW * f_marker); % calculate end frame for marker data

    % cut off marker data
    data_filtered_interpolated.LFIN2 = data.LFIN2(1:end_frame_marker,:);
    data_filtered_interpolated.RFIN2 = data.RFIN2(1:end_frame_marker,:);
    data_filtered_interpolated.LWCENTRE = data.LWCENTRE(1:end_frame_marker,:);
    data_filtered_interpolated.RWCENTRE = data.RWCENTRE(1:end_frame_marker,:);

    t_marker = (1:end_frame_marker) ./ f_marker; % time vector marker data
    t_SW = (1:length(data.F_left)) ./ f_SW; % time vector SW data
end

% Downsample kinetic data from 240 to 200 Hz via interpolation
F_left_interpolated = interp1(t_SW, data.F_left, t_marker);
F_right_interpolated = interp1(t_SW, data.F_right, t_marker);
M_left_interpolated = interp1(t_SW, data.M_left, t_marker);
M_right_interpolated = interp1(t_SW, data.M_right, t_marker);
% data_filtered_interpolated.Speed_left = interp1(t_SW, data.Speed_left, t_marker);
% data_filtered_interpolated.Speed_right = interp1(t_SW, data.Speed_right, t_marker);
data_filtered_interpolated.Angle_left = interp1(t_SW, data.Angle_left, t_marker);
data_filtered_interpolated.Angle_right = interp1(t_SW, data.Angle_right, t_marker);

%% Filtering
% recommended by Cooper et al. (2002)
f_c = 6;
[b, a] = butter(4, f_c/(f_marker/2), "low");
data_filtered_interpolated.F_left = filter(b, a, F_left_interpolated);
data_filtered_interpolated.F_right = filter(b, a, F_right_interpolated);
data_filtered_interpolated.M_left = filter(b, a, M_left_interpolated);
data_filtered_interpolated.M_right = filter(b, a, M_right_interpolated);

end