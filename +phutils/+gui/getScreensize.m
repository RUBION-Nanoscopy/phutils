function [sz, varargout] = getScreensize()
% GETSCREENSIZE  Returns the current screensize 
%
%   [w,h] = getScreensize()
%       returns the screensize, w = width, h = height.
%   sz = getScreensize()
%       returns the screensize, sz(1) = width, sz(2) = height
%   
    
    oldunits = get(0, 'Units');
    set(0,'Units','pixels');
    sz = get(0, 'Screensize');
    sz(1:2) = [];
    set(0,'Units',oldunits);
    if nargout == 2
        varargout{1} = sz(2);
        sz(2) = [];
    end
    