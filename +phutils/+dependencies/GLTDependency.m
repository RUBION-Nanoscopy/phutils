classdef GLTDependency < phutils.dependencies.CriticalDependency
    %GLTDEPENDENCY  test for the existance of the GUIU layout toolbox
    %
    % The GUI Layout Toolbox is available from 
    % https://de.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox
    %
    % See also phutils.dependencies.Dependency.
    
    properties
        Version = NaN;
    end
   
    
    methods
        function self = GLTDependency( varargin )
            self = self@phutils.dependencies.CriticalDependency('GUI Layout toolbox');
            try
                phutils.set( self, varargin{:} )
            catch e
                delete( self )
                e.throwAsCaller()
            end
            
            self.HelpCallback_ = @self.help;
            self.TestCallback_ = @self.check;
        end
    end % constructors/destructors
    
    methods ( Access = protected )
        function set_helpcallback( ~, ~ )
            warning('phutils:OptionWasIgnored', ...
                'Changing the help callback of GLTDependency is not permitted.');
        end
        function set_testcallback( ~, ~ )
            warning('phutils:OptionWasIgnored', ...
                'Changing the test callback of GLTDependency is not permitted.');
        end
        
        function yn = check( ~ )
            % We test for the existance of uix.Box
            yn = ~~exist('uix.Box', 'class');
        end
        function txt = help( ~ )
             txt = 'The GUI Layout Toolbox is required. Install it from https://de.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox.';
        end
    end
end
    
    