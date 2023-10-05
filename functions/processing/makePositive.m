function data_positive = cutAndAdjustData(data)



for i_frame = 2 : n_frames-1
    if data.Speed_left(i_frame-1) <= 0.3 && data.Speed_left(i_frame) >= 0.3
        while data.Speed_left(i_frame) <= data.Speed_left(i_frame+1) && i_frame < n_frames-1
            i_frame = i_frame - 1;
        end
        idx_start_left = i_frame; 
        break;
    end 
end 
for i_frame = 2 : n_frames-1
    if data.Speed_right(i_frame-1) <= 0.3 && data.Speed_right(i_frame) >= 0.3
        while data.Speed_right(i_frame) <= data.Speed_right(i_frame+1) && i_frame < n_frames-1
            i_frame = i_frame - 1;
        end
        idx_start_right = i_frame; 
        break;
    end 
end


% change signs and make all positive
parameters = fieldnames(data);
for iParameter = 1 : length(parameters)
    thisParameter = parameters{iParameter};
    
    if iParameter < 9
    for iCoordinate = 1 : width(data.(thisParameter))
        if mean(data.(thisParameter)(:,iCoordinate),"omitnan") < 0
            data_positive.(thisParameter)(:,iCoordinate) = - data.(thisParameter)(1:end,iCoordinate);
        else
            data_positive.(thisParameter)(:,iCoordinate) = data.(thisParameter)(1:end,iCoordinate);
        end
    end
    else
            data_positive.(thisParameter) = data.(thisParameter);
    end
end