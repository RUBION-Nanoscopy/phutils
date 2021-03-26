classdef PSFData < handle
    
    properties
        Ax
        XPx
        YPx
        XSize
        YSize
    end
    
    properties(GetAccess = public, SetAccess = protected)
        FWHM
        Data
    end
    properties (Dependent)
        Figure
        Title
    end
    properties (Access = protected)
        Figure_
    end
    
    methods 
        function self = PSFData( fwhm, xpx, ypx, xsize, ysize )
            % Assume that fwhm is given in nanometers, xsize and ysize in
            % micrometers. 
            self.FWHM = fwhm*1e-3; % Convert to Micrometers
            self.XPx = xpx;
            self.YPx = ypx;
            self.XSize = xsize;
            self.YSize = ysize;
            
            self.compute_data();
           
        end
        
        function set.Figure( self, f)
            self.Figure_ = f;
            self.Ax = axes(...
                'Parent', self.Figure_ ...
            );
            if ~isempty(self.Data)
                imagesc(self.Ax, self.Data);
                colormap(hot);
                self.Ax.DataAspectRatio = [self.YSize/self.YPx self.XSize/self.XPx 1];
                self.Ax.XTick = [1 self.XPx];
                self.Ax.XTickLabel = { -1*self.XSize/2 self.XSize/2 };
                self.Ax.YTick = [1 self.YPx];
                self.Ax.YTickLabel = { -1*self.YSize/2 self.YSize/2 };
                xlabel(self.Ax, 'x/µm');
                ylabel(self.Ax, 'y/µm');
            end
        end
        function f = get.Figure( self )
            f = self.Figure_;
        end
        function t = get.Title( self )
            t = self.get_title();
        end
    end
    methods ( Access = protected )
        function compute_data( self )
            cx = self.XPx/2;
            cy = self.YPx/2;
            
            scalex = self.XSize / self.XPx;
            scaley = self.YSize / self.YPx;
            
            [x,y] = ndgrid(1:self.XPx, 1:self.YPx);
            
            self.Data = self.fnc(x,y,cx,cy,self.FWHM/scalex,self.FWHM/scaley)';
            
        end
    end
    methods (Abstract, Access = protected)
        d = fnc(self, x,y,cx,cy,fwhmx,fwhmy)
        get_title(self)
    end
end