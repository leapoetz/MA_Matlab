function [PFA_kinematic] = calcKinematicPFA(data, settings)

LWCENTRE = data.LWCENTRE; 
RWCENTRE = data.RWCENTRE;
LFIN2 = data.LFIN2; 
RFIN2 = data.RFIN2; 

% vector_vertical = repmat([0,0,-280], length(LWCENTRE), 1); % vertical x=y=0, z=1
vector_horizontal = repmat([1,0,0], length(LWCENTRE), 1); % horizontal y=z=0, x=1

vector_wheel_axle_PFA_left = LWCENTRE - LFIN2;
vector_wheel_axle_PFA_right = RWCENTRE - RFIN2;

% angle_vertical_left = nan(1,length(LWCENTRE));
% angle_vertical_right = nan(1,length(LWCENTRE));
angle_horizontal_left = nan(1,length(LWCENTRE));
angle_horizontal_right = nan(1,length(LWCENTRE));
for i_dataPoint = 1 : length(LWCENTRE)
    % angle between line, connecting PFA and the wheel axle, and the vertical
%     angle_vertical_left(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_left(i_dataPoint,:), vector_vertical(i_dataPoint,:))...
%         / (norm(vector_wheel_axle_PFA_left(i_dataPoint,:)) .* norm(vector_vertical(i_dataPoint,:))) );
% 
%     angle_vertical_right(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_right(i_dataPoint,:), vector_vertical(i_dataPoint,:))...
%         / (norm(vector_wheel_axle_PFA_right(i_dataPoint,:)) .* norm(vector_vertical(i_dataPoint,:))) );

    % angle between PFA-wheel axle and the horizontal
    angle_horizontal_left(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_left(i_dataPoint,:), vector_horizontal(i_dataPoint,:))...
        / (norm(vector_wheel_axle_PFA_left(i_dataPoint,:)) .* norm(vector_horizontal(i_dataPoint,:))) );

    angle_horizontal_right(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_right(i_dataPoint,:), vector_horizontal(i_dataPoint,:))...
        / (norm(vector_wheel_axle_PFA_right(i_dataPoint,:)) .* norm(vector_horizontal(i_dataPoint,:))) );
end

angle_vertical_right = angle_horizontal_right;
angle_vertical_left = angle_horizontal_left;
% angle_vertical_right = 180 - angle_vertical_right;
% angle_vertical_left = 180 - angle_vertical_left;


% if i_condition < 3
%     PFA_kinematic.left = - angle_vertical_left;
%     PFA_kinematic.right = - angle_vertical_right;
% else
    PFA_kinematic.left = angle_vertical_left;
    PFA_kinematic.right = angle_vertical_right;
% end

if settings.doPlot
    figure("Name",'PFA_kinematic')
    plot(angle_vertical_left)
    hold on
    plot(angle_vertical_right)
    xlabel('Frames')
    ylabel('Angle (°)')
    title('PFA angle to the vertical')
    legend('Left', 'Right')
    xlim([0 2500])

    %     figure("Name",'Angle_Horizontal)
    %     plot( angle_horizontal_left )
    %     hold on
    %     plot(angle_horizontal_right )
    %     xlabel('Frames')
    %     ylabel('Angle (°)')
    %     title('PFA angle to the horizontal')
end


end