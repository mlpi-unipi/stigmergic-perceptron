classdef Filter < handle

    properties %(Access = protected)
        intermediateResults
        paramPerComponent
        prototypeFromStage  % stage number for stigmergic trail
        clumpingFromStage  % stage number for input sigmoid
    end

    properties 
        components
    end

    properties (Access = public)
        idealSignal
        prototype
    end
    
    methods (Access = public)
        function this = Filter()
            this.paramPerComponent = [];
            this.components = {};
        end
        
        
        
        function addComponent(this, component, varargin)
            % varargin has 2 elements:
            % varargin{1} = for stigmergy
            % varargin{2} = for input sigmoid
            
            this.components{end+1} = component;
            component.filter = this;
            this.initParamPerComponent();
            
            if ~isempty(varargin) && varargin{1}
                this.prototypeFromStage = length(this.components);
                
            %%%%%% aggiunto da me %%%%%%    
            
            elseif ~isempty(varargin) && varargin{2}
                this.clumpingFromStage = length(this.components);
                
            %%%%%% fine aggiunta %%%%%%
            end
        end
        
        function stage = getPrototypeFromStage(this)
            stage = length(this.components);
            if ~isempty(this.prototypeFromStage)
                stage = this.prototypeFromStage;
            end
        end
        
        function clumpingStage = getClumpingFromStage(this)
            clumpingStage = length(this.components);
            if ~isempty(this.clumpingFromStage)
                clumpingStage = this.clumpingFromStage;
            end
        end
        
        function output = compute(this, input, varargin)
            stopAtStage = length(this.components);
            if ~isempty(varargin)
                stopAtStage = varargin{1};
            end
            
            this.reset();
            
            this.intermediateResults = cell(length(this.components)+1, 1);
            this.intermediateResults{1} = input;
            
            previousOutput = input;
            for i = 1:stopAtStage
                previousOutput = this.components{i}.apply(previousOutput);
                this.intermediateResults{i+1} = previousOutput;
            end
            output = previousOutput;
        end
        
        function result = getIntermediateResult(this, n)
            if n < 0
                n = 0;
            end
            result = this.intermediateResults{n+1};
        end
        
        function ret = getBounds(this)
            ret = zeros(sum(this.paramPerComponent), 2);
            next = 0;
            for i = 1:length(this.components)
                if this.paramPerComponent(i) ~= 0
                    bounds = this.components{i}.getBounds();
                    ret(next+1:next+this.paramPerComponent(i), :) = bounds(:,:);
                    next = next + this.paramPerComponent(i);
                end
            end
        end
        
        function names = getParamsNames(this)
            names = cell(sum(this.paramPerComponent), 1);
            next = 0;
            for i = 1:length(this.components)
                if this.paramPerComponent(i) ~= 0
                    names(next+1:next+this.paramPerComponent(i)) = strcat('stage', num2str(i), '_', this.components{i}.getParamsNames());
                    next = next + this.paramPerComponent(i);
                end
            end
        end
        
        function setParams(this, params)
            next = 0;
            for i = 1:length(this.components)
                if this.paramPerComponent(i) ~= 0
                    this.components{i}.setParams(params(next+1:next+this.paramPerComponent(i)));
                    next = next + this.paramPerComponent(i);
                end
            end
        end

        function output = getParams(this)
            params = zeros(sum(this.paramPerComponent), 1);
            names = cell(sum(this.paramPerComponent), 1);
            next = 0;
            for i = 1:length(this.components)
                if this.paramPerComponent(i) ~= 0
                    params(next+1:next+this.paramPerComponent(i)) = this.components{i}.getParams();
                    names(next+1:next+this.paramPerComponent(i)) = strcat('stage', num2str(i), '_', this.components{i}.getParamsNames());
                    next = next + this.paramPerComponent(i);
                end
            end

            %output = strcat(names, {': '}, num2str(params));
            output = {names, params};
        end
        
        function valid = checkParams(this, params)
            valid = true;
            next = 0;
            for i = 1:length(this.components)
                if this.paramPerComponent(i) ~= 0
                    valid = valid && this.components{i}.checkParams(params(next+1:next+this.paramPerComponent(i)));
                    next = next + this.paramPerComponent(i);
                end
            end
        end
        
        function reset(this)
            for i = 1:length(this.components)
                this.components{i}.reset();
            end
        end
        
        function computePrototype(this)
            this.prototype = this.compute(this.idealSignal, this.getPrototypeFromStage());
            this.reset();
        end
            
    end
    
    methods (Access = protected)
        function initParamPerComponent(this)
            this.paramPerComponent = zeros(1,length(this.components));
            for i = 1:length(this.components)
                tmp = this.components{i}.getBounds();
                this.paramPerComponent(i) = size(tmp, 1);
            end
        end
    end
    
end

