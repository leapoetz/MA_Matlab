function [data_removed_offset] = removeDynamicOffset(data, coeffs, interval)

% figure()
% plot(data.Angle_left(interval,1))
% hold on 
% % plot(data.F_left(interval,1))
% % plot(polyval(coeffs.F_left(interval,1),data.Angle_left(interval,1)))
% plot(polyval(coeffs.F_left(interval,1),data.Angle_left(interval,1)))

data_removed_offset = data; 

% force left
data_removed_offset.F_left(interval,1) = data.F_left(interval,1) - polyval(coeffs.F_left(interval,1),data.Angle_left(interval,1)); 
data_removed_offset.F_left(interval,2) = data.F_left(interval,2) - polyval(coeffs.F_left(interval,2),data.Angle_left(interval,1)); 
data_removed_offset.F_left(interval,3) = data.F_left(interval,3) - polyval(coeffs.F_left(interval,3),data.Angle_left(interval,1)); 

% moment left
data_removed_offset.M_left(interval,1) = data.M_left(interval,1) - polyval(coeffs.M_left(interval,1),data.Angle_left(interval,1)); 
data_removed_offset.M_left(interval,2) = data.M_left(interval,2) - polyval(coeffs.M_left(interval,2),data.Angle_left(interval,1)); 
data_removed_offset.M_left(interval,3) = data.M_left(interval,3) - polyval(coeffs.M_left(interval,3),data.Angle_left(interval,1)); 

% force right
data_removed_offset.F_right(interval,1) = data.F_right(interval,1) - polyval(coeffs.F_right(interval,1),data.Angle_right(interval,1)); 
data_removed_offset.F_right(interval,2) = data.F_right(interval,2) - polyval(coeffs.F_right(interval,2),data.Angle_right(interval,1)); 
data_removed_offset.F_right(interval,3) = data.F_right(interval,3) - polyval(coeffs.F_right(interval,3),data.Angle_right(interval,1)); 

% moment right
data_removed_offset.M_right(interval,1) = data.M_right(interval,1) - polyval(coeffs.M_right(interval,1),data.Angle_right(interval,1)); 
data_removed_offset.M_right(interval,2) = data.M_right(interval,2) - polyval(coeffs.M_right(interval,2),data.Angle_right(interval,1)); 
data_removed_offset.M_right(interval,3) = data.M_right(interval,3) - polyval(coeffs.M_right(interval,3),data.Angle_right(interval,1)); 

% % speed left
% data_removed_offset.Speed_right(interval,3) = data.Speed_right(interval,3) - polyval(coeffs.M_right(interval,3),data.Angle_right(interval,1)); 
% 
% % speed right
% data_removed_offset.M_right(interval,3) = data.M_right(interval,3) - polyval(coeffs.M_right(interval,3),data.Angle_right(interval,1)); 

end