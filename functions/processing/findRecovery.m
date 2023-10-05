function [indices_recovery] = findRecovery(M_z_new, settings)

% in case M_z is negative 
if mean(M_z_new) < 0
    M_z_new = - M_z_new; 
end 

while max(M_z_new, [], "omitnan") - min(M_z_new, [], "omitnan") > settings.offset_threshold
    % Remove 1% of data that are the farthest to the median: sort data

    % determine difference between values and median
    [~, index_to_remove] = sort(abs(M_z_new - median(M_z_new, "omitnan")));
    % sort M_z accordingly
    sorted_Mz_new = M_z_new(index_to_remove);
    % find values that are not nan 
    index_to_remove = index_to_remove(~isnan(sorted_Mz_new));
    % find the upper 1 % of these values 
    index_to_remove = index_to_remove(round(0.99 * length(index_to_remove)) - 1 : end);
    % assign nan to these data
    M_z_new(index_to_remove) = nan;
end
indices_recovery = ~isnan(M_z_new);


% remove all wrongly detected recovery indices 
length_this_recovery = 0; 
these_indices = []; 
for ctr = 1 : length(indices_recovery)
    if indices_recovery(ctr) == 1 
        length_this_recovery = length_this_recovery + 1; 
        these_indices = [these_indices, ctr]; 
    elseif indices_recovery(ctr) == 0 
        if length_this_recovery < 50 
            indices_recovery(these_indices) = 0; 
        end
        length_this_recovery = 0;
        these_indices = [];
    end 
end 

% remove all wrongly detected push indices 
length_this_push = 0; 
these_indices = []; 
for ctr = 1 : length(indices_recovery)
    if indices_recovery(ctr) == 0 
        length_this_push = length_this_push + 1; 
        these_indices = [these_indices, ctr]; 
    elseif indices_recovery(ctr) == 1 
        if length_this_push < 50 
            indices_recovery(these_indices) = 1; 
        end
        length_this_push = 0;
        these_indices = [];
    end 
end 


end