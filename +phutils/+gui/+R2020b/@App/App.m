classdef App < handle
    % A general App-class that implemnts some common features usefule for
    % all Apps like re-open at last position, display saved/unsaved status
    % etc.
    
    properties (Hidden)
        Figure matlab.ui.Figure
        Grid matlab.ui.container.GridLayout
        FileMenu matlab.ui.container.Menu
        FileMenuNew matlab.ui.container.Menu
        FileMenuOpen matlab.ui.container.Menu
        FileMenuSave matlab.ui.container.Menu
        FileMenuSaveAs matlab.ui.container.Menu
        FileMenuClose matlab.ui.container.Menu
        FileMenuQuit matlab.ui.container.Menu
        
        
    end
    properties (SetObservable, Hidden)
        FileName = strings(0);
        IsDirty = false;
        IsAutomaticFilename = true;
    end
    properties (Abstract, Constant)
        AppName
        AppVersionMajor
        AppVersionMinor 
    end
    properties (Access = protected, Dependent)
        AppString
    end
    methods 
        function self = App()
            self.setup();
        end
        function s = get.AppString(self)
            s = sprintf('%s (v%i.%i)', ...   
                self.AppName, self.AppVersionMajor, self.AppVersionMinor);  
        end
    end
    
    methods (Access = protected)
        function setup(self)
            self.Figure = uifigure('Visible', 'off', ...
                'Name', self.AppString, ...
                'CloseRequestFcn', @(~,~)self.close ...
            );
            self.Grid = uigridlayout(self.Figure);
            self.Figure.Position = self.getLastPosition();
            self.FileMenu = uimenu(self.Figure, 'Text', '&File');
            self.FileMenuNew = uimenu(self.FileMenu, 'Text', 'New', 'Accelerator', 'N');
            self.FileMenuOpen = uimenu(self.FileMenu, 'Text', 'Open file...', 'Accelerator','O');
            self.FileMenuSave = uimenu(self.FileMenu, 'Text', 'Save file', 'Accelerator','S');
            self.FileMenuSaveAs = uimenu(self.FileMenu, 'Text', 'Save file as...');
            self.FileMenuClose = uimenu(self.FileMenu, 'Text', 'Close file', 'Accelerator','W');
            self.FileMenuQuit = uimenu(self.FileMenu, 'Text', 'Quit application', ...
                'Accelerator', 'X', 'Separator', 'on', ...
                'MenuSelectedFcn', @(~,~)self.close);
            
            addlistener(self, 'FileName', 'PostSet', @self.setup_name);
            addlistener(self, 'IsDirty', 'PostSet', @self.setup_name);
        end
        
        
        function setup_name(self, ~,~)
            if (self.IsDirty)
                dirty = '*';
            else
                dirty = '';
            end
           
            
            if ~isempty(self.FileName)
                self.Figure.Name = sprintf('%s: %s%s', ...
                    self.AppString, self.FileName, dirty);
                    
            else
                self.Figure.Name = sprintf('%s%s', ...
                    self.AppString, dirty);
            end
                
        end
        function close(self, varargin)
            if ~self.IsDirty || self.confirmClose()
                self.save_position();
                delete(self.Figure);    
            end
            
            
                
            
        end
        
        function tf = confirmClose(self)
            res = uiconfirm(self.Figure, ...
                'Data has not been saved. Really quit?', ...
                'Confirm quit', ...
                'Icon', 'warning', ...
                'Options',{'Save','Lose changes','Cancel'}, ...
                'DefaultOption', 1, ...
                'CancelOption', 3);
            switch res 
                case 'Save'
                    tf = false;
                case 'Lose changes'
                    tf = true;
                case 'Cancel'
                    tf = false;
            end
                    
               
        end
        
        function setSetting(self, setting, value)
            
            sname = matlab.lang.makeValidName(self.AppName);
            s = settings();
            if ~hasGroup(s, sname)
                addGroup(s, sname);
            end
            if ~hasSetting(s.(sname), setting)
                addSetting(s.(sname), setting);
            end
            s.(sname).(setting).PersonalValue = value;
        end
        
        function v = getSetting(self, setting, default)
            v = default;
            sname = matlab.lang.makeValidName(self.AppName);
            s = settings();
            
            if hasGroup(s, sname)
                if hasSetting(s.(sname), setting)
                    v = s.(sname).(setting).PersonalValue;
                end
            end
        end
        
        function p = getLastPosition(self)
            p = self.getSetting('LastPosition', self.Figure.Position);
        end
        function save_position(self)
            self.setSetting('LastPosition', self.Figure.Position);
            
        end
    end
end