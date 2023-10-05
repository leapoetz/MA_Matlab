function  doPolarPlot(T_results, settings)

% plots mean of each condition for kinetic and kinematic method in one
% polar plot
% overall four plots for each condition and left and right side

conditions = {'rear position_{constant}', 'rear position_{short}', ...
    'middle position_{constant}', 'middle position_{short}',...
    'front position_{constant}', 'front position_{short}'};
colors = [0.8500, 0.3250, 0.0980;  [0.8500, 0.3250, 0.0980];  [0, 0.4470, 0.7410]; [0, 0.4470, 0.7410]; [0.4660, 0.6740, 0.1880]; [0.4660, 0.6740, 0.1880]];
radius = settings.height_pushrim;
% angles = [];
figure
for i_condition = 1:length(conditions)

    angle_kinematic_left = T_results.("Mean PFA Kinematic Left"){i_condition};
    angle_kinetic_left = T_results.("Mean PFA Kinetic Left"){i_condition};
    angle_kinematic_right = T_results.("Mean PFA Kinematic Right"){i_condition};
    angle_kinetic_right = T_results.("Mean PFA Kinetic Right"){i_condition};

    if ~mod(i_condition,2)==0 % constant
        subplot_nr = [1,2];
        titles = {'Condition 1x5 - Left', 'Condition 1x5 - Right'};
    else
        subplot_nr = [3,4];
        titles = {'Condition 5x1 - Left', 'Condition 5x1 - Right'};
    end

    subplot(2,2,subplot_nr(1)) % left
    polarplot(deg2rad(angle_kinematic_left),radius,'o',MarkerSize=10, MarkerFaceColor=colors(i_condition,:),Color=colors(i_condition,:))
    hold on
    polarplot(deg2rad(angle_kinetic_left),radius,'square',MarkerSize=10, MarkerFaceColor=colors(i_condition,:),Color=colors(i_condition,:))
    title(titles(1))

    pax = gca;  
    pax.RTick = [];
%     pax.RTickLabel = {'Centre'};
    pax.ThetaTick = [0, 30, 60, 90, 120, 150, 180];
    pax.ThetaTickLabel = {'0°', '30°', '60°', '90°', '120°', '150°', '180°'};
    pax.RLim = [0 radius];
%     legend('Rear Position - Kinematic', 'Rear Position Kinetic', ...
%         'Middle Position - Kinematic', 'Middle Position - Kinetic',...
%         'Front Position - Kinematic', 'Front Position - Kinetic')

    subplot(2,2,subplot_nr(2)) % right
    polarplot(deg2rad(angle_kinematic_right),radius,'o',MarkerSize=10, Color=colors(i_condition,:), MarkerFaceColor=colors(i_condition,:))
    hold on
    polarplot(deg2rad(angle_kinetic_right),radius,'square',MarkerSize=10, MarkerFaceColor=colors(i_condition,:),Color=colors(i_condition,:))
    title(titles(2))

    pax = gca;
    pax.RTick = [];
%     pax.RTickLabel = {'Centre'};
    pax.ThetaTick = [0, 30, 60, 90, 120, 150, 180];
    pax.ThetaTickLabel = {'0°', '30°', '60°', '90°', '120°', '150°', '180°'};
    pax.RLim = [0 radius];

end
lgd = legend('Rear Position - Kinematic', 'Rear Position Kinetic', ...
    'Middle Position - Kinematic', 'Middle Position - Kinetic',...
    'Front Position - Kinematic', 'Front Position - Kinetic');
lgd.Position = [0.87 0.85 0.1 0.1];


%% do it without polar plot

% figure()
% x = mean(LWCENTRE(:,1));
% y = mean(LWCENTRE(:,2));
% r = settings.height_pushrim;
% viscircles([x, y], r, Color=[0.7 0.7 0.7], LineStyle="-")
% axis equal
% plot(x,y,'ok')
%
% hold on
% colors = {'r', 'r', 'b', 'b', 'g', 'g'};
% for i_condition = 1:length(conditions)
%     angle = T_results{i_condition,"Mean PFA Kinematic Left"};
%     if i_condition == 1 || i_condition == 2
%         angle = - angle;
%     end
%     plot(x+r*cosd(angle),y+r*sind(angle), 'o', "Color", colors(i_condition,:), 'MarkerSize', 10)
% end
% legend(conditions, Location='northeastoutside')
% camroll(90)
% set(gca,"XDir","reverse")



end