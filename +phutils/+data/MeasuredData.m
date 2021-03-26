classdef MeasuredData < matlab.mixin.SetGet
    
    properties
        xdata
        ydata
        zdata
        
        xdata_unit
        ydata_unit
        zdata_unit
        
        
        
    end
    
    properties (Dependent)
        XUnit
        %YUnit
        %ZUnit
        Values
        ValuesUnit
        X
        % Y
    end
    
    properties ( Access = protected )
        xunit_ = []
        %yunit_ = []
        %zunit_ = []
        values_ = []
        values_unit 
        x_ = []
        % y_ = []
    end
    
    methods ( Abstract )
        plot( self, varargin ); 
    end
    
    methods
        function self = MeasuredData( varargin )
            assert( rem(nargin, 2) == 0, 'phutils:InvalidArgument', ...
                'Parameters and values must be provided in pairs.');
            
            self.set(varargin{:});
        end
        
        function set.XUnit( self, u )
            self.xunit_ = u;
        end
        function u = get.XUnit ( self )
            u = self.xunit_;
        end
        
        function set.Values( self, d )
            self.values_ = d;
        end
        function d = get.Values ( self )
            d = self.values_ ;
        end
        function set.X ( self, x )
            self.x_ = x;
        end
        function x = get.X( self )
            x = self.x_;
        end
        function set.ValuesUnit ( self, vu )
            self.values_unit = vu;
        end
        function vu = get.ValuesUnit( self )
            vu = self.values_unit;
        end
        
        
    end
end