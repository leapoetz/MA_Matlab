function T_results = plotPFA_eachInterval(PFA, settings)

conditions = fieldnames(PFA);
T_results = table();

for i_condition = 1:length(conditions)
    condition = conditions{i_condition};

    trials = fieldnames(PFA.(condition));
    for i_trial = 1:length(trials)
        trial = trials{i_trial};

        if length(PFA.(condition).(trial).intervals.left) > 1
            intervals_left = PFA.(condition).(trial).intervals.left(2:end);
        else
            intervals_left = PFA.(condition).(trial).intervals.left;
        end
        PFA_kinetic_left = PFA.(condition).(trial).kinetic.left;
        PFA_kinematic_left = PFA.(condition).(trial).kinematic.left;

        if length(PFA.(condition).(trial).intervals.right) > 1
            intervals_right = PFA.(condition).(trial).intervals.right(2:end);
        else
            intervals_right = PFA.(condition).(trial).intervals.right;
        end
        PFA_kinetic_right = PFA.(condition).(trial).kinetic.right;
        PFA_kinematic_right = PFA.(condition).(trial).kinematic.right;

        if settings.doPlot
            figure("Name",[condition,num2str(i_trial)])
            for i_interval = 1 : length(intervals_left)
                ax(2*i_interval-1) = subplot(length(intervals_left),2,2*i_interval-1);
                plot(PFA_kinetic_left(intervals_left{i_interval}))
                hold on
                plot(PFA_kinematic_left(intervals_left{i_interval}))
                xlabel('Frames')
                ylabel('PFA Angle (°)')
                legend('kinetic', 'kinematic')
                title(['Interval of Force Application No.',num2str(i_interval)])

                ax(2*i_interval) = subplot(length(intervals_right),2,2*i_interval);
                plot(PFA_kinetic_right(intervals_right{i_interval}))
                hold on
                plot(PFA_kinematic_right(intervals_right{i_interval}))
                xlabel('Frames')
                ylabel('PFA Angle (°)')
                legend('kinetic', 'kinematic')
                title(['Interval of Force Application No.',num2str(i_interval)])
            end
            sgtitle('LEFT                     RIGHT')
            AllYLim = get(ax, 'YLim');
            AllYLimValue = cell2mat(AllYLim);
            newYLim = [min(min(AllYLimValue)), max(max(AllYLimValue))];
            set(ax, 'YLim', newYLim);
        end



        %% create result table
        % -> left side
        mean_PFA_kinetic_left = nan(length(intervals_left)-1,1);
        mean_PFA_kinematic_left = nan(length(intervals_left)-1,1);
        std_PFA_kinetic_left = nan(length(intervals_left)-1,1);
        std_PFA_kinematic_left = nan(length(intervals_left)-1,1);

        % extract mean values during force application
        for i_interval = 1 : length(intervals_left)
            mean_PFA_kinetic_left(i_interval,:) = mean(PFA_kinetic_left(intervals_left{i_interval}), "omitnan");
            mean_PFA_kinematic_left(i_interval,:) = mean(PFA_kinematic_left(intervals_left{i_interval}), "omitnan");
            std_PFA_kinetic_left(i_interval,:) = std(PFA_kinetic_left(intervals_left{i_interval}), "omitnan");
            std_PFA_kinematic_left(i_interval,:) = std(PFA_kinematic_left(intervals_left{i_interval}), "omitnan");
        end

        % mean over cylces
        mean_PFA_kinetic_overall_left = mean(mean_PFA_kinetic_left, "omitnan");
        mean_PFA_kinematic_overall_left = mean(mean_PFA_kinematic_left, "omitnan");

        % -> right side
        mean_PFA_kinetic_right = nan(length(intervals_right)-1,1);
        mean_PFA_kinematic_right = nan(length(intervals_right)-1,1);
        std_PFA_kinetic_right = nan(length(intervals_right)-1,1);
        std_PFA_kinematic_right = nan(length(intervals_right)-1,1);

        % extract mean values during force application
        for i_interval = 1 : length(intervals_right)
            mean_PFA_kinetic_right(i_interval,:) = mean(PFA_kinetic_right(intervals_right{i_interval}), "omitnan");
            mean_PFA_kinematic_right(i_interval,:) = mean(PFA_kinematic_right(intervals_right{i_interval}), "omitnan");
            std_PFA_kinetic_right(i_interval,:) = std(PFA_kinetic_right(intervals_right{i_interval}), "omitnan");
            std_PFA_kinematic_right(i_interval,:) = std(PFA_kinematic_right(intervals_right{i_interval}), "omitnan");
        end

        % mean over cylces
        mean_PFA_kinetic_overall_right = mean(mean_PFA_kinetic_right, "omitnan");
        mean_PFA_kinematic_overall_right = mean(mean_PFA_kinematic_right, "omitnan");


        %% save results in table
        T_new = table(conditions(i_condition), i_trial, ...
            {(mean_PFA_kinetic_left)'}, {(mean_PFA_kinetic_right)'},...
            {(std_PFA_kinetic_left)'}, {(std_PFA_kinetic_right)'},...
            mean_PFA_kinetic_overall_left, mean_PFA_kinetic_overall_right,...
            {(mean_PFA_kinematic_left)'}, {(mean_PFA_kinematic_right)'},...
            {(std_PFA_kinematic_left)'}, {(std_PFA_kinematic_right)'},...
            mean_PFA_kinematic_overall_left, mean_PFA_kinematic_overall_right);
        T_results = [T_results; T_new];
    end
end

T_results.Properties.VariableNames = {'Condition', 'Trial', ...
    'Mean PFA Kinetic Left', 'Mean PFA Kinetic Right',...
    'Std PFA Kinetic Left', 'Std PFA Kinetic Right',...
    'Mean Over Cycles Kinetic Left', 'Mean Over Cycles Kinetic Right',...
    'Mean PFA Kinematic Left', 'Mean PFA Kinematic Right', ...
    'Std PFA Kinematic Left', 'Std PFA Kinematic Right',...
    'Mean Over Cycles Kinematic Left', 'Mean Over Cycles Kinematic Right'};
end