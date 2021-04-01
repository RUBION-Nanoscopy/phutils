classdef LinearColormap < handle
%LINEARCOLORMAP   generates a linear colormap
%
% Usage:
%    cm = LINEARCOLORMAP(m) generates a m-by-3 colormap
%    
%    cm.addColor(pos, [r g b]);
%       adds the color specified by r g b to the colormap. pos should be a
%       relative position. To add at position n (with n<=m) use
%       cm.addColor(n/m, ...). If not color is specified for pos=0, black
%       is selected, if no color is specified for pos=1, white is selected.
%
%    cmap = cm.getCM();
%       returns the colormap.
%
%    cm.saveAs(filename)
%       saves the colormap as a custom colormap in the namespace
%       phutils.colormaps.custom. <filename> should be a valid matlab
%       function identifier that starts with a lowercase letter
%
% See also: phutils.colormaps.tools.rewriteColormapList 

    properties (SetAccess = protected, GetAccess = public)
        length 
        colors
        positions 
    end
    
    methods
        function self = LinearColormap( m )
            % Generate a LinearColormapObject of size m
            self.length = m;
        end
        
        function addColor(self, pos, rgb)
            % add a color to the colormap
            %
            % Usage:
            %     
            if any(self.positions == pos)
                self.colors(self.positions == pos,:) = rgb;
            else
                self.colors(end+1,:) = rgb;
                self.positions(end+1) = pos;
            end
            
        end
        
        function cm = getCM(self)
            if ~any(self.positions == 0)
                self.addColor(0, [0 0 0]);
            end
            if ~any(self.positions == 1)
                self.addColor(1, [1 1 1]);
            end
            sorted = sort(self.positions);
            idxs = zeros(numel(sorted),1);
            for i = 1:numel(sorted)
                idxs(i)= find(self.positions == sorted(i));
            end
            cm = zeros(self.length, 3);
            pos = fix(self.positions(idxs) * (self.length-1) ) + 1; 
            colors = self.colors(idxs,:); %#ok<PROP>
            for i = 1:numel(pos)-1
                for j = 1:3
                    cm(pos(i):pos(i+1),j) = ...
                        linspace(...
                            colors(i,j),colors(i+1,j),...
                            pos(i+1)-pos(i)+1 ...
                        ); %#ok<PROP>
                end
            end
        end
        
        function saveAs(self, filename)
            % save the current colormap as
            % phutils.colormaps.custom.<filename>
            
            if strcmp(filename(1), upper(filename(1)))
                error('phutils:WrongArgument', 'Wrong argument type: First letter of filename must be lowercase');
            end
            fn = mfilename('fullpath');
            parts = strsplit(fn, filesep);
            path = fullfile(filesep, parts{1:end-1}, '+custom');
            
            if exist(path, 'dir') ~= 7
                mkdir (path);
            end
            
            classFilename = [upper(filename(1)) filename(2:end)];
            classpath = [path filesep '@' classFilename];
            if exist(classpath, 'dir') ~= 7
                mkdir(classpath);
            end
            fid = fopen(fullfile(classpath, [classFilename '.m']),'w');
            fprintf(fid, 'classdef %s < phutils.colormaps.LinearColormap\n', classFilename);
            fprintf(fid, '    methods\n');
            fprintf(fid, '        function self = %s(m)\n', classFilename);
            fprintf(fid, '            if nargin < 1\n');
            fprintf(fid, '                f = get(groot,''CurrentFigure'');\n');
            fprintf(fid, '                if isempty(f)\n');
            fprintf(fid, '                    m = size(get(groot,''DefaultFigureColormap''),1);\n');
            fprintf(fid, '                else\n');
            fprintf(fid, '                    m = size(f.Colormap,1);\n');
            fprintf(fid, '                end\n');
            fprintf(fid, '            end\n');
            fprintf(fid, '            self = self@phutils.colormaps.LinearColormap(m);\n'); 
            for i = 1:numel(self.positions)
                fprintf(fid, '            self.addColor(%d, [%d %d %d]);\n', self.positions(i), self.colors(i,:)); 
            end
            fprintf(fid, '        end\n');
            fprintf(fid, '    end\n');
            fprintf(fid, 'end\n');
            fclose(fid);
            
            
            fid = fopen(fullfile(path, [filename '.m']),'w');
            fprintf(fid, 'function map = %s (m)\n', filename);
            fprintf(fid, '    if nargin < 1\n');
            fprintf(fid, '        f = get(groot,''CurrentFigure'');\n');
            fprintf(fid, '        if isempty(f)\n');
            fprintf(fid, '            m = size(get(groot,''DefaultFigureColormap''),1);\n');
            fprintf(fid, '        else\n');
            fprintf(fid, '            m = size(f.Colormap,1);\n');
            fprintf(fid, '        end\n');
            fprintf(fid, '    end\n');
            fprintf(fid, '\n');
            fprintf(fid, '    cm = phutils.colormaps.custom.%s(m);\n', classFilename);
            fprintf(fid, '    map = cm.getCM();\n');    
            fprintf(fid, 'end');
            fclose(fid);
            phutils.colormaps.tools.rewriteColormapList();
        end
    end
end