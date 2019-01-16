classdef System < handle
    %SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public) %(GetAccess = public, SetAccess = private)
        filters
        trainingSignals
        neighbours
        basePath
    end
    
    methods (Access = public)
        function this = System(basePath)
            if exist(strcat(basePath,'/optimizationResult/Local')) == 0
                mkdir(strcat(basePath,'/optimizationResult/Local'));
            end    
            this.filters = {};
            this.basePath = strcat(basePath,'/optimizationResult/Local');
            this.trainingSignals = cell(0, 2);
            % by default each filter receives just its trainig signals
            this.neighbours = -eye(length(this.filters)); 
        end
        
        function addFilter(this, filter)
            this.filters{end+1} = filter;
        end
        
        function output = compute(this, input, varargin)
            output = cell(length(this.filters),1);
            for i = 1:length(this.filters)
                if ~isempty(varargin)
                    output{i} = this.filters{i}.compute(input, varargin{:});
                else
                    output{i} = this.filters{i}.compute(input);
                end
            end
            output = cell2mat(output);
        end

        function results = getIntermediateResults(this, stage)
            results = cell(length(this.filters),1);
            for i = 1:length(this.filters)
                results{i} = this.filters{i}.getIntermediateResult(stage);
            end
            %results = cell2mat(results);
            %%%%!!!!ATTENZIONE!!!!!MODIFICATO!!%%%%
        end
        
        % --- training ---
        function addTrainingSignal(this, windowedSignal, windowClassification)
            this.trainingSignals{end+1,1} = windowedSignal;
            this.trainingSignals{end,2} = windowClassification;
        end
        
        function setNeighbourTable(this, neighbours)
            % Utilizzo della tabella neighbours
            % Data la riga r e la colonna c: al filtro di classe r mando
            % neighbours(r,c) segnali di classe c. Se neighbours(r,c) �
            % negativo vengono mandati tutti i segnali di class c
            % disponibili. Quando r = c i segnali vengono mandati come
            % "corretti" (la similarit� con essi deve essere 1), mentre
            % per gli altri casi vengono mandati come "scorretti" (la
            % similarit� con essi deve essere 0)
            %
            % esempio:
            % neighbours = [
            %     1  2  3  4  5  6  7
            %    ------------------------+
            %    -1 10  0  0  0  0  0;  %| 1
            %    5  -1  5  0  0  0  0;  %| 2
            %    0  5  -1  5  0  0  0;  %| 3
            %    0  0  5  -1  5  0  0;  %| 4
            %    0  0  0  5  -1  5  0;  %| 5
            %    0  0  0  0  5  -1  5;  %| 6
            %    0  0  0  0  0  10 -1]; %| 7
            %
            % nella tabella sopra ogni filtro riceve tutti i propri segnali
            % e in pi� riceve 10 segnali dei filtri adiacenti, 5 da quello
            % a destra e 5 da quello a sinistra. Per i filtri limite 1 e 7
            % vengono passati 10 segnali per l'unico filtro adiacente
            % disponibile.
            this.neighbours = neighbours;
        end
        
        function train(this, basicSignals, varargin)
            range = 1:length(this.filters);
            if ~isempty(varargin)
                if length(varargin{1}) == 1
                    range = varargin{1}:varargin{1};
                else
                    range = varargin{1};
                end
            end
            
            % set ideal signal for each non mirror filter
            for i = range
                if ~isa(this.filters{i}, 'MirrorFilter')
                    this.filters{i}.idealSignal = basicSignals(i,:);
                end
            end
            
            % start training
            mirrors = [];
            
            for i = range
                if isa(this.filters{i}, 'MirrorFilter')
                    mirrors(end+1) = i;
                else
                    this.trainFilter(this.filters{i}, i);
                    this.filters{i}.computePrototype();
                end
            end
            
            % mirror filters compute last
            for i = 1:length(mirrors)
                %%%%% aggiunto %%%%%%
                %this.filters{mirrors(i)}.idealSignal = this.filters{i}.idealSignal;
                this.filters{mirrors(i)}.setIdealSignal();
                mirroringParams = this.filters{i}.getParams();
                this.filters{mirrors(i)}.setParams(mirroringParams{2});
                %%%%% fine aggiunta %%%%%%
                this.filters{mirrors(i)}.computePrototype();
            end 
        end
        
    end
    
    methods (Access = public)%%private
        function [windows, otherWindows] = getTrainingWindowsOfClass(this, class)
            windows = [];
            otherWindows = [];
            
            counter = this.neighbours(class,:);
            ideals = zeros(1, length(this.filters));
            for i = 1:size(this.trainingSignals, 1)
                if counter(class) ~= 0
                    indexes = this.trainingSignals{i, 2} == class;
                    if ideals(class) == 0
                        windows = [windows; this.filters{class}.idealSignal]; % uno dei segnali di training � sempre quello ideale
                        counter(class) = counter(class) - 1;
                        ideals(class) = 1;
                    end
                    if counter(class) < 0
                        windows = [windows; this.trainingSignals{i,1}(indexes, :)];
                    else
                        addUpTo = min(max(0, counter(class)), sum(indexes));
                        windows = [windows; this.trainingSignals{i,1}(indexes(1:addUpTo),:)];
                        counter(class) = counter(class) - addUpTo;
                    end
                end
                
                
                for j = [1:class-1, class+1:length(counter)]
                    if counter(j) ~= 0
                        otherIndexes = this.trainingSignals{i,2} == j;
                        if ideals(j) == 0
                            otherWindows = [otherWindows; this.filters{j}.idealSignal]; % uno dei segnali di training � sempre quello ideale
                            counter(j) = counter(j) - 1;
                            ideals(j) = 1;
                        end
                        if counter(j) < 0
                            otherWindows = [otherWindows; this.trainingSignals{i,1}(otherIndexes, :)];
                        else
                            addUpTo = min(max(0, counter(j)), sum(otherIndexes));
                            otherWindows = [otherWindows; this.trainingSignals{i,1}(otherIndexes(1:addUpTo),:)];
                            counter(j) = counter(j) - addUpTo;
                        end
                    end
                end
            end
        end
        
        function trainFilter(this, filter, signalClass)
            prototypeFromStage = filter.getPrototypeFromStage();
            
            % set title
            optimInfo.title = cell2mat(strcat({'Training filter for class '}, num2str(signalClass)));

            % specify objective function
            objFctHandle = @fitness; % will be the similarity check fitness

            % define parameter names, ranges and quantization:

            % 1. column: parameter names
            % 2. column: parameter ranges
            % 3. column: parameter quantizations (0 for no quantization)
            % 4. column: initial values (optional)
            
            bounds = filter.getBounds();
            paramNames = filter.getParamsNames();
            paramDefCell = cell(size(bounds,1), 3);
            for i = 1:size(paramDefCell, 1)
                paramDefCell{i,1} = paramNames{i};
                paramDefCell{i,2} = bounds(i,:);
                paramDefCell{i,3} = 0.01; %0.001
            end
            
            % set initial parameter values in struct objFctParams 
            objFctParams = [];

            % set single additional function parameter (empty cell array if not needed)
            [inputData, otherInputData] = this.getTrainingWindowsOfClass(signalClass);
            objFctSettings = {{filter, prototypeFromStage, inputData, otherInputData}};

            % get default DE parameters
            DEParams = getdefaultparams;
            
            % 0 (false) - generate the initial params in the middle of each
            % parameter bound
            % 1 (true) - use initial values for params taken from
            % objFctParams or paramDefCell (in this order of precedence)
            % 2 - like 1, but add some random noise to the first 20% of the
            % initial population
            DEParams.useInitParams = false;

            % set number of population members (often 10*D is suggested) 
            DEParams.NP = 10 * size(paramDefCell, 1);

            % do not use slave process here
            %DEParams.feedSlaveProc = 1;
            %DEParams.slaveFileDir = 'parallel';

            % set times (stop conditions)
            DEParams.maxiter  = 30;%50;
            DEParams.CR=0.8;
            DEParams.F = 0.7;
            
            DEParams.maxtime  = Inf; % in seconds
            DEParams.maxclock = []; % Time when to finish optimization. Set to empty for no end time.

            % set display options
            DEParams.infoIterations = 10;
            DEParams.infoPeriod     = 10; % in seconds
            DEParams.displayResults = false;
            DEParams.playSound      = false;

            DEParams.strategy = 3;
            % optimization looks for the minumum (true) or maximum (false)
            DEParams.minimizeValue = true;
            
            DEParams.validChkHandle = @parametersValidation;
            %DEParams.saveHistory = false;

            % do not send E-mails
            emailParams = [];

            
            
            clc;
        
            filenameHistory = strcat(this.basePath,'/trainingInfoSignalClass_', num2str(signalClass), '.txt');
            diary(filenameHistory);
        
            diary on;
            
            
            % set random state in order to always use the same population members here
            %setrandomseed(204);
            %setrandomseed(168);
            
            r = round((300-100).*rand(1,1) + 100);
            setrandomseed(r);
            
            % start differential evolution
            [bestmem, bestval, bestFctParams, nrOfIterations, resultFileName] = differentialevolution(...
                DEParams, paramDefCell, objFctHandle, objFctSettings, objFctParams, emailParams, optimInfo,'',this.basePath); %#ok

            disp(' ');
            disp('Best parameter set returned by function differentialevolution:');
            disp(bestFctParams);
            %{
            disp(' ');
            disp('# of training signals used');
            disp(size(inputData,1));
            %}
            
            diary off;
            
            
            save([this.basePath,'/optimizedParametersFirstLayer-',num2str(signalClass),'.mat']);
            
            filter.setParams(bestmem);
            filter.computePrototype();
        end
    end
end

