function printSuperimposedSignalsDouble( basePath, indexlist)
%PRINTSUPERIMPOSEDSIGNALSDOUBLE Work as printSuperimposedSignals but print
%botth type of graph.
% 'raw' on the left and 'stigmergicOutput' on the right
    %%
    %----------LOADING----------%
    signals1 = load([basePath, '/rawSignals.mat']);
    signals1 = signals1.result;

    signals2 = load([basePath, '/output.mat']);
    signals2 = signals2.signals;
    
    
    %%
    
    subplot(1, 2, 1);
    plot(normalize01(signals1(indexlist(1), :)));
    ylim([0 1]);
    xlim([0 size( signals1(indexlist(1), :), 2 )]);
    hold on
    for i = 2:size(indexlist, 2)
        plot(normalize01(signals1(indexlist(i), :)));
    end
    hold off
    
    subplot(1, 2, 2);
    plot(signals2{indexlist(1)});
    hold on
    for i = 2:size(indexlist, 2)
       plot(signals2{indexlist(i)}); 
    end
    hold off
end