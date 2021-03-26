classdef MSRPreview < handle
% MSRPReview  Loads and provides imformation about a msr file
    
    properties
        Filename
        SeriesCount
        SeriesPlanesCount
        TotalPlanesCount
        Ax
    end
    
    properties (Dependent)
        Figure
    end

    properties ( Access = protected )
        ome_reader
        Figure_
    end
    
    properties ( SetObservable )
        CurrentPreview = [0 0]
    end
    
    methods
        function self = MSRPreview( filename )
            self.Filename = filename;
            
            self.ome_reader = bfGetReader();
            self.ome_reader = loci.formats.Memoizer( self.ome_reader );
            
            self.ome_reader.setId(filename);

            % Provide the content information
            self.SeriesCount = self.ome_reader.getSeriesCount();
            self.SeriesPlanesCount = zeros(self.SeriesCount,1);
            
            for series = 0:self.SeriesCount - 1 % It uses java-indexing!
                self.ome_reader.setSeries(series);
                self.SeriesPlanesCount(series+1) = self.ome_reader.getImageCount();
            end
            
            self.TotalPlanesCount = sum(self.SeriesPlanesCount);
            self.ome_reader.close();
        end
        
        function d = getCurrentData( self, sz )
            self.ome_reader.setId(self.Filename);
            self.ome_reader.setSeries(self.CurrentPreview(1));
            data = bfGetPlane(self.ome_reader, self.CurrentPreview(2) + 1); % Uses MATLAB indexing
            d = data;
            self.ome_reader.close();
        end
        
        function changePreview( self, direction )
            if direction == -Inf
                self.CurrentPreview = [0 0];
            elseif direction == +Inf
                self.CurrentPreview = [self.SeriesCount - 1, self.SeriesPlanesCount(end) - 1];
            elseif direction > 0
                n_planes = self.SeriesPlanesCount(self.CurrentPreview(1)+1);
                if self.CurrentPreview(2) + 1 < n_planes
                    self.CurrentPreview(2) = self.CurrentPreview(2) + 1;
                elseif self.CurrentPreview(1) + 1 < self.SeriesCount
                    self.CurrentPreview=[self.CurrentPreview(1) + 1, 0];
                else
                    self.CurrentPreview = [0 0];
                end
            elseif direction < 0
                if self.CurrentPreview(2) > 0
                    self.CurrentPreview(2) = self.CurrentPreview(2) - 1;
                elseif self.CurrentPreview(1) > 0
                    
                    self.CurrentPreview=[self.CurrentPreview(1) - 1, (self.SeriesPlanesCount(self.CurrentPreview(1))-1) ];
                    
                else
                    self.CurrentPreview = [self.SeriesCount - 1, self.SeriesPlanesCount(end)-1];
                end
                
            end
        end
        
        function f = get.Figure( self )
            f = self.Figure_;
        end
        
        function set.Figure( self, f )
            self.set_figure(f);
        end
    end
    
    methods (Access = protected)
        function set_figure( self, f )
            self.Figure_ = f;
            self.Figure_.UserData = struct();
            self.Figure_.UserData.Listener = addlistener(...
                self, 'CurrentPreview', 'PostSet', ...
                @(src, evt) self.update ...
            );
        end
        
        function update( self )
            imagesc(self.Ax, self.getCurrentData());
            self.Ax.DataAspectRatio = [1 1 1];
        end
    end
    
end