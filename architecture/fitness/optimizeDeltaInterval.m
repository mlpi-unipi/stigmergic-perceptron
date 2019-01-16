% funzione di fitness per ottimizzazione intervalli delta

function value = optimizeDeltaInterval(settings, params)

    filters = settings{1};
    signals = settings{2};
    idealSimilarity = settings{3};
    weightSimilarity = settings{4};
    numFilters = length(filters);
    numSignals = size(signals, 1);
    
    %initialize real similarity
    similarityFromFilter = zeros(numSignals, numFilters);
    
    
    prototype = cell([numFilters 1]);
   
    paramsPerComp = cell([numFilters 1]);
    
    
    div = 2; %length(params)/numFilters;
    k = 1;
    h = 1;
    
    paramsTmp =  cell2mat(struct2cell(params));
    
    while k < numFilters*2;%size(paramsTmp, 1)
        
        paramsPerComp{h} = paramsTmp(k:(k+div-1));
        k = k+div;
        h = h+1;
    end
       
   
    for i = 1:numFilters
        
        filters{i}.setParams(paramsPerComp{i});
        filters{i}.computePrototype();
        prototype{i} = filters{i}.prototype;
        
        
        for j = 1:numSignals
                         
            similarityFromFilter(j,i) = filters{i}.compute(signals(j,:));
           % diffSimilarity(j,i) = abs(idealSimilarity(j,i) - similarityFromFilter(j,i))*weightSimilarity(j,i);
        end
        
    end
    
    diffSimilarity = abs(idealSimilarity - similarityFromFilter).*weightSimilarity;
    sumSimilarity = sum(diffSimilarity(:));
        
    value = sumSimilarity/((numFilters - 1) * numSignals * 1/(numFilters - 1) + numSignals);
        
end