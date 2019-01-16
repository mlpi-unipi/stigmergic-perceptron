function signal = prepareSignal(varargin)
%PREPARESIGNAL Given a signal returns the signal shifted in both time and space
    
    baseSignal = varargin{1};       % raw signal
    
    signalLength = varargin{2};
    correctionFactor = varargin{3};
    
    randomNoiseRange = varargin{4}; % ripple
    shiftMax = varargin{5};         % temportal shift max variation limit
    
    signal = temporalShift(baseSignal, shiftMax);                    % apply temporal shitft
    signal = spatialShift(signal, signalLength, correctionFactor,... % apply spacial shift
        randomNoiseRange);
end

