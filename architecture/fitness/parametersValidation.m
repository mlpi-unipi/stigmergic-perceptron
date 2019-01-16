function valid = parametersValidation(mng, params)
%PARAMETERSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

    system = mng{1};
    parameters = cell2mat((struct2cell(params)));
    
    valid = system.checkParams(parameters);
    
end

