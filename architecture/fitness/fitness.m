function val = fitness(mng, params)
%FITNESS Summary of this function goes here
%   Detailed explanation goes here

    filter = mng{1};
    prototypeFromStage = mng{2};

    signals = mng{3};
    numberOfSignals = size(signals, 1);
    
    filter.setParams(cell2mat(struct2cell(params)));
    filter.prototype = filter.compute(filter.idealSignal, prototypeFromStage);
    
    similarities = zeros(numberOfSignals,1);
    for i = 1:numberOfSignals
        similarities(i) = filter.compute(signals(i,:));
    end
    
    otherSignals = mng{4};
    numberOfOtherSignals = size(otherSignals, 1);
    dissimilarities = zeros(numberOfOtherSignals, 1);
    for i = 1:numberOfOtherSignals
        dissimilarities(i) = filter.compute(otherSignals(i,:));
    end
    
    %mse
    reference = [zeros(numberOfSignals,1) + 1; zeros(numberOfOtherSignals,1)];
    sim = [similarities; dissimilarities];
    diff = (reference - sim).^2;

    val = mean(diff);
        
end

