function findClumps (signal, window, params)
    realwindowedSignals = load(['p1_saraFinal', '/signals.mat']);
    realwindowedSignals = realwindowedSignals.signals;
    subplot(2,1,1)
    %plot real window
    plot(realwindowedSignals{signal, 1}(window, :));ylim([0 1])
    subplot(2,1,2)
    %plot real window
    plot(doubleSigmoid(realwindowedSignals{signal, 1}(window, :),params)); ylim([0 1])
end