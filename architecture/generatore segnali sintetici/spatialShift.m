function signal = spatialShift(baseSignal, signalLength, correctionFactor, noiseRange)
%SPATIALSHIFT Applies spatial shift to a signal. 

    ripple = rand(1, size(baseSignal, 2)) * noiseRange - noiseRange/2;
    %%{
    loInd = baseSignal == 0 & ripple < 0;
    ripple(loInd) = abs(ripple(loInd)) + noiseRange/2;
    hiInd = baseSignal == 1 & ripple > 0;
    ripple(hiInd) = -ripple(hiInd) - noiseRange/2;
    %}

    signal = baseSignal * correctionFactor + ripple;
    signal = signal(1:signalLength);
    signal(signal < 0) = 0;
    signal(signal > 1) = 1;
end

