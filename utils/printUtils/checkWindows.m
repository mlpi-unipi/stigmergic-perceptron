function checkWindows( basePath, file, signal, window )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %%
    %----------CHECK----------%
    if ~(strcmp(file, 'output') || strcmp(file, 'test'))
        error('file must be ''output'' or ''test''');
    end
    if ~isa(signal, 'numeric')
        error('signal must be numeric');
    end
    if ~isa(window, 'numeric')
        error('window must be numeric');
    end
    
    %%
    %----------LOADING----------%
    if strcmp(file, 'output')
        outputMat = load([basePath, '/output.mat']);
    else
        outputMat = load([basePath, '/testing.mat']);
    end
    %stage 1 - clumping
    sigmoidedSignals = outputMat.sigmoidedSignals;
    %stage 2 - Trailing/Marking
    stigmergicTrailSignals = outputMat.stigmergicTrailSignals;
    %stage 3 - Similarity
    rawSimilarities = outputMat.rawSimilarities;
    %stage 4 - Activation
    similarities = outputMat.similarities;
    
    realwindowedSignals = load([basePath, '/signals.mat']);
    realwindowedSignals = realwindowedSignals.signals;
    %%
    receptiveFields = size(sigmoidedSignals{1, 1}{1, 1}, 1);
    length = receptiveFields+1;
    width = 4;
    signalLength = size(realwindowedSignals{1, 1}, 2);
    stigmergicSpaceLength = size(stigmergicTrailSignals{1, 1}{1, 1}{1, 1}, 2);
    
    %%
    %----------PRINT GRAPH----------%
    subplot(length, width, 1:width);
    plot(realwindowedSignals{signal, 1}(window, :));
    ylim([-0.1 1.1]);
    xlim([1 signalLength]);
    line(get(gca,'XLim'), [0.5 0.5], 'Color', [1 0 0], 'LineStyle', ':');
    title(['signal: ', num2str(signal), ' - ', 'window: ', num2str(window)]);
    
    %%
    %Clumping
    clumpPositions = (width+1):width:(receptiveFields*width)+width;
    for i = clumpPositions
        subplot(length, width, i);
        plot(sigmoidedSignals{signal, 1}{window, 1}{find(clumpPositions==i), 1});
        ylim([-0.1 1.1]);
        xlim([1 signalLength]);
    end
    
    %Trailing/Marking
    trailPositions = (width+2):width:(receptiveFields*width)+width;
    for i = trailPositions
        subplot(length, width, i);
        plot(stigmergicTrailSignals{signal, 1}{window, 1}{find(trailPositions==i, 1)});
        ylim([-0.1 signalLength]);
        xlim([0 stigmergicSpaceLength]);
    end
    
    %Similarity
    similarityPositions = (width+3):width:(receptiveFields*width)+width;
    for i = similarityPositions
        subplot(length, width, i);
        plot(0:1);
        ylim([-0.1 1.1]);
        xlim([0 1]);
        sim = rawSimilarities{signal, 1}(window, find(similarityPositions==i));
        line(get(gca,'XLim'), [sim sim]);
        if sim > 0.5
            text(0.5, sim-0.1, ['\uparrow ',num2str(sim, 4)]);
            %text(0.5, sim-0.1, ['\uparrow ',num2str(sim, 4)], ...
            %    'HorizontalAlignment', 'center');
        else
            text(0.5, sim+0.2, ['\downarrow ',num2str(sim, 4)]);
        end
    end
    
    %Activation
    activationPositions = (width+4):width:(receptiveFields*width)+width;
    for i = activationPositions
        subplot(length, width, i);
        plot(0:1);
        ylim([-0.1 1.1]);
        xlim([0 1]);
        sim = similarities{signal, 1}(window, find(activationPositions==i));
        line(get(gca,'XLim'), [sim sim]);
        if sim > 0.5
            text(0.5, sim-0.1, ['\uparrow ',num2str(sim, 4)]);
        else
            text(0.5, sim+0.2, ['\downarrow ',num2str(sim, 4)]);
        end
    end
end

