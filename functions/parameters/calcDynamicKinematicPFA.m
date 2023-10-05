function [PFA_kinematic] = calcDynamicKinematicPFA(data, settings)

LWCENTRE = data.LWCENTRE; 
RWCENTRE = data.RWCENTRE;
LFIN2 = data.LFIN2; 
RFIN2 = data.RFIN2; 

if LFIN2(1,1) > LFIN2(find(~isnan(LFIN2(:,1)), 1, 'last'),1) % driving agaist the x axis
    is_reverse = true; 
elseif LFIN2(1,1) < LFIN2(find(~isnan(LFIN2(:,1)), 1, 'last'),1) % driving with the x axis
    is_reverse = false; 
end

% define vector between 2nd MPJ and Wheel Centre
vector_wheel_axle_PFA_left = LFIN2 - LWCENTRE;
vector_wheel_axle_PFA_right = RFIN2 - RWCENTRE;

% define vector to the horizontal 
horizontal_point_left = LWCENTRE;
horizontal_point_left(:,1) = LFIN2(:,1); 
horizontal_point_right = RWCENTRE;
horizontal_point_right(:,1) = RFIN2(:,1); 

vector_horizontal_left = horizontal_point_left - LWCENTRE;
vector_horizontal_right = horizontal_point_right - RWCENTRE; 

angle_horizontal_left = nan(1,length(LWCENTRE));
angle_horizontal_right = nan(1,length(LWCENTRE));
for i_dataPoint = 1 : length(LWCENTRE)

    % angle between PFA-wheel axle and the horizontal
    angle_horizontal_left(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_left(i_dataPoint,:), vector_horizontal_left(i_dataPoint,:))...
        / (norm(vector_wheel_axle_PFA_left(i_dataPoint,:)) .* norm(vector_horizontal_left(i_dataPoint,:))) );

    angle_horizontal_right(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_right(i_dataPoint,:), vector_horizontal_right(i_dataPoint,:))...
        / (norm(vector_wheel_axle_PFA_right(i_dataPoint,:)) .* norm(vector_horizontal_right(i_dataPoint,:))) );
end

% angle_vertical_right = 90 - angle_horizontal_right;
% angle_vertical_left = 90 - angle_horizontal_left;

PFA_kinematic.left = angle_horizontal_left;
PFA_kinematic.right = angle_horizontal_right;

if settings.doPlot
    figure("Name",['PFA_kinematic       reverse:',num2str(is_reverse)])
    plot(angle_horizontal_left)
    hold on
    plot(angle_horizontal_right)
    xlabel('Frames')
    ylabel('Angle (°)')
    title('PFA angle to the horizontal')
    legend('Left', 'Right')
    xlim([0 2500])
end

end