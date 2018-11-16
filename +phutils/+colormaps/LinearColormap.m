classdef LinearColormap < handle
    properties (Access = protected)
        length 
        colors
        positions 
    end
    
    methods
        function self = LinearColormap( m )
            self.length = m;
        end
        
        function addColor(self, pos, rgb)
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
            colors = self.colors(idxs,:);
            for i = 1:numel(pos)-1
                for j = 1:3
                    cm(pos(i):pos(i+1),j) = ...
                        linspace(...
                            colors(i,j),colors(i+1,j),...
                            pos(i+1)-pos(i)+1 ...
                        );
                end
            end
        end
    end
end