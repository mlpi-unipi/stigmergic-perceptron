classdef Mark < Tunable
    %MARK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (GetAccess = public, SetAccess = protected)
        maxHeight
    end
    
    methods (Abstract)
        getMark(this, center, domain);
    end
    
    methods (Access = public)
        function names = getParamsNames(this)
            paramsNumber = size(this.bounds,1);
            names = cell(paramsNumber,1);
            names = strcat(names, 'markParam', sprintfc('%d', 1:paramsNumber)');
        end
    end
    
    
     methods (Access = protected)
        function cpObj = copyElement(obj)
             % Copy super_prop
             cpObj = copyElement@Tunable(obj);
             % Copy sub_prop1 in subclass
             % Assignment can introduce side effects
             prop = properties(obj);
             for i = 1:length(prop)
                cpObj.(prop{i}) = obj.(prop{i});
             end
        end
     end
end

