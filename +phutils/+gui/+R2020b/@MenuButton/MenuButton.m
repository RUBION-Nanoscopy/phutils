classdef MenuButton < phutils.gui.R2020b.MenuBarComponent
    
    
    methods (Access = protected)
        function setup(self)
            self.Grid = uigridlayout(self, [1,1], 'Padding', 0);
            self.Component = uibutton(self.Grid);
        end
        function update(self)
            
        end
    end
end