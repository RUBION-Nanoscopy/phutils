classdef MenuBar < matlab.ui.componentcontainer.ComponentContainer
    % A pseudo menu bar that can be used in panels or similar
    % Due to the weird method of adding graphical components and the
    % restrictions of MATLAB regarding inheriting from graphical
    % components, it offers a slightly different interface for adding
    % components.
    
    properties
        Spacing = 0;
        Padding = 0;
    end
    
    properties (Access = protected, Transient, NonCopyable)
        Grid matlab.ui.container.GridLayout
        Components phutils.gui.R2020b.MenuBarComponent
    end
    
    methods
        function btn = addButton(self, width, varargin)
            self.extendGrid(width);
            component = phutils.gui.R2020b.MenuButton(self.Grid, 'Width', width);
            btn = component.Component;
            self.Components(end+1) = component;
        end
        function btn = addStateButton(self, width, varargin)
            self.extendGrid(width);
            component = phutils.gui.R2020b.MenuStateButton(self.Grid, 'Width', width);
            btn = component.Component;
            self.Components(end+1) = component;
        end
        function addSeparator(self)
            self.extendGrid(2);
            component = phutils.gui.R2020b.MenuSeparator(self.Grid, 'Width', 2);
            self.Components(end+1) = component;
        end
    
    end
    
    methods (Access = protected)
        function setup(self)
            self.Grid = uigridlayout(self, [1,1], 'Padding', self.Padding, 'ColumnSpacing', self.Spacing);
        end
        
        function update(self)
            self.Grid.Padding = self.Padding;
            self.Grid.ColumnSpacing = self.Spacing;
            if ~isempty(self.Components)
                nComponents = numel(self.Components);
                colWidth = {};
                colWidth(nComponents+1) = {'1x'};
                for k = 1:nComponents
                    colWidth(k) = {self.Components(k).Width};
                end
                self.Grid.ColumnWidth = colWidth;
                for k = 1:nComponents
                    self.Components(k).Layout.Row = 1;
                    self.Components(k).Layout.Column = k;
                end
            end
        end
        
        function extendGrid(self, width)
            self.Grid.ColumnWidth(end) = {width};
            self.Grid.ColumnWidth(end+1) = {'1x'}; 
        end
    end
    
    
end