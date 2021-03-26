classdef MenuSeparator < phutils.gui.R2020b.MenuBarComponent
    
    properties
        Color = '#666666';
        
    end
    methods (Access = protected)
        function setup(self)
            self.Grid = uigridlayout(self, [1,1], 'Padding', 0);
            self.Color = self.BackgroundColor * .75;
            self.Component = uigridlayout(self.Grid, 'Padding', [0 2 0 2], 'BackgroundColor', self.Color);
        end
        function update(self)
            self.Component.BackgroundColor = self.Color;
        end
    end
end