classdef NormalizedSimilarity < Component
    properties
        centers
        epsilon
    end
    
    methods (Access = public)
        function this = NormalizedSimilarity(centers)
            this.centers = centers;
            %this.epsilon = 0.25; %(centers(1)-centers(0))/2;
        end
        
        function similarity = apply(this, data)
            for i = 1 : length(this.centers)-1
                lim_min = this.centers(i);
                lim_max = this.centers(i+1);
                max_seg = max(max(data(lim_min:lim_max)), max(this.filter.prototype(lim_min:lim_max)));
                if max_seg == 0
                    localPrototype(lim_min:lim_max) = 0;
                    data(lim_min:lim_max) = 0;
                else
                    localPrototype(lim_min:lim_max) = this.filter.prototype(lim_min:lim_max)/max_seg;
                    data(lim_min:lim_max) = data(lim_min:lim_max)/max_seg;
                end
            end
            
            similarity = sum(sum(min(data, localPrototype)))/(sum(sum(max(data, localPrototype))));
			%similarity = trapz(min(data, this.filter.prototype)) / trapz(max(data, this.filter.prototype));
        end
    end
    
end

