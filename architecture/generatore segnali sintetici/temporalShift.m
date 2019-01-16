function baseSignal = temporalShift(baseSignal, shiftRange)
%TEMPORALSHIFT Applies temporal shift to the raw signal

    shift = round(rand() * shiftRange - shiftRange/2);

    if shift < 0
        baseSignal = [baseSignal(-shift+1:end),...
            zeros(1,-shift+1) + baseSignal(end)];
    else
        baseSignal = [zeros(1,shift) + baseSignal(1),...
            baseSignal(1:end-shift)];
    end
end

