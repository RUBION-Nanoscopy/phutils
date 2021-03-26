classdef UIWidget < handle & uiw.mixin.AssignPVPairs
    % UIWidget  Abstract Base class for widget for uifigures
    %
    % An UIWidget provides a Label, which can be positioned and formatted
    %
    properties(Dependent)
        Label % (optional) The Label for the widget
        LabelPosition % two-character, first for horizontal {lcr}, second for vertical position {tmb}
        LabelFontName % Font Family for the label
        LabelFontWeight % FontWeight for the label
        LabelFontSize % FontSize for label
        LabelFontColor % FontColor for label
        LabelHeight % Height of row for label
        LabelWidth % Width of col for label
        Parent % Parent of the widget
        
    end
    
    properties ( Access = protected )
        Label_ % Internal store for Label 
        LabelPosition_ = 'tl' % Internal store for LabelPosition
        LabelFontName_ % Internal store for font name
        LabelFontWeight_ % Internal store for font name
        LabelFontColor_ % Internal store for font name
        LabelFontSize_ % Internal store for font name
        LabelWidth_  = 100;
        LabelHeight_ = 30;
        Parent_
        
        OuterGrid
        Grid
        UILabel
        
        IsConstructing
        
    end
    
    
    methods
        %% Constructor
        function self = UIWidget( varargin )
            
            % Derived classes should set this to false at the end of the
            % Constructor
            self.IsConstructing = true;
            
            
            self.assignPVPairs( varargin{:} );
            
            % if parent is not set, create a new uifigure
            if isempty(self.Parent)
                self.Parent = uifigure();
            end
            
            % create a 3x3 grid in the Parent
            
            self.OuterGrid = uigridlayout(self.Parent, [3 3]);
            self.OuterGrid.RowHeight = {0, '1x', 0};
            self.OuterGrid.ColumnWidth = {0, '1x', 0};
            self.Grid = self.generate_grid();
            
            self.create();
            
        end
    end
    
    methods (Abstract, Access = protected)
        % Derived classes must implement this method, used to populate the
        % gui
        create( self )
    end
    
    methods
        %% Getter / Setter
        
        function set.Parent(self, p)
            self.Parent_ = p;
            self.set_grid_parent(p);
        end
        function p = get.Parent(self)
            p = self.Parent_;
        end
        
        function set.LabelPosition(self, pos)
            if ~any(strcmp(pos, {'tl','tc', 'tr', 'bl', 'bc', 'br', 'lt', 'lm', 'lb', 'rt', 'rm', 'rb'}))
                error('phutils:WrongArgument', 'LabelPosition mus be one of ''tl'',''tc'', ''tr'', ''bl'', ''bc'', ''br'', ''lt'', ''lm'', ''lb'', ''rt'', ''rm'', ''rb''');
            end
            self.LabelPosition_ = pos;
            self.update_label();
        end
        function pos = get.LabelPosition(self)
            pos = self.LabelPosition_;
        end
        
        function set.Label(self, l)
            self.Label_ = l;
            self.update_label();
        end
        function l = get.Label(self)
            l = self.Label_;
        end
        
        function set.LabelWidth( self, w )
            self.LabelWidth_ = w;
            self.update_label();
        end
        function w = get.LabelWidth( self )
            w = self.LabelWidth;
        end
        
        function set.LabelHeight( self, h )
            self.LabelHeight_ = h;
            self.update_label();
        end
        function h = get.LabelHeight( self )
            h = self.LabelHeight_;
        end
        
        function set.LabelFontSize( self, s )
            self.LabelFontSize_ = s;
            self.update_label();
        end
        function s = get.LabelFontSize( self )
            s = self.LabelFontSize_;
        end
        
        function set.LabelFontWeight( self, w )
            self.LabelFontWeight_ = w;
            self.update_label();
        end
        function w = get.LabelFontWeight( self )
            w = self.LabelFontWeight_;
        end
        
        function set.LabelFontName( self, n )
            self.LabelFontName_ = n;
            self.update_label();
        end
        function n = get.LabelFontName( self )
            n = self.LabelFontName_;
        end
        
        function set.LabelFontColor( self, c )
            self.LabelFontColor_ = c;
            self.update_label();
        end
        function c = get.LabelFontColor( self )
            c = self.LabelFontColor_;
        end
    end
    
    methods (Static)
        function [args, pargs] = splitArguments( varargin )
            p = find(strcmp(varargin, 'Parent') == 1);
            if ~isempty(p)
                pargs = {'Parent', varargin{p+1}};
                args = { varargin{1:p-1}, varargin{p+2:end} };
            else
                pargs = {};
                args = varargin;
            end
        end
    end
    
    methods (Access = protected)
        function grid = generate_grid(self)
            grid = uigridlayout(self.OuterGrid, [1 1]);
            grid.Layout.Row = 2;
            grid.Layout.Column = 2;
        end
        
        function set_grid_parent( self, p)
            if ~isempty( self.OuterGrid )
                self.OuterGrid.Parent = p;
            end
        end
        
        function update_label( self )
            if isempty(self.Label); return; end
            
            if isempty(self.UILabel)
                self.UILabel = uilabel(self.OuterGrid);
                % set the default font properties for the label, if empty
                % modifiy internals directly to avoid recursion
                for what = {'Name', 'Size', 'Color', 'Weight'}
                    if isempty(self.(sprintf('LabelFont%s_', what{1})))
                        self.(sprintf('LabelFont%s_', what{1})) = self.UILabel.(sprintf('Font%s', what{1}));
                        
                    end
                end
            end
            
            self.UILabel.Text = self.Label;
            
            % set font properties
            for what = {'Name', 'Size', 'Color', 'Weight'}
                self.UILabel.(sprintf('Font%s', what{1})) = self.(sprintf('LabelFont%s', what{1}));
            end

            self.OuterGrid.RowHeight = {0, '1x', 0};
            self.OuterGrid.ColumnWidth = {0, '1x', 0};
            align_horizontally = false;
            align_vertically = false;
            switch self.LabelPosition(1)
                case 't'
                    self.UILabel.Layout.Row = 1;
                    self.OuterGrid.RowHeight(1) = {30};
                    align_horizontally = true;
                    self.UILabel.VerticalAlignment = 'bottom';
                case 'r'
                    self.UILabel.Layout.Column = 3;
                    align_vertically = true;
                    self.OuterGrid.ColumnWidth(3) = {100};
                    self.UILabel.HorizontalAlignment = 'left';
                case 'l'
                    self.UILabel.Layout.Column = 1;
                    align_vertically = true;
                    self.OuterGrid.ColumnWidth(1) = {100};
                    self.UILabel.HorizontalAlignment = 'right';
                case 'b'
                    self.UILabel.Layout.Row = 3;
                    align_horizontally = true;
                    self.OuterGrid.RowHeight(3) = {30};
                    self.UILabel.VerticalAlignment = 'top';
            end
            
            if align_horizontally
                self.UILabel.Layout.Column = 2;
                
                switch self.LabelPosition(2)
                    case 'c'
                        self.UILabel.HorizontalAlignment = 'center';
                    case 'l'
                        self.UILabel.HorizontalAlignment = 'left';
                    case 'r'
                        self.UILabel.HorizontalAlignment = 'right';
                end
            end
            if align_vertically
                self.UILabel.Layout.Row = 2;
                switch self.LabelPosition(2)
                    case 't'
                        self.UILabel.VerticalAlignment = 'top';
                    case 'm'
                        self.UILabel.VerticalAlignment = 'center';
                    case 'b'
                        self.UILabel.VerticalAlignment = 'bottom';
                end
            end
        end
    end
end