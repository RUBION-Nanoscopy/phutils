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

rgb = zeros(m,3);
p = fix(m*[1 10 12 17 38 62 64]/64);
rp = [20 32 97 212 255 255 255]/255;
gp = [190 8 24 43 153 255 255]/255;
bp = [200 0 0 0 0 0 255]/255;

for i=1:numel(p)-1
    rgb(p(i):p(i+1),1) = linspace(rp(i),rp(i+1),p(i+1)-p(i)+1); 
    rgb(p(i):p(i+1),2) = linspace(gp(i),gp(i+1),p(i+1)-p(i)+1); 
    rgb(p(i):p(i+1),3) = linspace(bp(i),bp(i+1),p(i+1)-p(i)+1); 
end

i = rgb;
