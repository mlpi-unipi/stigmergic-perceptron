function valid = parametersValidationDelta(settings, params)
%PARAMETERSVALIDATION Summary of this function goes here
%   Detailed explanation goes here

    filters = settings{1};
    parameters = cell2mat((struct2cell(params)));
    
    valid = true;
    
    for i = 1:length(filters)
        valid = valid && filters{i}.checkParams(parameters);
    end
    
end

