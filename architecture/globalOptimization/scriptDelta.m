%% 

files = dir(strcat(basePath,'/optimizationResult/Global'));
filesName = {};

%compile list of files with result of the optimization
for i = 1:size(files, 1)
    if strmatch('workspace_trial', files(i).name)
        filesName{end+1} = files(i).name;
    end
end

%a cell array that contains all the bound for delta found at each
%repetition
allDeltaIntervals = {};

%iterate over each folder
for file = filesName
    
    %load everithing
    load(file{1,1});
    load(resultFileName);
    
    disp(['analizing delta from: ', resultFileName]);
    %% 
    
    %crea un array con tutti i valori distinti della funzione di fitness
    %(minori di quelli trovati in precedenza)
    j = 1;
    for r = 1:length(optimResult.allEvaluationValues)
        if(r==1)
            evaluationValuesAll(j) = optimResult.allEvaluationValues(r);
            evaluationMembersIndex(j) = r;
            j = j+1;
        elseif (j>1 && optimResult.allEvaluationValues(r)<evaluationValuesAll(j-1))
            evaluationValuesAll(j) = optimResult.allEvaluationValues(r);
            evaluationMembersIndex(j) = r;
            j = j+1;
        end
    end
    
    %% 
    
    %trova il valore limite pari al 10% dell'intervallo
    minVal = min(evaluationValuesAll(1,:));
    maxVal = max(evaluationValuesAll(1,:));
    
    tenpercent = (maxVal - minVal)/100*5;  % 10% del valore ottimo
    
    limitValue = bestval + tenpercent;
    
    firstIndex = min(find(evaluationValuesAll<limitValue));
    
    %% 
    
    %members all
    h = 1;
    for k = 1:length(evaluationMembersIndex)
        if(evaluationMembersIndex(k)>=firstIndex)
            evaluationMemberAll(:,h) = optimResult.allTestedMembers(:,evaluationMembersIndex(k));
            h = h+1;
        end
    end
    
    %% 
    
    %deltaIntervals
    deltaMin = zeros(numFilters, 1);
    deltaMax = zeros(numFilters, 1);
    
    deltaIntervals = zeros(numFilters, 2);
    j = 1;
    for i = 1:2:size(evaluationMemberAll, 1)
        deltaMin(j) = min(evaluationMemberAll(i,:));
        deltaMax(j) = max(evaluationMemberAll(i,:));
        deltaIntervals(j, :) = [deltaMin(j) deltaMax(j)];
        j = j+1;
    end
    
    allDeltaIntervals{end+1} = deltaIntervals;
    
    %% 
    
    clear evaluationValuesAll;
    clear evaluationMembersIndex;
    clear evaulationMemberAll;
end

%% 

%this part compute a final matrix where the i-th row is the min and max
%bound of the delta parameter of the i-th filter
b = cell2mat(allDeltaIntervals);
minValues = max(b, [], 2);
for i = 1:2:size(b, 2)
    tmp = min(minValues, b(:, i));
    minValues = tmp;
end

maxValues = min(b, [], 2);
for i = 2:2:size(b, 2)
    tmp = max(maxValues, b(:, i));
    maxValues = tmp;
end

globalOptimizedDeltaIntervals = [minValues, maxValues];

%% 

%store delta intervals
%save('parameters/globalOptimizedDeltaIntervals.mat', 'globalOptimizedDeltaIntervals');
load([basePath, '/parametersBound.mat']);
for i = 1:size(globalOptimizedDeltaIntervals, 1)
    parametersBound(i).deltaMin = globalOptimizedDeltaIntervals(i, 1);
    parametersBound(i).deltaMax = globalOptimizedDeltaIntervals(i, 2);
end
save([basePath, '/parametersBound.mat'], 'parametersBound');

%% 

%delte useless files
%delete('optimizeDelta*.mat');
%delete('*.txt');
%delete('workspace_trial*.mat');

clear;
%clc
