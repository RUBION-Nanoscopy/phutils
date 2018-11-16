function h = hotandblue(m)
%HOT    Red-yellow-white color map with last value set to blue for showing
%       out-of-colormap values
%   HOTANDBLUE(M) returns an M-by-3 matrix containing a "hotandblue" colormap.
%   HOTANDBLUE, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB uses the length of the
%   default colormap.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(hotandblue)
%
%   See also HSV, PARULA, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT.

%   Code adapted from hot.m

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

k = m-1;

cm = phutils.colormaps.LinearColormap(k);
cm.addColor(1/3, [1 0 0 ]);
cm.addColor(2/3, [1 1 0 ]);

h = cm.getCM();

h(end+1,:) = [0 0 1];
