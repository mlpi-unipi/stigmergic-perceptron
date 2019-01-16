function printSeries( basePath, series )
%PRINTSERIES Show plot of the output series specified in the series array
% eg. printSeries('p1', [5 7 9]);
    
    %%
    %----------LOADING----------%
    inputSignals = load([basePath, '/output.mat']);
    inputSignals = inputSignals.signals;
    
    signalsName = load([basePath, '/rawSignals.mat']);
    signalsName = signalsName.textfile;

    
    %%
    columns = 3;
    rows = ceil(size(series, 2)/columns);
    
    %%
    j = 1;
    for i = series
        subplot(rows, columns, j);
        plot(inputSignals{i, 1});
        title([num2str(i), '-', signalsName(i)]);
        
        j = j+1;
    end
end

