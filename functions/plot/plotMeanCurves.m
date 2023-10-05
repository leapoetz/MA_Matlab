function plotMeanCurves(mean_curves)

%% predefs
sides = {'left', 'right'};
parameter_names = fieldnames(mean_curves);
positions = [1, 2; 3, 4; 5, 6]; 

iPlot = 1; 
for iParameter = 1 : length(parameter_names)
    parameter_name = parameter_names{iParameter};

    figure("Name",parameter_name);
    for iSide = 1 : length(sides)
        thisSide = sides{iSide};
        nSubj = length(mean_curves.(parameter_name).(thisSide));

        for iSubj = 1:nSubj
            nCondition = width(mean_curves.(parameter_name).(thisSide));

            for iCondition = 1:nCondition

%                 figure("Name",['Condition',num2str(iCondition),parameter_name])
                ax(iPlot) = subplot(3,2,positions(iCondition,iSide)); 
                iPlot = iPlot + 1; 
                thisCurve = mean_curves.(parameter_name).(thisSide){iSubj,iCondition};
                plot(thisCurve)
                hold on
                title(['Condition',num2str(iCondition)])
                sgtitle('LEFT                   RIGHT')

           end
        end
    end
%     AllYLim = get(ax, 'YLim');
%     AllYLimValue = cell2mat(AllYLim);
%     newYLim = [min(min(AllYLimValue)), max(max(AllYLimValue))];
%     set(ax, 'YLim', newYLim);
end




end