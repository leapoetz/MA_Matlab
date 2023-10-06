function data_corrected = correctSWData(data, interval)

data_corrected = data; 

% [~,idx_max_left] = max(data.LFIN2(1:500,3));
% if idx_max_left < 20
%     idx_max_left = idx_max_left + 30;
% end
% [~,idx_max_right] = max(data.RFIN2(1:500,3));
% if idx_max_right < 20
%     idx_max_right = idx_max_right + 30;
% end

for iComponent = 1 : 3
    data_corrected.F_left(interval,iComponent) = data.F_left(interval,iComponent) - mean(data.F_left(interval,iComponent));
    data_corrected.M_left(interval,iComponent) = data.M_left(interval,iComponent) - mean(data.M_left(interval,iComponent));

    data_corrected.F_right(interval,iComponent) = data.F_right(interval,iComponent) - mean(data.F_right(interval,iComponent));
    data_corrected.M_right(interval,iComponent) = data.M_right(interval,iComponent) - mean(data.M_right(interval,iComponent));
end


end