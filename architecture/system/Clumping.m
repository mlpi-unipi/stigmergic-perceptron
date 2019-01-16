classdef Clumping < Component
    
    properties (Access = protected)
        alpha
        beta
    end
    
    methods (Access = public)
        function this = Clumping(alphaMin, alphaMax, betaMin, betaMax)
            this.bounds = [alphaMin, alphaMax; betaMin, betaMax];
        end
        
        function names = getParamsNames(this)
            names = {'alpha'; 'beta'};
        end
        
        function setParams(this, params)
            this.alpha = params(1);
            this.beta = params(2);
        end

        function params = getParams(this)
            params = [this.alpha; this.beta];
        end
        
        function output = apply(this, input)
            output = zeros(size(input));
            for i=1:size(input,1)
                output(i,:) = smf(input(i,:), [this.alpha this.beta]);
            end
        end
        % The input is expected to be a MxN matrix, where M can be 1
        
        function valid = checkParams(~, params)
            valid = params(1) < params(2);
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
         end
      end
    end
    
end

