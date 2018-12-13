classdef LabeledButtonBox < uix.HBox
% NAMEDBUTTONBOX A box for buttons with a label for all buttons
%
    properties ( Dependent )
        Label
        LabelBackgroundColor
        LabelColor
        LabelFontSize
    end
    
    properties %(Access = protected)
        bbox
        text
        
    end
    properties (SetAccess = private)
        ready = false
    end
    methods
        function self = LabeledButtonBox( varargin )
            bg = phutils.gui.getDefaultPanelBG()*.75;
            fg = phutils.gui.getDefaultPanelBG()*.25;
            
            vb = uix.VBox( 'Parent', self );
            self.bbox = uix.HButtonBox(...
                'Parent', vb ...
            );
            self.text = uix.Text(...
                'Parent', vb, ...  
                'BackgroundColor', bg, ...
                'ForegroundColor', fg, ...
                'String', self.Label_ ...
            );
            uix.Empty('Parent', self);
            try
                uix.set( self, varargin{:} )
            catch e
                delete( self )
                e.throwAsCaller()
            end
            self.ready = true;
            self.Widths=[0 -1];
            vb.Heights=[36, 16];
        end
       
        function set.Label(self, l)
            self.text.String = l;
        end
        function l = get.Label(self)
            l = self.text.String;
        end
        
        function set.LabelBackgroundColor( self, c )
            self.text.BackgroundColor = c;
        end
        function c = get.LabelBackgroundColor( self )
            c = self.text.BackgroundColor;
        end
        
        function set.LabelColor ( self, c )
            self.text.ForegroundColor = c;
        end
        function c = get.LabelColor ( self )
            c = self.text.ForegroundColor;
        end
    end
    
    methods (Access = protected )
        function addChild(self, child)
            if ~self.ready
                addChild@uix.HBox(self, child)
            else
                child.Parent = self.bbox;
                n = numel(self.bbox.Children);
                self.Widths = [ ...
                  n * self.bbox.ButtonSize(1) ...
                + (n-1) * self.bbox.Spacing ...
                + 2 * self.bbox.Padding, ...
                -1 ...
            ];
            end
        end
        function redraw( self )
            
            redraw@uix.HBox(self);
        end
    end
    
end