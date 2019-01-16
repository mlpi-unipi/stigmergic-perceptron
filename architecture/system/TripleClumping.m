classdef TripleClumping < Component
    
    properties (Access = protected)
        alpha1
        beta1
        alpha2
        beta2
        alpha3
        beta3
        
    end
    
    methods (Access = public)
        function this = TripleClumping(alpha1Min, alpha1Max, beta1Min, beta1Max, ...
            alpha2Min, alpha2Max, beta2Min, beta2Max, ...
            alpha3Min, alpha3Max, beta3Min, beta3Max)
            this.bounds = [alpha1Min, alpha1Max; beta1Min, beta1Max; ...
            alpha2Min, alpha2Max; beta2Min, beta2Max; ...
            alpha3Min, alpha3Max; beta3Min, beta3Max];
        end
        
        function names = getParamsNames(this)
            names = {'alpha1'; 'beta1';'alpha2'; 'beta2';'alpha3'; 'beta3'};
        end
        
        function setParams(this, params)
            this.alpha1 = params(1);
            this.beta1 = params(2);
            this.alpha2 = params(3);
            this.beta2 = params(4);
            this.alpha3 = params(5);
            this.beta3 = params(6);
        end

        function params = getParams(this)
            params = [this.alpha1; this.beta1; this.alpha2; this.beta2; this.alpha3; this.beta3];
        end
        
        function output = apply(this, input)
            output = ThreeStagesSigmoid(input, [this.alpha1 this.beta1 this.alpha2 this.beta2 this.alpha3 this.beta3]);
        end
        
        function valid = checkParams(~, params)
            valid = params(1) < params(2) & ...
                    params(2) < params(3) & ...
                    params(3) < params(4) & ...
                    params(4) < params(5) & ...
                    params(5) < params(6);
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

