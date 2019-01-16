classdef Tunable < matlab.mixin.Copyable
    %COMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        bounds
    end
    
    methods (Access = public)
        function this = Tunable()
            this.bounds = [];
        end
        
        function bounds = getBounds(this)
            bounds = this.bounds;
        end
        % Return a Nx2 matrix, where N is the number of parameters of this
        % component. If the component has no parameters an empty matrix
        % will be returned
        
        function setBounds(this, bounds)
            if size(this.bounds, 1) ~= size(bounds,1)
                throw(MException('Training:notEnoughBaseSignals','the number of "bounds" rows must be equal to the number of bounds for this object'));
            end
            if size(bounds, 2) ~= 2
                throw(MException('Training:notEnoughBaseSignals','the number of "bounds" columns must be 2'));
            end
                
            this.bounds = bounds;
        end
        
        function setParams(this, params)
        end
        % Set this component's parameters to the provided values. The order
        % of the parameters in the params vector must match the one in the
        % matrix returned by getBounds()

        function params = getParams(this)
            params = [];
        end
        
        function names = getParamsNames(this)
            paramsNumber = size(this.bounds,1);
            names = cell(paramsNumber,1);
            names = strcat(names, 'param', sprintfc('%d', 1:paramsNumber)');
        end
        
        function valid = checkParams(this, params)
            valid = true;
        end
    end
    
    methods (Access = protected)
        function cpObj = copyElement(obj)
            cpObj = copyElement@matlab.mixin.Copyable(obj); 
        end  
    end
end

