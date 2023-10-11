function data_cut = cutAndAdjustData(data)

n_frames = length(data.F_left); 
threshold = 0.1; 

idx_end_dynamic_left = n_frames; 
idx_end_dynamic_right = n_frames; 
for i_frame = 2 : n_frames-1
    if data.Speed_left(i_frame-1) >= threshold && data.Speed_left(i_frame) <= threshold
        while data.Speed_left(i_frame) >= data.Speed_left(i_frame+1) && i_frame < n_frames-1
            i_frame = i_frame + 1;
        end
        idx_end_dynamic_left = i_frame; 
    end 
end 
for i_frame = 2 : n_frames-1
    if data.Speed_right(i_frame-1) >= threshold && data.Speed_right(i_frame) <= threshold
        while data.Speed_right(i_frame) >= data.Speed_right(i_frame+1) && i_frame < n_frames-1
            i_frame = i_frame + 1;
        end
        idx_end_dynamic_right = i_frame; 
    end 
end

end_dynamic = round(mean([idx_end_dynamic_left, idx_end_dynamic_right])); 

% figure()
% yyaxis left
% plot(data.F_left(:,1))
% hold on 
% yyaxis right
% plot(data.Speed_left)
% xline(end_dynamic)
% legend('Fx','Speed','Start')

% change signs and make all positive
parameters = fieldnames(data);
for iParameter = 1 : length(parameters)
    thisParameter = parameters{iParameter};

    if iParameter < 9
        for iCoordinate = 1 : width(data.(thisParameter))
%             if min(data.(thisParameter)(:,iCoordinate),[], "omitnan") < -2
%                 data_positive.(thisParameter)(:,iCoordinate) = - data.(thisParameter)(1:end_dynamic,iCoordinate);
%             else
                data_cut.(thisParameter)(:,iCoordinate) = data.(thisParameter)(1:end_dynamic,iCoordinate);
%             end
        end
    else
        data_cut.(thisParameter) = data.(thisParameter);
    end
end