function doBlandAltman(kinetic, kinematic)

figure("Name",'Bland-Altman Diagram')
differences = kinetic - kinematic; 
means = (kinetic + kinematic) ./ 2; 
mean_diff = mean( differences ); 

% regression line
coeff = polyfit( means, differences,1 ); 
x = means; 

scatter( means, differences, 'k' )
hold on
l1 = yline( mean_diff,'r' ); 
l2 = yline( mean_diff + 1.96 .* std( differences ),'b--' ); 
yline( mean_diff - 1.96 .* std( differences ),'b--' ); 
l3 = plot( x, polyval( coeff, x ), 'g' ); 
xlabel( 'Mean PFA Angle (°)' )
ylabel( 'Difference (Kinetic - Kinematic) PFA Angle (°)' )
title( 'Bland Altman Diagram: Kinetic vs. Kinematic' )
legend([l1, l2, l3], 'Mean Difference', 'Mean +- 1.96 * Std Difference', 'Linear Regression')
ax = gca; 
fontsize(ax, 16, "points")


end 