classdef (Abstract) HasDependencies < handle
    properties ( Abstract = true, Constant )
        DEPENDENCIES 
    end
    
        
    methods ( Access = protected )% public
        
        function passed = checkDependencies( self, varargin )
            %self.checkDependencies  Checks for dependencies
            % 
            %   self.checkDependencies() 
            %     checks for the dependencies in self.DEPENDENCIES
            %   
            %   self.checkDependencies(fid)
            %     prints the results of the check to the file specified by 
            %     fid. To print to stdout, use fid=1, to print to stderr, 
            %     use fid=2.
            %     
            %   If the dependencies are met, self.onDependencyMet is
            %   called, if the dependencies are not met,
            %   self.onDependencyNotMet is called.
            %
            %   See also fprintf
            %
            passed = true;
            fid = NaN;
            if nargin == 2
                fid = varargin{1};
            end
            for dep = self.DEPENDENCIES
                if ~isnan(fid)
                    % @TODO It might be worth trying to color the output.
                    % It is confusing if non-errors are printed in red. But
                    % it's not that important... cprintf from undoc matlab
                    % might help, but would put a dependency to this :)
                    fprintf(fid, 'Checking for %s... ', dep{1}.Name);
                    
                end
                dep{1}.test();
                if ~isnan(fid)
                    fprintf(fid, '%s\n', self.bool2text(dep{1}.HasPassed));
                end
                
                passed = passed && dep{1}.HasPassed;
            end
            if ~isnan(fid); fprintf(fid, '\n'); end
            if ~passed
                self.onDependencyNotMet();
            else
                self.onDependencyMet();
            end
        end
                                    

        function onDependencyMet (self, varargin); end
        
        function onDependencyNotMet( self, varargin )
            warns = {};
            errors = {};
            
            fid = 2;
            
            if nargin == 2; fid = varargin{1}; end
            
            for dep = self.DEPENDENCIES
                if ~dep{1}.HasPassed 
                    if dep{1}.Critical
                        errors{end+1} = struct(...
                            'Name', dep{1}.Name, ...
                            'msg', dep{1}.HelpCallback());
                    else
                        warns{end+1} = struct(...
                            'Name', dep{1}.Name, ...
                            'msg', dep{1}.HelpCallback());
                    end
                end
            end
            
            fprintf(fid, ...
                'There are problems with the dependencies.\n\n');
            if numel(warns) > 0
                fprintf(fid, 'The following non-critical dependencies were not met:\n');
                for w = warns
                    fprintf(fid,'  %s: %s\n', w{1}.Name, w{1}.msg);
                end
                fprintf(fid,'\n');
            end
            if numel(errors) > 0
                fprintf(fid, 'The following critical dependencies were not met:\n');
                for e = errors
                    fprintf(fid,'  %s: %s\n', e{1}.Name, e{1}.msg);
                end
                fprintf(fid,'\n');
                error('phutils:DependenciesNotMet','There are dependency problems. See the help above to fix them.');
            end
            
        end
        
        function txt = bool2text( self, tf )
            if tf; txt = 'OK'; else; txt = 'no'; end
        end
                
        
    end
    
        
    
        
end