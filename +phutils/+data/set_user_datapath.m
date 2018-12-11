function p = set_user_datapath(varargin)
    if nargin == 1
        if exist(varargin{1}, 'dir')
            phutils.set_setting('user_datapath', varargin{1});
            return
        end
    end
    d = uigetdir('Select a data directory');
    if isequal(d, 0)
        return
    end
    phutils.set_setting('user_datapath', d);
    