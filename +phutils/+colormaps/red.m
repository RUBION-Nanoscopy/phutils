function cm = red(m)
%RED    Red color map.
%   RED(M) returns an M-by-3 matrix containing a "red" colormap.
%   RED, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB uses the length of the
%   default colormap.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(red)
%
%   See also HOT, HSV, PARULA, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT.

%   Code adapted from hot colormap


if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

z = zeros(m,1);
r = (0:m-1)'/max(m-1,1);
cm = [r z z];