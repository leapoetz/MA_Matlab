function doErrorbarPlot(T_results)


conditions = {'rear position_{constant}', 'rear position_{short}', ...
    'middle position_{constant}', 'middle position_{short}',...
    'front position_{constant}', 'front position_{short}'}; 

figure(Name='Results Prestudy: means and errorbars')
for i_condition = 1 : length(conditions)
    x = [1 2 4 5]; 
    y = [T_results.("Mean PFA Kinetic Left"){i_condition}, T_results.("Mean PFA Kinetic Right"){i_condition}, T_results.("Mean PFA Kinematic Left"){i_condition}, T_results.("Mean PFA Kinematic Right"){i_condition}]; 
    stds = [T_results.("Std PFA Kinetic Left"){i_condition}, T_results.("Std PFA Kinetic Right"){i_condition}, T_results.("Std PFA Kinematic Left"){i_condition}, T_results.("Std PFA Kinematic Right"){i_condition}];

    ax = subplot(3,2,i_condition); 
    errorbar(x,y,stds, '.')
    xlim([0 6])
    ax.XTick = x; 
    ax.XTickLabel = {'Kinetic L', 'Kinetic R', 'Kinematic L', 'Kinematic R'}; 
    title(ax, [conditions{i_condition}])
    ylabel('PFA Angle (°)')   
end 


end