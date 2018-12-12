function cm = magenta(m)
%MAGENTA    Magenta color map.
%   MAGENTA(M) returns an M-by-3 matrix containing a "magenta" colormap.
%   MAGENTA, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB uses the length of the
%   default colormap.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(magenta)
%
%   See also HOT, HSV, PARULA, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT.

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end
cm = phutils.colormaps.red(m)+phutils.colormaps.blue(m);