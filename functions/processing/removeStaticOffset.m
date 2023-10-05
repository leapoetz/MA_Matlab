function [data_removed_offset] = removeStaticOffset(data, settings, interval_static)

data_removed_offset = data; 

indices_recovery_left = findRecovery(data.F_left(interval_static,1), settings);
indices_pulse_left = ~indices_recovery_left; 

indices_recovery_right = findRecovery(data.F_right(interval_static,1), settings);
indices_pulse_right = ~indices_recovery_right; 

% figure
% plot(data.F_left(:,1))
% hold on
% plot(indices_recovery_left)

for iComponent = 1 : 3

    data_removed_offset.F_left(indices_pulse_left,iComponent) = data.F_left(indices_pulse_left,iComponent);
    data_removed_offset.F_left(indices_recovery_left,iComponent) = 0;

    data_removed_offset.M_left(indices_pulse_left,iComponent) = data.M_left(indices_pulse_left,iComponent);
    data_removed_offset.M_left(indices_recovery_left,iComponent) = 0;

    data_removed_offset.F_right(indices_pulse_right,iComponent) = data.F_right(indices_pulse_right,iComponent); 
    data_removed_offset.F_right(indices_recovery_right,iComponent) = 0;

    data_removed_offset.M_right(indices_pulse_right,iComponent) = data.M_right(indices_pulse_right,iComponent); 
    data_removed_offset.M_right(indices_recovery_right,iComponent) = 0;
end



%% with baseline measurement

% figure()
% plot(data.Angle_left(interval,1))
% hold on 
% % plot(data.F_left(interval,1))
% % plot(polyval(coeffs.F_left(interval,1),data.Angle_left(interval,1)))
% plot(polyval(coeffs.F_left(interval,1),data.Angle_left(interval,1)))

% % force left
% data_removed_offset.F_left(interval,1) = data.F_left(interval,1) - polyval(coeffs.F_left(:,1),data.Angle_left(interval)); 
% data_removed_offset.F_left(interval,2) = data.F_left(interval,2) - polyval(coeffs.F_left(:,2),data.Angle_left(interval)); 
% data_removed_offset.F_left(interval,3) = data.F_left(interval,3) - polyval(coeffs.F_left(:,3),data.Angle_left(interval)); 
% 
% % moment left
% data_removed_offset.M_left(interval,1) = data.M_left(interval,1) - polyval(coeffs.M_left(:,1),data.Angle_left(interval)); 
% data_removed_offset.M_left(interval,2) = data.M_left(interval,2) - polyval(coeffs.M_left(:,2),data.Angle_left(interval)); 
% data_removed_offset.M_left(interval,3) = data.M_left(interval,3) - polyval(coeffs.M_left(:,3),data.Angle_left(interval)); 
% 
% % force right
% data_removed_offset.F_right(interval,1) = data.F_right(interval,1) - polyval(coeffs.F_right(:,1),data.Angle_right(interval)); 
% data_removed_offset.F_right(interval,2) = data.F_right(interval,2) - polyval(coeffs.F_right(:,2),data.Angle_right(interval)); 
% data_removed_offset.F_right(interval,3) = data.F_right(interval,3) - polyval(coeffs.F_right(:,3),data.Angle_right(interval)); 
% 
% % moment right
% data_removed_offset.M_right(interval,1) = data.M_right(interval,1) - polyval(coeffs.M_right(:,1),data.Angle_right(interval)); 
% data_removed_offset.M_right(interval,2) = data.M_right(interval,2) - polyval(coeffs.M_right(:,2),data.Angle_right(interval)); 
% data_removed_offset.M_right(interval,3) = data.M_right(interval,3) - polyval(coeffs.M_right(:,3),data.Angle_right(interval)); 

end