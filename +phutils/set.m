function set(obj, varargin)
%phutils.set  Set properties of object
%
% set(obj, p1,v1, p2, v2, ...) set object's property p1 to v1, p2 to v2 ...
%
% Code copied from uix.set from the gui layout toolbox

    if nargin == 1, return, end
    assert( rem( nargin, 2 ) == 1, 'phutils:InvalidArgument', ...
        'Parameters and values must be provided in pairs.' )
    set( obj, varargin{:} )