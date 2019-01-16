function firstLevelPerceptron(basePath, training, compute)
%FIRSTLEVELPERCEPTRON create a first level perceptron where the user can 
%choose whether to execute train and/or compute the output
    %%
    %----------LOADING----------%
    archetypes = load([basePath, '/archetypes.mat']);
    archetypes = archetypes.archetypes;

    parameters = load([basePath, '/parametersBound.mat']);
    parameters = parameters.parametersBound;

    %%
    %----------CORE----------%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%create neighbour matrix
    %create the sysytem
    if ~exist('system', 'var')
        filters = cell(size(archetypes, 1), 1);
        for i = 1:size(archetypes, 1)
            newFilter = Filter();

            newFilter.addComponent(DoubleClumping(parameters(i).alphaMinC, parameters(i).alphaMaxC, ...
					parameters(i).betaMinC, parameters(i).betaMaxC,...
					parameters(i).gammaMinC, parameters(i).gammaMaxC,...
					parameters(i).lambdaMinC, parameters(i).lambdaMaxC),...
					false, true);	
            newFilter.addComponent(Trailing(parameters(i).deltaMin, ...
                parameters(i).deltaMax, ...
                parameters(i).domainMin, ...
                parameters(i).domainMax, ...
                parameters(i).domainResolution, ...
                TrapezoidalMark(parameters(i).epsilonMin, parameters(i).epsilonMax)), true);
            newFilter.addComponent(Similarity());
           
            newFilter.addComponent(Activation(parameters(i).alphaMinA, ...
                parameters(i).alphaMaxA, ...
                parameters(i).betaMinA, ...
                parameters(i).betaMaxA));
          
            filters{i, 1} = newFilter;
        end
        system = System(basePath);
        for i = 1:size(archetypes, 1)
            system.addFilter(filters{i, 1});
        end
    end

    %%   
    % ---------------------- TRAIN ---------------------- %
    if training
        % load signals
        trainingSet = load([basePath, '/training.mat']);
        trainingSet = trainingSet.trainingSignals;

        % load signals classifications
        trainingSetClassification = load([basePath, '/trainingClassification.mat']);
        trainingSetClassification = trainingSetClassification.trainingClassification;

        for i = 1:size(trainingSetClassification, 1)
            system.addTrainingSignal(trainingSet{i}, trainingSetClassification(i,:));
        end

        system.setNeighbourTable(createNeighbourMatrix(size(archetypes, 1), size(trainingSet{1,1}, 1)));
        
        % train system to recognize the archetype
        system.train(archetypes);

        % ---------------------- GET PARAMS ---------------------- %
        %%store found parameters
        optimizedParametersFirstLayer = cell(length(system.filters), 1);
        for i = 1:length(system.filters)
            optimizedParametersFirstLayer{i, 1} = system.filters{i}.getParams();
        end

        %store as a stand alone file
        save([basePath,'/optimizedParameters.mat'], 'optimizedParametersFirstLayer');

        % ---------------------- PARSE TO PARAMETERS STRUCTURE ---------------------- %
        load([basePath, '/parametersBound.mat']);
        for i = 1:length(system.filters)
            parametersBound(i).alphaC = optimizedParametersFirstLayer{i, 1}{1,2}(1);
            parametersBound(i).betaC = optimizedParametersFirstLayer{i, 1}{1,2}(2);
            parametersBound(i).gammaC = optimizedParametersFirstLayer{i, 1}{1,2}(3);
            parametersBound(i).lambdaC = optimizedParametersFirstLayer{i, 1}{1,2}(4);
            parametersBound(i).delta = optimizedParametersFirstLayer{i, 1}{1,2}(5);
            parametersBound(i).epsilon = optimizedParametersFirstLayer{i, 1}{1,2}(6);
            parametersBound(i).alphaA = optimizedParametersFirstLayer{i, 1}{1,2}(7);
            parametersBound(i).betaA = optimizedParametersFirstLayer{i, 1}{1,2}(8);
        end
        save([basePath, '/parametersBound.mat'], 'parametersBound');
        
        % ---------------------- DELETE DE TRASH FILES ---------------------- %
        %delete('fitness_*.mat');
        %delete('*.txt');
    end
    
    %%
    % ------------------ COMPUTE --------------------- %
    if compute
        if training
            %in this case is not needed to load the parameters since are
            %already loaded by the training process
        else
            %parameters loading
            %in this case reloading is necessary because the loading at
            %lines 11/12 doesn't allow dot indexing 
            load([basePath, '/parametersBound.mat']);
            
            %Control whether the training has already been executed
            if parametersBound(1).delta < 0
                error('Please execute training before compute for perceptron %s', basePath);
            end
            
            
            for i = 1:length(system.filters)
                %set filters parameters
                %create an array like:
                %[alphaC, betaC, delta, epsilon, alphaA, betaA]
                system.filters{i}.setParams([parametersBound(i).alphaC, ...
                    parametersBound(i).betaC, ...
                    parametersBound(i).gammaC, ...
                    parametersBound(i).lambdaC, ...
                    parametersBound(i).delta, ...
                    parametersBound(i).epsilon, ...
                    parametersBound(i).alphaA, ...
                    parametersBound(i).betaA]);
                
                %set filters archetypes
                system.filters{i}.idealSignal = archetypes(i, :);
                system.filters{i}.computePrototype();
            end
        end
		% load signals
        realwindowedSignals = load([basePath, '/signals.mat']);
        realwindowedSignals = realwindowedSignals.signals;

        inputSignals = realwindowedSignals;

        % similarit� raw
        rawSimilarities = cell(size(inputSignals, 1), 1);
        % similarit� sigmoidate
        similarities = cell(size(inputSignals, 1), 1);
        % segnali filtrati dalla prima sigmoide
        sigmoidedSignals = cell(size(inputSignals, 1), 1);
        % impronte stigmergiche segnali
        stigmergicTrailSignals = cell(size(inputSignals, 1), 1);

        clc;

        parfor i = 1:size(inputSignals, 1)
            %for each signal
            
            disp(['Start elaborate signal: ', num2str(i)]);

            rawSimilarities{i} = zeros(size(inputSignals{i}, 1), length(system.filters));
            similarities{i} = zeros(size(inputSignals{i}, 1), length(system.filters));
            sigmoidedSignals{i} = cell(size(inputSignals{i}, 1), 1);
            stigmergicTrailSignals{i} = cell(size(inputSignals{i}, 1), 1);

            for j = 1:size(inputSignals{i}, 1)
                %for each window of the signal
                
                % similarity before sigmoid
                similarities{i}(j,:) = system.compute(inputSignals{i}(j,:));
                % similarity raw
                rawSimilarities{i}(j,:) = cell2mat(system.getIntermediateResults(3));
                % signals after sigmoid
                sigmoidedSignals{i}{j} = system.getIntermediateResults(1);
                % impronte stigmergiche segnali
                stigmergicTrailSignals{i}{j} = system.getIntermediateResults(2);
            end
            %save(strcat('firstLevel/output_signal_', num2str(i), '.mat'));
        end

        % generate outputSignals
        % srfAggregator: 0: weighted mean all SRF
        %                1: weighted mean aroud max similarity
        %               
        
        signalsOut = srfAggregator(similarities,1);
        
        %store
        save([basePath, '/output.mat'], 'signalsOut','similarities', 'rawSimilarities', 'sigmoidedSignals', 'stigmergicTrailSignals','system');
        
        %%
        %in this case are needed
        clear;
        clc;

    end
end