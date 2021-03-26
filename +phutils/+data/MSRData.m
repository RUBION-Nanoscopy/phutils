classdef MSRData < handle
    properties
        Ax
        Meta
        
    end
    properties ( Dependent )
        Figure
    end
    
    properties ( SetObservable )
        Data
    end
    
    properties ( Access = protected )
        Figure_
    end
    
    methods 
        function self = MSRData ( data )
            self.Data = data;
        end
        
        function f = get.Figure( self )
            f = self.Figure_;
        end
        function set.Figure( self, f)
            self.set_figure(f);
        end
    end
    
    methods ( Access = protected )
        function set_figure ( self, f)
            self.Figure_ = f;
            self.Ax = axes('Parent', self.Figure_ );
            if ~isempty(self.Data)
                self.show_data();
            end
            self.Figure_.UserData = struct();
            self.Figure_.UserData.Listener = addlistener( ...
                self, 'Data', 'PostSet', ...
                @(src, evt) self.show_data ...
            );
        end
        
        function show_data( self )
            imagesc(self.Ax, self.Data);
            colormap(hot);
            self.Ax.DataAspectRatio = [1 1 1];
        end
    end
end