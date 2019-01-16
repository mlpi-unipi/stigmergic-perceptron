classdef TrapezoidalMark < Mark
    %TrapezoidalMark Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        epsilon
    end
    
    methods (Access = public)
        function this = TrapezoidalMark(epsilonMin, epsilonMax)
            this.bounds = [epsilonMin, epsilonMax];
            this.maxHeight = 1;
        end
        
        function names = getParamsNames(this)
            names = {'epsilon'};
        end
        
        function setParams(this, params) 
            this.epsilon = params(1);
        end

        function params = getParams(this)
            params = [this.epsilon];
        end
        
        function mark = getMark(this, center, domain)
            %mark = this.maxHeight * trimf(domain,[center - this.epsilon, center, center + this.epsilon]);
            mark = this.maxHeight * trapmf(domain,[center - this.epsilon, center - 2*this.epsilon/3, center + 2*this.epsilon/3, center + this.epsilon]);
        end
    end
    
    methods (Access = protected)
      function cpObj = copyElement(obj)
         % Copy super_prop
         cpObj = copyElement@Mark(obj);
         % Copy sub_prop1 in subclass
         % Assignment can introduce side effects
         prop = properties(obj);
         for i = 1:length(prop)
            cpObj.(prop{i}) = obj.(prop{i});
         end
      end
   end
    
end

