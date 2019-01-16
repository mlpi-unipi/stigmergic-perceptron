classdef DoubleClumping < Component
    
    properties (Access = protected)
        alpha
        beta
        gamma
        lambda
    end
    
    methods (Access = public)
        function this = DoubleClumping(alphaMin, alphaMax, betaMin, betaMax, ...
                gammaMin, gammaMax, lambdaMin, lambdaMax)
            this.bounds = [alphaMin, alphaMax; betaMin, betaMax; ...
                gammaMin, gammaMax; lambdaMin, lambdaMax];
        end
        
        function names = getParamsNames(this)
            names = {'alpha'; 'beta'; 'gamma'; 'lambda'};
        end
        
        function setParams(this, params)
            this.alpha = params(1);
            this.beta = params(2);
            this.gamma = params(3);
            this.lambda = params(4);
        end

        function params = getParams(this)
            params = [this.alpha; this.beta; this.gamma; this.lambda];
        end
        
        function output = apply(this, input)
            output = doubleSigmoid(input, [this.alpha this.beta, ...
            this.gamma this.lambda]);
        end
        
        function valid = checkParams(~, params)
            valid = params(1) < params(2) & ...
                    params(2) < params(3) & ...
                    params(3) < params(4);
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

