classdef Data2D < phutils.data.MeasuredData
%DATA2D represent a data measurement with x- and y-values.
%
% Usage: 
%    d = phutils.data.Data2D(key, val)
%

    methods
        function p = plot( self, varargin )
            p = plot(self.X, self.Values, varargin{:});
        end
    end
end