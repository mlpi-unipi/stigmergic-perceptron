function printNormalizedSignals( basePath )
%PRINNORMALIZEDSIGNALS print under perceptron path all the signals
    %%
    %----------VARIABLES----------%
    folderBasePath = ['./', basePath, '/printSignals'];
    
    %%
    %----------CHECK----------%
    if exist(folderBasePath) == 0
        mkdir(folderBasePath);
    else
        rmdir(folderBasePath,'s');
        mkdir(folderBasePath);
    end
    
    %%
    %----------LOADING----------%
    rawSignals = load([basePath, '/rawSignals.mat']);
    rawSignals = rawSignals.result;
    
    rawSignalsNames = load([basePath, '/rawSignals.mat']);
    rawSignalsNames = rawSignalsNames.textfile;
    
    %%
    %----------CORE----------%
    for i = 1:size(rawSignalsNames, 1)
        %cycle over signals
        sup = normalize01(rawSignals(i, :));
        plot(sup);
        title(rawSignalsNames{i, 1});
        ylim([0 1]);
        xlim([1 size(rawSignals, 2)]);
        set(gca,'XTick',1:30:size(rawSignals, 2), ...
            'XTickLabel',{'2:00','2:30','3:00','3:30','4:00','4:30','5:00','5:30'}); 
%         line(get(gca,'XLim'), [0.5 0.5], 'Color',[1 0 0], 'LineStyle', ...
%             ':', 'LineWidth', 0.2);
        for j = 1:10:size(rawSignals, 2)
            line([j j], get(gca, 'YLim'), 'LineWidth', 0.2, ...
                'LineStyle', ':');
        end

        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 11.7 8.3];
        print([folderBasePath,'/', num2str(i), '-', rawSignalsNames{i, 1}], '-djpeg', '-r0');
    end 
end

