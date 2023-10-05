function intervals_constantKineticPFA = detectConstantKineticPFA_intervals(PFA_kinetic, settings, i_condition)

sides = {'left', 'right'}; 

for i_side = 1 : length(sides)
    side = sides{i_side}; 

    logicals_constant = abs(diff(PFA_kinetic.(side))) < 0.2;
    logicals_start_end = abs(diff(logicals_constant)); % wann ändert sich 0 zu 1 oder anders herum
    indices = find(logicals_start_end);
    
    if ~mod(i_condition,2)==0 % for constant force application
        [max_interval, idx_max] = max(diff(find(logicals_start_end))); % wann ist längstes interval
        intervals_constant = {indices(idx_max):indices(idx_max)+max_interval};
    else % for short force application
        [sorted_intervals, sorting] = sort(diff(find(logicals_start_end)));
      
        six_intervals = sorted_intervals(length(sorted_intervals)-5:length(sorted_intervals));
        five_idx = sorting(length(sorted_intervals)-5:length(sorted_intervals));
    
        for i_interval = 1 : length(six_intervals)
            intervals_constant{i_interval,:} = indices(five_idx(i_interval)) : indices(five_idx(i_interval)) + six_intervals(i_interval);
        end
    end

    if settings.doPlot
        figure(Name=('Intervals of Constant Kinetic PFA'))
        plot(PFA_kinetic.(side))
        for i_interval = 1 : size(intervals_constant,1)
            xline(intervals_constant{i_interval,1})
            xline(intervals_constant{i_interval,length(intervals_constant{i_interval,:})})
        end
    end

    intervals_constantKineticPFA.(side) = intervals_constant; %(1,:):intervals_constant(2,:); 

end