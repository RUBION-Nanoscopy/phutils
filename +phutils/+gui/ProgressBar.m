classdef ProgressBar < matlab.mixin.SetGet
%PROGRESSBAR  Quick'n'dirty implementaion of a Progressbar.
%
% prgbar = phtuils.gui.ProgressBar(p1,v1,p2,v2,...)
%      Creates a ProgressBar with p1 set to v2, p2 to v2 etc. For valid
%      values for the properties see below. ProgressBar creates a figure
%      with one axes in this case. The ProgressBar fills (more or less) the
%      full figure.
%
% prgbar = phutils.gui.Porgressbar(ax, ___);
%      Creates a Progressbar in the axis specified by ax.
%
%   Valid Parameters:
%    
%   IncbarColor: (rgb) Color for the increasing part of the bar.
%   DecbarColor: (rgb) Color for the decreasing part of the bar.
%   IncbarBorderColor: (rgb) BorderColor for the increasing part.
%   DecbarBorderColor: (rgb) BorderColor for the decreasing part.
%   Label: (string-like) Text shown in the center of the bar. Note that
%          manually specifying a label set Autolabel to false
%   AutoLabel: (true|false) If true, the Labl is automatically updated.
%              Defaults to true.
%   AutoLabelFormat: format string (for sprintf) used to format the
%                    automatic label. Defaults to '%3.1g%%'
%   Fraction: (0<= Fraction <=1) Fraction of prgress shown. You can use
%             this to update the bar. Defaults to 0.
%   XPadding: (0<=xpadding < .5 || xpadding >=1) Padding from left and
%             right side of the axis. If XPadding < 1, the padding is 
%             interpreted as fraction of the axis (not figure!) width.
%             Defults to 0.
%   YPadding: (number) Distance from the bottom axis. If YPadding < 1, the
%             padding is interpreted as fraction of the axis height. Note:
%             In Contrast to XPadding, this padding is not applied to the
%             top part. Defaults to 0.
%   Height: (number) height of the progress bar. If Height < 1, it is
%           interpreted as fraction of the axis height.
%   
%   Parameters used only when called without parent axes
%
%   Width: Specifies the width of the generated figure;
%   Title: Specifies the Title of the generated figure. Defaults to
%          "Progress".
%
    properties (Dependent)
        IncbarColor
        DecbarColor
        IncbarBorderColor
        DecbarBorderColor
        Label
        Fraction
        Width
        Height
        
        XPadding
        
    end
    
    properties (SetObservable)
        YPadding = 0
        AutoLabelFormat = '%3.1f%%';
        Title = 'Progress';
        AutoLabel = true;
    end
    
    properties (SetAccess = protected, GetAccess = public, Dependent)
        BarPosition_Data 
        
    end
    
    properties (SetAccess = protected, GetAccess = public, SetObservable)
        XPadding_
        Fraction_ = 0
        Width_ = 1/3
        Height_ = 48
    end
        
    properties (SetAccess = protected, GetAccess = public)%protected) 
        Parent
        IncBar
        DecBar
        Label_ 
        
        
        Figure = NaN;
        
        AutomaticParent = false;
        
        inStartProgress = true
        oldmodes = {}
        oldunits = {}
        
    end
    
    
    
    methods 
        function self = ProgressBar( varargin )
            argstart = 1;
            if nargin > 0 && isa(varargin{1}, 'matlab.graphics.axis.Axes')
                self.Parent = varargin{1};
                varargin(1) = [];
            end
            self.generateComponents();
            
            try
                phutils.set( self, varargin{argstart:end} )
            catch e
                delete(self)
                e.throwAsCaller();
            end
            if self.AutomaticParent 
                self.updateFigure();
            end
            self.updateBar();
            
            % set Listener
            
            for prop = {'Fraction_', 'YPadding', 'XPadding_', 'Height_'}
                self.addlistener(prop{1}, 'PostSet', @(src,evt)self.updateBar());
            end
            self.inStartProgress = false;
            if self.AutomaticParent 
                self.Figure.Visible = 'on';  
            end
        end
        
        function delete ( self )
            self.restoreAxLims();
            delete(self.IncBar);
            delete(self.DecBar);
            delete(self.Label_);
            % disp(self.Parent)
            if self.AutomaticParent
                if ishandle(self.Parent) 
                    delete(self.Parent)
                end
                if ishandle(self.Figure)
                    delete(self.Figure);
                end
            end
            delete(self);
                
        end
    end %Con-/Destructor
    
    
    methods % getter/setter
        function col = get.IncbarColor ( self )
            col = self.IncBar.FaceColor;
        end
        function set.IncbarColor ( self, col )
            self.IncBar.FaceColor = col;
        end
        
        function col = get.DecbarColor ( self )
            col = self.DecBar.FaceColor;
        end
        function set.DecbarColor ( self, col )
            self.DecBar.FaceColor = col;
        end
        
        function col = get.IncbarBorderColor ( self )
            col = self.IncBar.EdgeColor;
        end
        function set.IncbarBorderColor ( self, col )
            self.IncBar.EdgeColor = col;
        end
        
        function col = get.DecbarBorderColor ( self )
            col = self.DecBar.EdgeColor;
        end
        function set.DecbarBorderColor ( self, col )
            self.DecBar.EdgeColor = col;
        end
        function txt = get.Label( self )
            txt = self.Label_.String;
        end
        function set.Label( self, txt )
            self.Label_.String = txt;
        end
        
        function f = get.Fraction( self )
            f = self.Fraction_;
        end
        function set.Fraction( self, f )
            self.Fraction_ = f;
        end
        
        function w = get.Width( self )
            w = self.Width_;
        end
        function set.Width( self, w )
            self.Width_ = w;
        end
        function h = get.Height( self )
            h = self.Height_;
        end
        function set.Height( self, h )
            self.Height_ = h;
        end
        function set.XPadding( self, pdx) 
            if ~((pdx >= 0 && pdx < .5) || pdx >= 1)
                error('phutils:BadArgument', 'XPadding can be only between 0 and 0.5 or larger or equal to 1.\nYou tried to set it to %g', pdx);
            end
            self.XPadding_ = pdx;
        end        
        function xp = get.XPadding( self )
            xp = self.XPadding_;
        end
        function set.BarPosition_Data( self, ~ )
            phutils.warn_readonly_property('BarPosition_Data', class(self));
        end
        function bwd = get.BarPosition_Data( self )
            %
            
            self.setUnits2PX();
            axP = self.Parent.Position;
            self.restoreUnits();
            
            % Compute paddings in PX, if necessary
            xPd = self.XPadding;
            if xPd < 1; xPd = xPd * axP(3); end
            yPd = self.YPadding;
            if yPd < 1; yPd = yPd * axP(4); end
            
            % Compute Height in PX, if necessary
            h = self.Height;
            if h < 1; h = h* axP(4); end
            
            xscale = diff(self.Parent.XLim)/axP(3);
            yscale = diff(self.Parent.YLim)/axP(4);
            
            bwd = [xPd*xscale yPd*yscale (axP(3)-2*xPd)*xscale h*yscale];
            

        end
        
    end % getter/setter
    
    
    methods (Access = protected)%
        function generateComponents( self )
            if isempty(self.Parent)
                % No parent given, create figure and axes.
                f = figure(...
                    'MenuBar','none', ...
                    'ToolBar', 'none', ...
                    'Units','pixels',...
                    'NumberTitle', 'off',...
                    'Visible','off' ...
                );
                    
            
                self.Parent = axes(...
                    'Parent', f, ...
                    'Units','normalized', ...
                    'Position', [0 0 1 1], ...
                    'Visible','off', ...
                    'Xlim', [0 1],...
                    'YLim', [0 1] ... 
                );
            
                self.Figure = f;
                self.AutomaticParent = true;
                self.XPadding = 0;
                self.YPadding = 0;
            end
            
            % generate incbar
            
            self.setAxLimsManual();

            self.IncBar = patch( self.Parent, ...
                'Faces', [1 2 3 4], ...f.Position = [
                'Vertices', [0 0; 0 1; 1 1; 1 0], ...
                'FaceColor', [0 .65 0] ... % Default color is hardcoded! Shame on me!
            );
        
            % Get system default bg color
            
            self.DecBar = patch( self.Parent, ...
                'Faces', [1 2 3 4], ...
                'Vertices', [0 0; 0 1; 1 1; 1 0], ...
                'FaceColor', phutils.gui.getDefaultPanelBG() ... % Default color is hardcoded! Shame on me!
            );
        
            
            
            
            % Put the text somewhere...
            self.Label_ = text(self.Parent, 0, 0, '', 'HorizontalAlignment', 'center');
        
        
        end % generateComponents
        
        function updateFigure( self )
            if ~self.AutomaticParent; return; end
            
            f = self.Figure;
            
            [scW, scH] = phutils.gui.getScreensize();
            
            if self.Width < 1
                w = scW * self.Width;
            else
                w = self.Width;
            end
            if self.Height < 1
                h = scH * self.Height;
            else
                h = self.Height;
            end
            
            y = (scH - h) / 2;
            x = (scW - w) / 2;
            
            f.Position = [x y w h];
            f.Name = self.Title;
        end % updatefigure
        
        function updateBar(self)
            
            barpos = self.BarPosition_Data;
            
            
            % update left of Inc
            self.IncBar.Vertices(1:2,1) = barpos(1);
            % update right of Dec
            self.DecBar .Vertices(3:4,1) = barpos(1)+barpos(3);
            
            % update bottom of both
            self.IncBar.Vertices([1,4],2) = barpos(2);
            self.DecBar.Vertices([1,4],2) = barpos(2);
            
            % update height of both
            self.IncBar.Vertices(2:3,2) = barpos(2) + barpos(4);
            self.DecBar.Vertices(2:3,2) = barpos(2) + barpos(4);
            
            fr_data = barpos(3) * self.Fraction;
            
            self.IncBar.Vertices(3:4, 1) = barpos(1) + fr_data;
            self.DecBar.Vertices(1:2, 1) = barpos(1) + fr_data;
            
            % Since padding might have changed, update the text position,
            % too
            
            self.updateLabelPos();
            self.updateLabel();
            
            drawnow();
            
        end % updateBar
        
        function updateLabel(self)
            if self.AutoLabel
               self.Label = sprintf(self.AutoLabelFormat, self.Fraction*100);
               % restore self.AuoupdateLabel
               self.AutoLabel = true;
            end
                
        end
        
        function updateLabelPos( self )
            self.Label_.Position(2) = self.DecBar.Vertices(1,2) + (self.DecBar.Vertices(3,2) - self.DecBar.Vertices(1,2) )/2;
            self.Label_.Position(1) = self.IncBar.Vertices(1,1) + (self.DecBar.Vertices(4,1) - self.IncBar.Vertices(1,1) )/2;            
        end
        function setAxLimsManual(self)
            self.oldmodes = {self.Parent.XLimMode, self.Parent.YLimMode};
            self.Parent.XLimMode = 'manual';
            self.Parent.YLimMode = 'manual';
        end % setAxLimsManual
        function restoreAxLims(self)
            try
                self.Parent.XLimMode = self.oldmodes{1};
                self.Parent.YLimMode = self.oldmodes{2};
            catch
            end
        end % restoreAxLims
        
        function setUnits2PX( self )
            self.oldunits = {...
                self.Parent.Parent.Units, ...
                self.Parent.Units ...
            };
            self.Parent.Parent.Units = 'pixels';
            self.Parent.Units = 'pixels';
        end
        function restoreUnits( self )
            try
                self.Parent.Parent.Units = self.oldunits{1};
                self.Parent.Units = self.oldunits{2};
            catch
            end
        end
    end % protected methods
end

