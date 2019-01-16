classdef Component < Tunable
    %COMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = {?Filter, ?Component})
        filter
    end
    
    methods (Abstract)
        output = apply(this, input);
        % Apply the transformation defined by this component to the imput
    end
    
    methods (Access = public)
        function reset(this)
        end
    end
    
    
     methods (Access = protected)
        function cpObj = copyElement(obj)
            cpObj = copyElement@Tunable(obj); 
            prop = properties(obj);
            for i = 1:length(prop)
               cpObj.(prop{i}) = obj.(prop{i});
            end
        end  
        
     end
    
end

