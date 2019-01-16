function optimizeDeltaBoundaries( basePath, varargin )
%OPTIMIZEDELTABOUNDARIES Evaluate the best bound for the evaporation factor
%   basePath -> folder (without final '/') where archetypes.mat and 
%   parametersBound.mat are stored
%   varargin -> extra comma separated parameters to set respectively the 
%   number of shifts and the number of trials that the Differential 
%   evoulution algorithm shall use. If not specified, the default
%   parameters used are 2 (number of shifts) and 5 (number of trials)
%   ES. 
%   optimizeDeltaBoundaries('p1');
%   optimizeDeltaBoundaries('p1', 2, 5);

    %----------PARAMETERS PARSING----------%
    if nargin == 3
        numShift = varargin{1};
        numTrials = varargin{2};
    else
        numShift = 2;
        numTrials = 5;
    end
    
    %----------LOADING----------%
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;

    parameters = load([basePath, '/parametersBound.mat']);
    parameters = parameters.parametersBound;

    %----------CORE----------%
    if ~exist('system', 'var')
        system = SystemOptimization(basePath);
        % Prepare the filters
        % in this case it's possible to use a for cycle since initialization 
        % isn't important
        for i = 1:size(archetypes, 1)
            newFilter = Filter();
            newFilter.addComponent(Trailing(parameters(i).deltaMin, ...
                parameters(i).deltaMax, ...
                parameters(i).domainMin, ...
                parameters(i).domainMax, ...
                parameters(i).domainResolution, ...
                TrapezoidalMark(parameters(i).epsilonMin, parameters(i).epsilonMin)), true);
            newFilter.addComponent(Similarity());

            system.addFilter(newFilter);
        end
    end

    % Train evaporation
    system.globalTrain(archetypes, numShift, numTrials);
    
    %% Update parametersBound.mat
    scriptDelta(basePath);
end
    
    