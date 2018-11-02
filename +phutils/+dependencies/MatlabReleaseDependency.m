classdef MatlabReleaseDependency < phutils.dependencies.Dependency
    %MATLABRELEASEDEPENDENCY  Tests for running on a specific Matlab
    %release (or above)
    %
    % dep = MatlabReleaseDependency(2018,'a') will generate a Dependency
    % that test for the release 2018a or above.
    %
    % See also phutils.dependencies.Dependency
    
    properties ( SetAccess = private )
        Year 
        AB 
    end
    
    methods 
        function self = MatlabReleaseDependency( year, ab, varargin )
            self = self@phutils.dependencies.Dependency(...
                sprintf('Matlab R%g%s', year, ab));
            
            
            self.Year = year;
            self.AB = ab;
            
            self.TestCallback_ = @self.check;
            self.HelpCallback_ = @self.help;
            try
                phutils.set( self, varargin{:} )
            catch e
                delete( self )
                e.throwAsCaller()
            end
            
        end
        
    end
    
    methods (Access = protected)
        function set_helpcallback( ~, ~ )
            warning('phutils:OptionWasIgnored', ...
                'Changing the help callback of MatlabReleaseDependency is not permitted.');
        end
        function set_testcallback( ~, ~ )
            warning('phutils:OptionWasIgnored', ...
                'Changing the test callback of MatlabReleaseDependency is not permitted.');
        end
        
        function yn = check(self)
            v = release_version;
            y = str2double(v(2:5));
            ab = v(6);
            
            % most simple first:
            if y > self.Year; yn = true; return; end
            if y < self.Year; yn = false; return; end
            
            if strcmp(self.AB, ab); yn = true; return; end
            yn = strcmp(ab,'b');
                
                
            
        end
        
        function txt = help(self)
            txt = sprintf('Matlab release R%g%s is required, but you are running %s.',...
                self.Year, self.AB, release_version);
        end
    end
    
    
    
    
end