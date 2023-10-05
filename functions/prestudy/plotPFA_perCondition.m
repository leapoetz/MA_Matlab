function T_results_per_condition = plotPFA_perCondition(PFA, settings)


conditions = fieldnames(PFA);
T_results_per_condition = table();

for i_condition = 1:length(conditions)
    condition = conditions{i_condition};

    trials = fieldnames(PFA.(condition));
    intervals_all_trials_kinetic_left = [];
    intervals_all_trials_kinematic_left = [];
    intervals_all_trials_kinetic_right = [];
    intervals_all_trials_kinematic_right = [];
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

        %% left side

        % interpolation for mean building
        for i_interval = 1 : length(intervals_left)

            if mod(i_condition,2) == 0 % short
                new_interval = 1 : 300;
            else % constant
                new_interval = 1 : 1500;
            end

            thisInterval = intervals_left{i_interval};
            old_interval = 1 : length(thisInterval);
            % interpolate intervals to get same length
            PFA_interpolated.(condition).(trial).kinetic.left(i_interval,:) = interp1(old_interval,PFA_kinetic_left(thisInterval),new_interval, "linear", "extrap");
            PFA_interpolated.(condition).(trial).kinematic.left(i_interval,:) = interp1(old_interval,PFA_kinematic_left(thisInterval),new_interval, "linear", "extrap");

            thisInterval = intervals_right{i_interval};
            old_interval = 1 : length(thisInterval);
            % interpolate intervals to get same length
            PFA_interpolated.(condition).(trial).kinetic.right(i_interval,:) = interp1(old_interval,PFA_kinetic_right(thisInterval),new_interval, "linear", "extrap");
            PFA_interpolated.(condition).(trial).kinematic.right(i_interval,:) = interp1(old_interval,PFA_kinematic_right(thisInterval),new_interval, "linear", "extrap");
        end

        if mod(i_condition,2) == 0 % short
            intervals_all_trials_kinetic_left(i_trial,:) = mean(PFA_interpolated.(condition).(trial).kinetic.left, 'omitnan');
            intervals_all_trials_kinematic_left(i_trial,:) = mean(PFA_interpolated.(condition).(trial).kinematic.left, 'omitnan');
            intervals_all_trials_kinetic_right(i_trial,:) = mean(PFA_interpolated.(condition).(trial).kinetic.right, 'omitnan');
            intervals_all_trials_kinematic_right(i_trial,:) = mean(PFA_interpolated.(condition).(trial).kinematic.right, 'omitnan');
        else % constant
            intervals_all_trials_kinetic_left(i_trial,:) = PFA_interpolated.(condition).(trial).kinetic.left;
            intervals_all_trials_kinematic_left(i_trial,:) = PFA_interpolated.(condition).(trial).kinematic.left;
            intervals_all_trials_kinetic_right(i_trial,:) = PFA_interpolated.(condition).(trial).kinetic.right;
            intervals_all_trials_kinematic_right(i_trial,:) = PFA_interpolated.(condition).(trial).kinematic.right;

        end

    end
    PFA_mean_per_condition.(condition).kinetic.left = mean(intervals_all_trials_kinetic_left, 'omitnan');
    PFA_mean_per_condition.(condition).kinematic.left = mean(intervals_all_trials_kinematic_left, 'omitnan');
    PFA_mean_per_condition.(condition).kinetic.right = mean(intervals_all_trials_kinetic_right, 'omitnan');
    PFA_mean_per_condition.(condition).kinematic.right = mean(intervals_all_trials_kinematic_right, 'omitnan');


    %% create figure

    if settings.doPlot
        figure("Name",['Mean PFA for Condition: ',condition])
        ax(1) = subplot(1,2,1);
        plot(PFA_mean_per_condition.(condition).kinetic.left)
        hold on
        plot(PFA_mean_per_condition.(condition).kinematic.left)
        legend('kinetic', 'kinematic')
        xlabel('Frames')
        ylabel('PFA Angle (°)')
        title('LEFT')
        ax(2) = subplot(1,2,2);
        plot(PFA_mean_per_condition.(condition).kinetic.right)
        hold on
        plot(PFA_mean_per_condition.(condition).kinematic.right)
        legend('kinetic', 'kinematic')
        xlabel('Frames')
        ylabel('PFA Angle (°)')
        title('RIGHT')
        sgtitle('Mean over all trials and intervals')
        AllYLim = get(ax, 'YLim');
        AllYLimValue = cell2mat(AllYLim);
        newYLim = [min(min(AllYLimValue)), max(max(AllYLimValue))];
        set(ax, 'YLim', newYLim);
    end

    %% save in table

    T_results_per_condition_new = table({condition}, ...
        {mean(PFA_mean_per_condition.(condition).kinetic.left, 'omitnan')}, {mean(PFA_mean_per_condition.(condition).kinetic.right, 'omitnan')},...
        {std(PFA_mean_per_condition.(condition).kinetic.left, 'omitnan')}, {std(PFA_mean_per_condition.(condition).kinetic.right, 'omitnan')},...
        {mean(PFA_mean_per_condition.(condition).kinematic.left, 'omitnan')}, {mean(PFA_mean_per_condition.(condition).kinematic.right, 'omitnan')},...
        {std(PFA_mean_per_condition.(condition).kinematic.left, 'omitnan')}, {std(PFA_mean_per_condition.(condition).kinematic.right, 'omitnan')});
    T_results_per_condition = [T_results_per_condition; T_results_per_condition_new];


end

T_results_per_condition.Properties.VariableNames = {'Condition', ...
    'Mean PFA Kinetic Left', 'Mean PFA Kinetic Right', ...
    'Std PFA Kinetic Left', 'Std PFA Kinetic Right',...
    'Mean PFA Kinematic Left', 'Mean PFA Kinematic Right',...
    'Std PFA Kinematic Left', 'Std PFA Kinematic Right'};

end