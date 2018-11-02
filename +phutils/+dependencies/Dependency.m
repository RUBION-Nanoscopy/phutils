classdef Dependency < matlab.mixin.SetGet
% DEPENDENCY  Defines a dependency to some package or similar
%
% dep = Dependency(p1, v1, p2,v2, ...) generates a dependency
%
%   Options
%     TestCallback: Callback to a methods that performs the test. The
%                   method should return true or false
%     HelpCallback: Callback tha treturns a help text for the user if the
%                   test fails. May also provide ways to solve the problem
%                   (for example by installing the required package)
%     MsgIdentifier: Identifier for the warning/error thrown if test fails.
%                    Default 'phutils:DependencyNotMet'
%     Critical:     Throws an error if true, otherwise throws a warning.
%                   Defaults to true
%     Silent:       If true, no error or warning is thrown if the test
%                   fails. Helpfuls if one wants to test multiple
%                   dependencies befor notifying the user. Default true
%
%  dep.test()
%     tests if the dependency is met by calling the TestCallback. Throws
%     an error/warning if not dep.Silent, depending on dep.Critical
%
%  dep.WasTested: True if dep.test was called, false otherwise
%  dep.HasPassed: True if the dependeny is met, false otherwise. 
%
% See also phutils.CriticalDependency
    
    properties (Dependent)
        Critical  % If critical, an error is thrown, otherwise a warning
        TestCallback % Callback which does the test
        HelpCallback % Callback to show a hint to the user if the test fails
        MsgIdentifier % Identifier to throw if test fails
       
        Silent% Throw error or warning if test failed?
    end
    
    properties ( SetAccess = private, GetAccess = public )
        Name
        WasTested = false;% Was this dependency tested?
        HasPassed % Was test succesful?
    end
    
    properties ( SetAccess = protected, GetAccess = private )
        Critical_ = true
        TestCallback_ 
        HelpCallback_
        Silent_ = true
        MsgIdentifier_ = 'phutils:DependencyNotMet'
    end
    
    methods % constructor
        function self = Dependency ( name, varargin )
            self.Name = name;
            % Set properties
            try
                phutils.set( self, varargin{:} )
            catch e
                delete( self )
                e.throwAsCaller()
            end
            
            
        end
    end
    
    methods
        function varargout = test(self)
            self.HasPassed = self.TestCallback();
            self.WasTested = true;
            if ~self.HasPassed && ~self.Silent
                if ~ self.Critical
                    warning(self.MsgIdentifier, self.HelpCallback());
                else
                    error(self.MsgIdentifier, self.HelpCallback());
                end
            end
            if nargout == 1
                varargout{1} = self.HasPassed;
            end
        end
    end
    
    methods % setter/getter
        function c = get.Critical( self )
            c = self.Critical_;
        end
        
        function set.Critical( self, val )
            % allows to override the setter for Critical 
            self.set_critical(val);
        end
        
        function cb = get.TestCallback( self )
            cb = self.TestCallback_;
        end
        function set.TestCallback( self, cb )
            self.set_testcallback( cb )
        end
        
        function cb = get.HelpCallback( self )
            cb = self.HelpCallback_;
        end
        function set.HelpCallback ( self, cb )
            self.set_helpcallback( cb );
        end
        
        function id = get.MsgIdentifier( self )
            id = self.MsgIdentifier_;
        end
        function set.MsgIdentifier ( self, id )
            self.set_msgidentifier( [id 'ab']);
        end
        
        function val = get.Silent( self )
            val = self.Silent_;
        end
        function set.Silent ( self, val )
            self.set_silent( val );
        end
    end
    
    methods ( Access = protected )
        function set_critical(self, val)
            % override this to implement an "always critical" dependency
            self.Critical_ = val;
        end
        
        function set_testcallback ( self, cb )
            % override this to implement a fixed callback
            self.TestCallback_ = cb;
        end
        
        function set_helpcallback ( self, cb )
            % override this to implement a fixed callback
            self.HelpCallback_ = cb;
        end
        function set_silent ( self, silent )
            % override this to implement a fixed callback
            self.Silent_ = silent;
        end
        function set_msgidentifier ( self, msgid )
            % override this to implement a fixed callback
            self.MsgIdentifier_ = msgid;
        end
    end % protected methods
end