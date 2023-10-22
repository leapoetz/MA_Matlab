function showRawData(data, figureID)

if (~exist('figureID', 'var'))
    figureID = 'RAW DATA';
end

%% Plot Raw Data

% Plot Forces
figure("Name",figureID)
subplot(4,2,1)
plot(data.F_left(:,1))
hold on
plot(data.F_right(:,1))
title('F_x')
legend('Left', 'Right')
xlabel('Frames')
ylabel('Force (N)')
subplot(4,2,3)
plot(data.F_left(:,2))
hold on
plot(data.F_right(:,2))
title('F_y')
xlabel('Frames')
ylabel('Force (N)')
subplot(4,2,5)
plot(data.F_left(:,3))
hold on
plot(data.F_right(:,3))
title('F_z')
xlabel('Frames')
ylabel('Force (N)')
% kinematic
subplot(4,2,7)
plot(data.LFIN2(:,3))
hold on 
plot(data.RFIN2(:,3))
title('FIN2 (z-coordinate)')
xlabel('Frames')
ylabel('Position (mm)')

% Plot Moments
subplot(4,2,2)
plot(data.M_left(:,1))
hold on
plot(data.M_right(:,1))
title('M_x')
legend('Left', 'Right')
xlabel('Frames')
ylabel('Moment (Nm)')
subplot(4,2,4)
plot(data.M_left(:,2))
hold on
plot(data.M_right(:,2))
title('M_y')
xlabel('Frames')
ylabel('Moment (Nm)')
subplot(4,2,6)
plot(data.M_left(:,3))
hold on
plot(data.M_right(:,3))
xlabel('Frames')
ylabel('Moment (Nm)')
title('M_z')
% kinematic
subplot(4,2,8)
plot(data.LWCENTRE(:,3))
hold on 
plot(data.RWCENTRE(:,3))
title('WCENTRE (z-coordinate)')
xlabel('Frames')
ylabel('Position (mm)')

sgtitle('Raw Data')

end