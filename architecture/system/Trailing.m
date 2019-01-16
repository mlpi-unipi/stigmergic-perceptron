classdef Trailing < Component
    %Trailing Summary of this class goes here
    %   Detailed explanation goes here
    %
    % this implementation doesn't allow to deposit more than one mark
    % per step. This should not be a problem, however to add this
    % capability it suffice to pass the index of the step like in the
    % original Space class
    
    properties (Access = private)
        delta
        mark
    end
    
    properties (Access = public)
        domain
        codomain
    end
    
    methods (Access = public)
        function this = Trailing(deltaMin, deltaMax, domainMin, domainMax, domainResolution, mark)
            this.bounds = [deltaMin, deltaMax];
            this.domain = domainMin:domainResolution:domainMax;
            this.codomain = zeros(1, length(this.domain));
            this.mark = mark;
        end
        
        function bounds = getBounds(this)
            bounds = [this.bounds; this.mark.getBounds()];
        end
        
        function names = getParamsNames(this)
            names = ['delta'; this.mark.getParamsNames()];
        end

        function params = getParams(this)
            params = [this.delta; this.mark.getParams()];
        end
        
        function setParams(this, params)
            this.delta = params(1);
            this.mark.setParams(params(2:end));
        end
        
        function setBounds(this, bounds)
            setBounds@Component(this, bounds(1,:));
            this.mark.setBounds(bounds(2,:));
        end
        
        function output = apply(this, input)
            for i = 1:length(input)
                this.step(input(i));
            end
            output = this.codomain(end,:);
        end
        
        function reset(this)
            this.codomain = zeros(1, length(this.domain));
        end
        
        function maxAchivable = getSaturation(this, samplePerWindow)
            maxAchivable = this.mark.maxHeight * (1 - this.delta.^(samplePerWindow+1)) / (1 - this.delta);
        end
    end
    
    methods (Access = private)
        function depositMark(this, pos)
            this.codomain(end,:) = this.codomain(end,:) + this.mark.getMark(pos, this.domain);
        end
        
        function evaporate(this)
            %this.codomain(end+1,:) = this.codomain(end,:) * this.delta;
            %this.codomain(end+1,:) = max(0, this.codomain(end,:) + this.mark.maxHeight * (-1 + this.delta));
            this.codomain(end+1,:) = max(0, this.codomain(end,:) - this.mark.maxHeight * this.delta);
        end
        
        function step(this, pos)
            this.evaporate();
            this.depositMark(pos);
        end
    end
    
    methods (Access = protected)
      function cpObj = copyElement(obj)
         % Copy super_prop
         cpObj = copyElement@Component(obj);
         % Copy sub_prop1 in subclass
         % Assignment can introduce side effects
         prop = properties(obj);
         for i = 1:length(prop)
            cpObj.(prop{i}) = obj.(prop{i});
            cpObj.mark = copy(obj.mark);
         end
      end
   end
    
end

