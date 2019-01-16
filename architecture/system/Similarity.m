classdef Similarity < Component
    %SIMILARITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        strategy
        dtwWin
    end

    methods (Access = public)
        
        function this = Similarity(varargin)
            if nargin == 2 
              
               this.strategy = varargin{1};
               this.dtwWin = varargin{2};
               
            else
                if nargin == 0
                  this.strategy = 1;  
                else
                  this.strategy = varargin{1};
                end
            end
        end
        
        function similarity = apply(this, data)
            
            switch this.strategy
                case 1
                    
                  similarity=  sum(sum(min(data, this.filter.prototype)))/(sum(sum(max(data, this.filter.prototype))));
                case 2 
                  %DTW DISTANCE CONVERTED TO SIMILARITY
                  similarity = 1/(1+(dtw(data,this.filter.prototype,this.dtwWin)^(1/3)));
                case 3 
                  %FRECHET DISTANCE CONVERTED TO SIMILARITY
                  similarity = 1/(1+(DiscreteFrechetDist(data,this.filter.prototype)));  
                        
            end
            
            
			%similarity = trapz(min(data, this.filter.prototype)) / trapz(max(data, this.filter.prototype));
        end
    end
    
end

