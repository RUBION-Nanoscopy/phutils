classdef Data3D < phutils.data.MeasuredData
%DATA3D represent a data measurement with x- and y- and zvalues.
%
% Usage: 
%    d = phutils.data.Data3D(key, val)
%

    properties (Dependent)
        Y
        YUnit
    end
    
    properties(Access = protected)
        y_ = []
        yunit_ 
    end

    methods
        function p = plot( self, varargin )
            p = imagesc( self.Values, varargin{:});
        end
        
        
        function set.Y ( self, y )
            self.y_ = y;
        end
        
        function y = get.Y( self )
            y = self.y_;
        end
        
        function set.YUnit( self, yu )
            self.yunit_ = yu;
        end
        function yu = get.YUnit( self )
            yu = self.yunit_;
        end
        
        
    end
end