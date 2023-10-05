function PFA_kinetic = calcKineticPFA(data, settings, i_condition)

PFA_kinetic_left = atand( abs(data.M_left(:,1)) ./ abs(data.M_left(:,2)));
PFA_kinetic_right = atand( abs(data.M_right(:,1)) ./ abs(data.M_right(:,2)));
% PFA_kinetic_left = atand( data.M_left(:,1) ./ data.M_left(:,2));
% PFA_kinetic_right = atand( data.M_right(:,1) ./ data.M_right(:,2));

if i_condition < 3 % negative angle for rear position 
    PFA_kinetic.left = 180 -  PFA_kinetic_left;
    PFA_kinetic.right = 180 - PFA_kinetic_right;
else
    PFA_kinetic.left = PFA_kinetic_left;
    PFA_kinetic.right = PFA_kinetic_right;
end

if settings.doPlot
    figure("Name", 'PFA_kinetic')
    subplot(3,1,1)
    plot(data.M_left(:,1))
    hold on
    plot(data.M_right(:,1))
    legend('Left', 'Right')
    title('M_x')
    xlabel('Frames')
    ylabel('Force (N)')
    xlim([0 2500])
    subplot(3,1,2)
    plot(data.M_left(:,2))
    hold on
    plot(data.M_right(:,2))
    title('M_y')
    xlabel('Frames')
    ylabel('Force (N)')
    xlim([0 2500])
    subplot(3,1,3)
    plot(PFA_kinetic_left)
    hold on
    plot(PFA_kinetic_right)
    title('PFA Angle')
    xlabel('Frames')
    ylabel('Angle (°)')
    xlim([0 2500])
end


end