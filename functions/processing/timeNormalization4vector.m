function [data_vector_norm] = timeNormalization4vector( data_vector, t, goalLength )
% Time Normalization of vector in regard to time point (here: minimum) 
% determine new y-values by linear regression for new t-values 
% -----------------------------------------------------------------------------
% data_vector: vector with data 
% t: initial time vector 
% goalLength: normalisation length 

% last entry
% data_vector_norm(goalLength) = data_vector(end); 

for iColumn = 1 : goalLength%-1

    if length( t ) == goalLength
        data_vector_norm(iColumn) = data_vector(iColumn); 
    else 
    
        % new t-vector, adjusted to goalLength 
        t_new = linspace( t(1), t(end), goalLength+1 );
        
        % find last index lower than actual t_new 
        lowerIdx = find( t <= t_new(iColumn), 1, 'last' ); 

        upperIdx = lowerIdx + 1; 

        % linear regression 
        x_values = [t(lowerIdx), t(upperIdx)]; 
        y_values = [data_vector(lowerIdx), data_vector(upperIdx)]; 

        coeff = polyfit( x_values, y_values, 1 ); 

        data_vector_norm(iColumn) = polyval( coeff, t_new(iColumn) ); 
    end 

end