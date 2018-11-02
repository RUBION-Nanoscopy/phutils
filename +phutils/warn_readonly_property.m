function warn_readonly_property( propname, classname, varargin )
%WARN_READONLY_PROPERTY   Warn if one tries to set a pseudo-readonly property
%
%   
%
%   warn_readonly_property( propname, classname )
%      A warning with the ID phutils:CannotSetproperty is thrown
%   warn_readonly_property( id, propname, classname )
%      A warning with the ID <id>:CannotSetproperty is thrown
%
%   The warning message is in both cases:
%     The property <propname> of the instance of class <classname> is
%     readonly.
% 
    id = 'phutils';
    if nargin == 3
        id = propname;
        propname = classname;
        classname = varargin{1};
    end
    warning([id ':CannotSetProperty'], ...
        'The property %s of the instance of class %s is readonly', propname, classname);