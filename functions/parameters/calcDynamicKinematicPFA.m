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

% if is_reverse
%     for i_dataPoint = 1 : length(LWCENTRE)
%         if horizontal_point_left(i_dataPoint,1) < LWCENTRE(i_dataPoint,1)
%             vector_horizontal_left(i_dataPoint,:) = horizontal_point_left(i_dataPoint,:) - LWCENTRE(i_dataPoint,:);
%             
%         else
%             vector_horizontal_left(i_dataPoint,:) = LWCENTRE(i_dataPoint,:) - horizontal_point_left(i_dataPoint,:);
%         end
% 
%         if horizontal_point_right(i_dataPoint,1) < RWCENTRE(i_dataPoint,1)
%             vector_horizontal_right(i_dataPoint,:) = horizontal_point_right(i_dataPoint,:) - RWCENTRE(i_dataPoint,:);
%         else
%             vector_horizontal_right(i_dataPoint,:) = RWCENTRE(i_dataPoint,:) - horizontal_point_right(i_dataPoint,:);
%         end
%         
%     end
% else

%     for i_dataPoint = 1 : length(LWCENTRE)
%         if horizontal_point_left(i_dataPoint,1) < LWCENTRE(i_dataPoint,1)
%             vector_horizontal_left(i_dataPoint,:) = LWCENTRE(i_dataPoint,:) - horizontal_point_left(i_dataPoint,:);
%         else
%             vector_horizontal_left(i_dataPoint,:) = horizontal_point_left(i_dataPoint,:) - LWCENTRE(i_dataPoint,:);
%         end
% 
%         if horizontal_point_right(i_dataPoint,1) < RWCENTRE(i_dataPoint,1)
%             vector_horizontal_right(i_dataPoint,:) = RWCENTRE(i_dataPoint,:) - horizontal_point_right(i_dataPoint,:);
%         else
%             vector_horizontal_right(i_dataPoint,:) = horizontal_point_right(i_dataPoint,:) - RWCENTRE(i_dataPoint,:);
%         end
%     end
% end
% vector_horizontal_left = horizontal_point_left - LWCENTRE;
% vector_horizontal_right = horizontal_point_right - RWCENTRE;

if is_reverse
    vector_horizontal_right = repmat([-1,0,0], length(RWCENTRE), 1); % horizontal y=z=0, x=1
    vector_horizontal_left = repmat([-1,0,0], length(LWCENTRE), 1); % horizontal y=z=0, x=1
else 
    vector_horizontal_right = repmat([1,0,0], length(RWCENTRE), 1); % horizontal y=z=0, x=1
    vector_horizontal_left = repmat([1,0,0], length(LWCENTRE), 1); % horizontal y=z=0, x=1
end 

angle_horizontal_left = nan(1,length(LWCENTRE));
angle_horizontal_right = nan(1,length(LWCENTRE));
for i_dataPoint = 1 : length(LWCENTRE)

    % angle between PFA-wheel axle and the horizontal
    %     test(i_dataPoint) = dot(vector_wheel_axle_PFA_left(i_dataPoint,:), vector_horizontal_left(i_dataPoint,:))...
    %         / (norm(vector_wheel_axle_PFA_left(i_dataPoint,:)) .* norm(vector_horizontal_left(i_dataPoint,:)));

    %     test_zaehler(i_dataPoint) = dot(vector_wheel_axle_PFA_left(i_dataPoint,:), vector_horizontal_left(i_dataPoint,:));
    %     test_nenner(i_dataPoint)  = (norm(vector_wheel_axle_PFA_left(i_dataPoint,:)) .* norm(vector_horizontal_left(i_dataPoint,:)));


    angle_horizontal_left(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_left(i_dataPoint,:), vector_horizontal_left(i_dataPoint,:))...
        / (norm(vector_wheel_axle_PFA_left(i_dataPoint,:)) .* norm(vector_horizontal_left(i_dataPoint,:))) );


    %     if angle_horizontal_left(i)

    angle_horizontal_right(i_dataPoint) = acosd( dot(vector_wheel_axle_PFA_right(i_dataPoint,:), vector_horizontal_right(i_dataPoint,:))...
        / (norm(vector_wheel_axle_PFA_right(i_dataPoint,:)) .* norm(vector_horizontal_right(i_dataPoint,:))) );
end

% angle_vertical_right = 90 - angle_horizontal_right;
% angle_vertical_left = 90 - angle_horizontal_left;

% correct false angle data
% right

% locs = [];
% minpeakheight = 89.5;
% for i_dataPoint = 2 : length(LWCENTRE)-1
%     if angle_horizontal_right(i_dataPoint-1) < angle_horizontal_right(i_dataPoint) && angle_horizontal_right(i_dataPoint+1) > angle_horizontal_right(i_dataPoint)
% %         while angle_horizontal_right(i_dataPoint) < angle_horizontal_right(i_dataPoint+1)
% %             i_dataPoint = i_dataPoint+1;
% %         end
%         locs = [locs, i_dataPoint];
%     end
% end
% figure("Name",['PFA_kinematic       reverse:',num2str(is_reverse)])
% plot(angle_horizontal_left)
% hold on
% plot(angle_horizontal_right)
% xlabel('Frames')
% ylabel('Angle (°)')
% title('PFA angle to the horizontal')
% legend('Left', 'Right')
% xlim([0 2500])
% for iloc = 1 : length(locs)
%     if locs(iloc+1) - locs(iloc) < 100 && ~is_error
%         valid_locs = [valid_locs, locs(iloc)];
%         is_error = true;
%     else
%         is_error = false;
%     end
% end

% while mod(length(locs),2)~=0
%     locs = locs(2:end);
% end
% neighbourpeaks = logical([0, diff(locs)<100]);
% for i_peak = 1 : length(neighbourpeaks)
%     if neighbourpeaks(i_peak)
%         neighbourpeaks(i_peak-1) = true;
%     end
% end

% right side
% valid_locs = [];
% [~, locs] = findpeaks(angle_horizontal_right,MinPeakHeight=89);
% valid_locs = locs;
% % neighbourpeaks = diff(locs)<150;
% % for i_peak = 1 : length(neighbourpeaks)
% %     if neighbourpeaks(i_peak)
% %         valid_locs = [valid_locs, locs(i_peak), locs(i_peak+1)];
% %     end
% % end
% for iPeak = 1 : 2 : length(valid_locs)-1
%     angle_horizontal_right(valid_locs(iPeak):valid_locs(iPeak+1)) = 180 - angle_horizontal_right(valid_locs(iPeak):valid_locs(iPeak+1));
% end
%
% % left side
% valid_locs = [];
% [~, locs] = findpeaks(angle_horizontal_left,MinPeakHeight=89);
% valid_locs = locs;
% % neighbourpeaks = diff(locs)<150;
% % for i_peak = 1 : length(neighbourpeaks)
% %     if neighbourpeaks(i_peak)
% %         valid_locs = [valid_locs, locs(i_peak), locs(i_peak+1)];
% %     end
% % end
% for iPeak = 1 : 2 : length(valid_locs)-1
%     angle_horizontal_left(valid_locs(iPeak):valid_locs(iPeak+1)) = 180 - angle_horizontal_left(valid_locs(iPeak):valid_locs(iPeak+1));
% end
% if is_reverse
%     PFA_kinematic.left = 180 - angle_horizontal_left;
%     PFA_kinematic.right = 180 - angle_horizontal_right;
% else
    PFA_kinematic.left = angle_horizontal_left;
    PFA_kinematic.right = angle_horizontal_right;
% end

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