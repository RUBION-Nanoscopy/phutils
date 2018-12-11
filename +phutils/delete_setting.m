function tf = delete_setting(varargin)
%PHUTILS.DELETE_SETTING Deletes a stored setting
%
% PHUTILS offers a simple system to store and retrieve settings. You can
% delete setting `key1`, `key2`, ... with the following:
%
%   tf = phutils.delete_setting(key1, key2, ...);
%
% key must be a valid struct fieldname. the function returns a matrix of
% length nargin with boolean values, indicating whjether the delete was
% successful.
%
% See also: phutils.set_setting phutils.set_setting

tf = false(1, nargin);
phutils_settings = phutils.get_setting();
if isempty(phutils_settings)
    return
end

for i = 1:nargin
    if isfield(phutils_settings, varargin{i})
        phutils_settings = rmfield(phutils_settings, varargin{i});
        tf(i) = true;
    end
end

save(...
        fullfile(...
            phutils.get_user_applicationdir('phutils'),...
            'settings.mat'...
        ), ...
        'phutils_settings' ...
    );


