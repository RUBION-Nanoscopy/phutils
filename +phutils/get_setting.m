function val = get_setting(key)
%PHUTILS.GET_SETTING Gets a stored setting
%
% PHUTILS offers a simple system to store and retrieve settings. You can
% retrieve setting `key` with the following:
%
%   setting = phutils.get_setting(key);
%
% key must be a valid struct fieldname. If key is not known, [] is
% returned. if `key` is omitted, the full settings struct is returned.
%
% See also: phutils.set_setting phutils.delete_setting
    val = [];
    try
        loaded_data = load(...
            fullfile(...
                phutils.get_user_applicationdir('phutils'),...
                'settings.mat'...
            ), ...
            'phutils_settings'...
        );
    catch
        return
    end
    settings = loaded_data.phutils_settings;
    if nargin > 0
        try 
            val = settings.(key);
        catch
            return
        end
    else
        val = settings;
    end
    