function printWindows( basePath, windowsPerFigure, varargin)
%PRINTWINDOWS print under perceptron path all the windows of the signals
    %%
    %----------VARIABLES----------%
    folderBasePath = ['./', basePath, '/printWindows'];
    windowsPerLine = 2;
    
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
    
    realwindowedSignals = load([basePath, '/signals.mat']);
    realwindowedSignals = realwindowedSignals.signals;
    
    rawSignalsNames = load([basePath, '/rawSignals.mat']);
    rawSignalsNames = rawSignalsNames.textfile;
    
    %%
    %----------CORE----------%
    for i = 1:size(rawSignalsNames, 1)
        %cycle over signals
        windowIndex = 1;
        figureIndex = 1;
        
        for j = 1:size(realwindowedSignals{i, 1}, 1)
            %cycle over windows
            subHandle = subplot(ceil(windowsPerFigure/windowsPerLine), windowsPerLine, windowIndex);
            plot(realwindowedSignals{i, 1}(j, :));
            title(strcat('window: ',num2str(j)));
            ylim([0 1]);
            set(gca,'YTick',[0.25 0.5 0.75 1]); 
            
            if nargin == 3 & varargin{1}
                for l = 1:size(varargin{1},1)
                  line(get(gca,'XLim'), [varargin{1}(l,1) varargin{1}(l,1)], 'Color',[1 0 0], ...
                'LineStyle', ':', ...
                'LineWidth', 0.2);
                end   
            end    
                        
            
            
            if windowIndex == windowsPerFigure || j==size(realwindowedSignals{i, 1}, 1)
              
              set(gcf, 'PaperType', 'A3');
              set(gcf,'Visible','Off');
              suptitle(strcat('signal: ',num2str(i),'-',char(rawSignalsNames{i,1})));
              %fig.PaperUnits = 'inches';
              %fig.PaperPosition = [0 0 8.3 11.7];
              fileName = strcat(folderBasePath,'/', num2str(i), '-',num2str(figureIndex),'-', rawSignalsNames{i,1},'.png');
              disp(fileName);
              saveas(gcf,char(fileName));
              close(gcf);
              windowIndex = 1;
              figureIndex = figureIndex +1;
            else
              windowIndex = windowIndex+1;
              
            end
        end
        
        
        
        
    end
    
end

