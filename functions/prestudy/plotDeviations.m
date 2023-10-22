function plotDeviations(T_results_each_condition)

% colors = [0.8500, 0.3250, 0.0980;  [0.8500, 0.3250, 0.0980];  [0, 0.4470, 0.7410]; [0, 0.4470, 0.7410]; [0.4660, 0.6740, 0.1880]; [0.4660, 0.6740, 0.1880]];
% blue = 'b'; 
blue = [0.8500, 0.3250, 0.0980];  
% red = 'r'; 
red = [0, 0.4470, 0.7410];

figure("Name",'Comparison Methods - Deviations')
positions = reshape(1:12,[2,6])';
for i_condition = 1 : length(T_results_each_condition.Condition)

    lefts = [T_results_each_condition.(2){i_condition}, T_results_each_condition.(6){i_condition}]; 
    rights = [T_results_each_condition.(3){i_condition}, T_results_each_condition.(7){i_condition}]; 
    left_stds = [T_results_each_condition.(4){i_condition}, T_results_each_condition.(8){i_condition}]; 
    right_stds = [T_results_each_condition.(5){i_condition}, T_results_each_condition.(9){i_condition}]; 

    l1 = errorbar(positions(i_condition,:), [lefts(1), rights(1)],[left_stds(1), right_stds(1)], 'square-', 'MarkerSize', 8, 'Color', blue, MarkerFaceColor=blue); 
    hold on
    l2 = errorbar(positions(i_condition,:), [lefts(2), rights(2)],[left_stds(2), right_stds(2)], 'o-', 'MarkerSize', 8, 'Color', red, MarkerFaceColor=red); 

end 

% labels = {'1x5 5x1\newlinerear position','line1 line2','line1 line2'};
% labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
a = gca;
a.XTick = 1.5:2:12; 
a.XTickLabel = {'rear 1x5', 'rear 5x1', 'middle 1x5', 'middle 5x1', 'front 1x5', 'front 5x1'};
xlim([0 13])
ylabel('PFA Angle (°)')
xlabel('Condition')
legend([l1, l2], 'Kinetic PFA', 'Kinematic PFA')
fontsize(a, 16, "points")

end