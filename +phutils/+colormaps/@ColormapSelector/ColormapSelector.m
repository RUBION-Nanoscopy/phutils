classdef ColormapSelector < uiw.abstract.WidgetContainer
    properties
        Axes (1,1) = NaN % the axes the colormap of which should be changed
        OnColormapSelected (1,1) = NaN% An optional callback that is called when the colormap is selected. 
    end
    
    properties (SetAccess = protected, GetAccess = public)
        isStandalone (1,1) logical = false % Indicates whether the widget is standalone
        Figure(1,1)
    end
    methods 
        function self = ColormapSelector(varargin)
            self = self@uiw.abstract.WidgetContainer();
            self.assignPVPairs(varargin{:});
            er = false;
            try
                er = isnan(self.Axes) && isnan(self.OnColormapSelected);
            catch e
            end
            if er
                error('Please provide either an axis or a callback');
            end
            
            self.create();
            self.IsConstructed = true;
            if isempty(self.Parent)
                self.isStandalone = true;
                self.Figure = figure('Toolbar','none','Menubar','none', 'Numbertitle','off');
                f = self.find_figure();
                if ~isempty(f)
                    self.Figure.Name = sprintf('Colormap Selector for %s', f.Name);
                else
                    self.Figure.Name = 'Colormap Selector';
                end
                self.Figure.Position(3:4) = [300 600];
                self.Parent = self.Figure;
            end
        end
    end
    
    methods (Access = protected)
        function create( self )
            self.hLayout.ScrollPanel = uix.ScrollingPanel('Parent', self.hBasePanel);
            self.hLayout.Container = uix.Panel('Parent', self.hLayout.ScrollPanel);
            self.hLayout.MainVBox = uix.VBox('Parent', self.hLayout.Container, 'Spacing', 5);
            
            maps = enumeration('phutils.colormaps.ColormapList');
            
            d = repmat(1:256,16,1);
            for map = maps'
                hb = uix.HBox('Parent', self.hLayout.MainVBox);
                uix.Text('Parent',hb, 'String', char(map), 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
                ax = axes(hb); %#ok<LAXES>
                ax.Position(4) = 35;
                ax.Visible = 'off';
                ax.Toolbar.Visible='off';
                ax.XTick = [];
                ax.YTick = [];
                img = imagesc(ax, d);
                ax.Colormap = map.Map;
                hb.Widths=[100, -1];
                img.ButtonDownFcn = @(h,e)self.onClick(map);
            end
            
            self.hLayout.MainVBox.Heights = ones(1,numel(maps))*30;
            self.hLayout.Container.Position(4) = numel(maps)*30;
            self.hLayout.ScrollPanel.Heights = numel(maps)*35-5;
        end
        function redraw(self)
            
        end
        function onClick( self, map )
            if isa(self.OnColormapSelected, 'function_handle')
                self.OnColormapSelected(map);
            else
                self.Axes.Colormap = map.Map;
            end
        end
        
        function f = find_figure(self)
            f = self.Axes;
            while ~isa(f, 'matlab.ui.figure')
                try
                    f = f.Parent;
                catch e
                    f = [];
                    return
                end
            end
        end
    end
end

