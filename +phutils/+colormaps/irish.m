function i = irish(m)
%IRISH    "Irish" color map as used in Thatenhorst et al., 2014 [1]
%   IRISH(M) returns an M-by-3 matrix containing an "irish" colormap.
%   IRISH, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB uses the length of the
%   default colormap.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(irish)
%
%   [1] DOI: 10.1021/ac5024414
%
%   See also HSV, PARULA, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT, PHUTILS.COLORMAP.

%   Code adapted from hot.m

% Idx/RGB-Colors:

% 1: 20 190 200
% 10: 32 8 0
% 12: 97 24 0
% 17: 212 43 0
% 38: 255 153 0
% 62: 255 255 0
% 64: 255 255 255

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

cm = phutils.colormaps.Irish(m);


i = cm.getCM();
