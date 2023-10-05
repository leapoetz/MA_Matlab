function  doPolarPlot_eachTrial(T_results, settings)


% conditions = {'rear position_{constant}', 'rear position_{short}', ...
%     'middle position_{constant}', 'middle position_{short}',...
%     'front position_{constant}', 'front position_{short}'};
colors = [0.8500, 0.3250, 0.0980;  [0.8500, 0.3250, 0.0980];  [0, 0.4470, 0.7410]; [0, 0.4470, 0.7410]; [0.4660, 0.6740, 0.1880]; [0.4660, 0.6740, 0.1880]];

conditions = unique(T_results.Condition);
radius = settings.height_pushrim;

% figure(1)
% figure(2)
i_color = 1;
lgd1 = []; 
lgd2 = []; 
for i_row = 1 : length(T_results.Condition)
    thisCondition = T_results.Condition{i_row};
    thisTrial = T_results.Trial(i_row);
    if thisTrial == 1
        thisColor = colors(i_color,:);
        i_color = i_color + 1;
    end

    if strcmp(thisCondition(end-7:end), 'konstant')

        figure(1)
        sgtitle('5 seconds constant force')
        subplot(1,2,1)
        angle_kinematic = T_results.("Mean PFA Kinematic Left"){i_row};
        angle_kinetic = T_results.("Mean PFA Kinetic Left"){i_row};

        l1 = polarplot(deg2rad(angle_kinematic),radius,'o',MarkerSize=10, MarkerFaceColor=thisColor, Color=thisColor );
        hold on
        l2 = polarplot(deg2rad(angle_kinetic),radius,'square',MarkerSize=10, MarkerFaceColor=thisColor, Color=thisColor );
        if thisTrial == 1
            lgd1 = [lgd1, [l1 l2]]; 
        end
        pax = gca;
        pax.ThetaZeroLocation = 'top';
        pax.ThetaDir = 'clockwise';
        pax.RTick = 0;
        pax.RTickLabel = {'Centre'};
        pax.ThetaTick = [0, 30, 330];
        pax.ThetaTickLabel = {'0°', '30°', '-30°'};
        pax.RLim = [0 radius];
        title('Left')


        subplot(1,2,2)
        angle_kinematic = T_results.("Mean PFA Kinematic Right"){i_row};
        angle_kinetic = T_results.("Mean PFA Kinetic Right"){i_row};

        polarplot(deg2rad(angle_kinematic),radius,'o',MarkerSize=10, MarkerFaceColor=thisColor , Color=thisColor ) 
        hold on
        polarplot(deg2rad(angle_kinetic),radius,'square',MarkerSize=10, MarkerFaceColor=thisColor , Color=thisColor )
        pax = gca;
        pax.ThetaZeroLocation = 'top';
        pax.ThetaDir = 'clockwise';
        pax.RTick = 0;
        pax.RTickLabel = {'Centre'};
        pax.ThetaTick = [0, 30, 330];
        pax.ThetaTickLabel = {'0°', '30°', '-30°'};
        pax.RLim = [0 radius];
        title('Right')

%         % Create a tile on the right column to get its position
%         ax = subplot(1,3,3,'Visible','off');
%         axPos = ax.Position;
%         delete(ax)
        % Construct a Legend with the data from the sub-plots
        hL = legend(lgd1, 'Rear Position - Kinematic', 'Rear Position - Kinetic', ...
            'Middle Position - Kinematic', 'Middle Position - Kinetic',...
            'Front Position - Kinematic', 'Front Position - Kinetic');
        % Move the legend to the position of the extra axes
        hL.Position = [0.87 0.85 0.1 0.1];
        

    else

        figure(2)
        sgtitle('5 x 1 second constant force')

        for i_interval = length(angle_kinetic)

            subplot(1,2,1)
            angle_kinematic = T_results.("Mean PFA Kinematic Left"){i_row};
            angle_kinetic = T_results.("Mean PFA Kinetic Left"){i_row};

            l1 = polarplot(deg2rad(angle_kinematic(i_interval)),radius,'o',MarkerSize=10, MarkerFaceColor=thisColor ,Color=thisColor ); 
            hold on
            l2 = polarplot(deg2rad(angle_kinetic(i_interval)),radius,'square',MarkerSize=10, MarkerFaceColor=thisColor , Color=thisColor ); 
            if thisTrial == 1
                lgd2 = [lgd2, [l1 l2]];
            end
            pax = gca;
            pax.ThetaZeroLocation = 'top';
            pax.ThetaDir = 'clockwise';
            pax.RTick = 0;
            pax.RTickLabel = {'Centre'};
            pax.ThetaTick = [0, 30, 330];
            pax.ThetaTickLabel = {'0°', '30°', '-30°'};
            pax.RLim = [0 radius];
            title('Left')

            subplot(1,2,2)
            angle_kinematic = T_results.("Mean PFA Kinematic Right"){i_row};
            angle_kinetic = T_results.("Mean PFA Kinetic Right"){i_row};

            polarplot(deg2rad(angle_kinematic(i_interval)),radius,'o',MarkerSize=10, MarkerFaceColor=thisColor , Color=thisColor )
            hold on
            polarplot(deg2rad(angle_kinetic(i_interval)),radius,'square',MarkerSize=10, MarkerFaceColor=thisColor , Color=thisColor )
            pax = gca;
            pax.ThetaZeroLocation = 'top';
            pax.ThetaDir = 'clockwise';
            pax.RTick = 0;
            pax.RTickLabel = {'Centre'};
            pax.ThetaTick = [0, 30, 330];
            pax.ThetaTickLabel = {'0°', '30°', '-30°'};
            pax.RLim = [0 radius];
            title('Right')

%             % Create a tile on the right column to get its position
%             ax1 = subplot(1,3,3,'Visible','off');
%             axPos = ax1.Position;
%             delete(ax1)
            % Construct a Legend with the data from the sub-plots
            hL1 = legend(lgd2, 'Rear Position - Kinematic', 'Rear Position - Kinetic', ...
                'Middle Position - Kinematic', 'Middle Position - Kinetic',...
                'Front Position - Kinematic', 'Front Position - Kinetic');
            % Move the legend to the position of the extra axes
            hL1.Position = [0.87 0.85 0.1 0.1];
        end

    end
end






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
%     plot(x+r*cosd(angle),y+r*sind(angle), 'o', "Color", thisColor, 'MarkerSize', 10)
% end
% legend(conditions, Location='northeastoutside')
% camroll(90)
% set(gca,"XDir","reverse")


end