classdef LabeledButtonBox < phutils.gui.LabeledBox
% LABELEDBUTTONBOX A box for buttons with a label for all buttons
%
    properties ( Dependent )
        ButtonSize
    end
    
   
    methods
        function self = LabeledButtonBox( varargin )
            self = self@phutils.gui.LabeledBox();
            self.parentbox = uix.HButtonBox(...
                'Parent', self.inner_box ...
            );
            self.ready = true;
            try
                uix.set( self, varargin{:} )
            catch e
                delete( self )
                e.throwAsCaller()
            end
        end
        
        
        function set.ButtonSize ( self, bs )
            self.parentbox.ButtonSize = bs;
        end
        function bs = get.ButtonSize( self )
            bs = self.parentbox.ButtonSize;
        end
        
    end
    
    methods (Access = protected )
        function w = get_preferred_width( self )
            try
                n = numel( self.parentbox.Children );
                w = n * self.ButtonSize(1) ... 
                    + (n-1) * self.parentbox.Spacing ...
                    + 2 * self.parentbox.Padding;
            catch
                w = self.PreferredWidth_;
            end
        end
        function h = get_preferred_height(self)
            try
                oldu = self.text.Units;
                self.text.Units = 'pixels';
                h = self.ButtonSize(2) + ...
                    + 2 * self.parentbox.Padding ...
                    + self.text.Position(4);
                self.text.Units = oldu;
            catch
                h = self.PreferredHeight_;
            end
        end
    end
    
end