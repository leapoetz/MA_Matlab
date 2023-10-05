function plotIntervalsPFA(PFA_kinetic, PFA_kinematic, intervals, whichSide)

figure("Name",'Intervals Constant Force Application')
plot(PFA_kinetic.(whichSide))
hold on
plot(PFA_kinematic.(whichSide))
xlabel('Frames')
ylabel('PFA Angle (°)')
for i_interval = 1 : length(intervals.(whichSide))
    xline(intervals.left{i_interval,1}(1),'--')
    xline(intervals.left{i_interval,1}(length(intervals.(whichSide){i_interval,1})),'--')
%     if i_interval == length(intervals.left)
%         l1 = xline(intervals.left{i_interval,1}(length(intervals.left{i_interval,1})),'--');
%     end
end
title('Comparison of the Calculation Methods: Kinetic vs. Kinematic')
legend('Kinetic PFA', 'Kinematic PFA', 'Intervals of Constant Force Application')
ax = gca;
fontsize(ax, 14, 'Points')
end