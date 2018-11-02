classdef CriticalDependency < phutils.dependencies.Dependency
    %CRITICALDEPENDENCY  a critical dependency
    %
    % See also phutils.dependencies.Dependency
    
    
    methods (Access = protected)
        function set_critical(~, val)
            if ~val
                warning('phutils:OptionWasIgnored',...
                    'Setting the option Critical to something different than <true> is not permitted for CriticalDepency. Option was ignored.');
            end
        end
    end
    
end