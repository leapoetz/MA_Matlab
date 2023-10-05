function T_deviation = calcDeviation(T_results)

deviation_left = cell(length(T_results.Condition), 1); 
deviation_right = cell(length(T_results.Condition), 1);

for i_row = 1 : length(T_results.Condition)
    deviation_left{i_row} = T_results.("Mean PFA Kinetic Left"){i_row} - T_results.("Mean PFA Kinematic Left"){i_row};
    deviation_right{i_row} = T_results.("Mean PFA Kinetic Right"){i_row} - T_results.("Mean PFA Kinematic Right"){i_row};
end

if strcmp(T_results.Properties.VariableNames{2}, "Trial")
    T_deviation = table( T_results.("Condition"), T_results.("Trial"), deviation_left, deviation_right);
    T_deviation.Properties.VariableNames = {'Condition', 'Trial', 'Deviation Left', 'Deviation Right'};
else
    T_deviation = table( T_results.("Condition"), deviation_left, deviation_right);
    T_deviation.Properties.VariableNames = {'Condition', 'Deviation Left', 'Deviation Right'};
end
