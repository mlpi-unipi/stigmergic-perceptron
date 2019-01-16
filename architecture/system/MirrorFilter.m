classdef MirrorFilter < Filter
    %FILTER Summary of this class goes here
    %   Basic implementation just delegates methods call to the specified
    %   mirrored filter.
    %
    %   WARNING: reset() calls might cause problem when the resetted
    %   component belongs to a different Filter. In that case, override the
    %   reset() method to deal with harmful situations
    
    properties (Access = protected)
        mirroringFilter
    end
    
    methods (Access = public)
        function this = MirrorFilter(mirroringFilter)
            
            this.mirroringFilter = mirroringFilter;
            %%{
            this.paramPerComponent = this.mirroringFilter.paramPerComponent;
            
            this.prototypeFromStage = this.mirroringFilter.prototypeFromStage;
            this.clumpingFromStage = this.mirroringFilter.clumpingFromStage;
            
            for i = 1:length(this.mirroringFilter.components)
                this.addComponent(copy(this.mirroringFilter.components{i}));
            end
            
            %}
        end
        
        %{
        function addComponent(this, component, varargin)
            if ~isempty(varargin)
                this.addComponent(component, varargin{:});
            else
                this.addComponent(component);
            end
        end
        %}
        %{
        function addComponent(this, component, varargin)
            if ~isempty(varargin)
                this.mirroringFilter.addComponent(component, varargin{:});
            else
                this.mirroringFilter.addComponent(component);
            end
        end
        %}
        %{
        function stage = getPrototypeFromStage(this)
            stage = this.mirroringFilter.getPrototypeFromStage();
        end
        
        
        function sigmoidInStage = getSigmoidInFromStage(this)
            sigmoidInStage = this.mirroringFilter.getSigmoidInFromStage();
        end
        %}
        
        function setIdealSignal(this)
            this.idealSignal = 1 - this.mirroringFilter.idealSignal;
        end
        
        function output = compute(this, input, varargin)
            
            if ~isempty(varargin)
                output = compute@Filter(this, 1-input, varargin{:}); % modificato 1-input
            else
                output = compute@Filter(this, 1-input);     % modificato 1-input
            end
        end
        
        %{
        function output = compute(this, input, varargin)
            % backup mirroring filter intermediate results
            intermediateResultsBak = this.mirroringFilter.intermediateResults;
            
            if ~isempty(varargin)
                output = this.mirroringFilter.compute(1-input, varargin{:}); % modificato 1-input
            else
                output = this.mirroringFilter.compute(1-input);     % modificato 1-input
            end
            
            % save computed intermediate results in this filter field
            this.intermediateResults = this.mirroringFilter.intermediateResults;
            % restore original mirror intermediate results
            this.mirroringFilter.intermediateResults = intermediateResultsBak;
        end
        %}
        %{
        function ret = getBounds(this)
            ret = this.mirroringFilter.getBounds();
        end
        
        function names = getParamsNames(this)
            names = this.mirroringFilter.getParamsNames();
        end
        %}
        %%{
        function setParams(this, params)
            
            setParams@Filter(this, params);
            clumpingStage = this.getClumpingFromStage();
            if ~isempty(clumpingStage)
                clumpingParams = this.mirroringFilter.components{clumpingStage}.getParams();
                clumpingParams = [1 - clumpingParams(2), 1 - clumpingParams(1)];
                this.components{clumpingStage}.setParams(clumpingParams);
            end
                 
        end
        %}
        %{
        function output = getParams(this)
            output = this.mirroringFilter.getParams();
        end
        
        function valid = checkParams(this, params)
            valid = this.mirroringFilter.checkParams(params);
        end
        
        function reset(this)
            this.mirroringFilter.reset();
        end
        
        function computePrototype(this)
            this.mirroringFilter.computePrototype();
        end
        %}
    end
    
end

