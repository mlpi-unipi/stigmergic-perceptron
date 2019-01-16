function [ normalizedData ] = normalize01(data, varargin)
%NORMALIZE01 Summary of this function goes here
%   Detailed explanation goes here

    m = min(data);
    M = max(data);

    if ~isempty(varargin)
        m = varargin{1};
        M = varargin{2};
    end

    %{
    if m >= 0 && M <= 1
        % if the signal is alredy in [0,1] return it as is
        normalizedData = data;
    else
        %}
        if m == M
            if M == 0
                % if min = max = 0 the normalized signal will be 0s
                % (avoid NaN on input=[0..0])
                normalizedData = zeros(1,length(data));
            else
                % if min = max but max != 0 (e.g. constant input=[1..1])
                % assume min = 0 and normalize, so max will become 1
                m = 0;
                normalizedData = (data - m) / (M - m);
            end
        else
            % usual normalization
            normalizedData = (data - m) / (M - m);
        end
    %end
end

