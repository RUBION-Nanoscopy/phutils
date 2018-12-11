function appDir = get_user_applicationdir(appname, local, create)
% GET_USER_APPLICATIONDIR returns a directory where an application can
% store data.
% 
% See also https://de.mathworks.com/matlabcentral/fileexchange/15886-get-application-data-directory


UNIXAPPDIR = ['.local' filesep 'share' filesep 'applications'];
if nargin < 3
    create = false;
end
if nargin < 2
    local = true;
end

if ispc
    if local
        allAppDir = winqueryreg('HKEY_CURRENT_USER',...
            ['Software\Microsoft\Windows\CurrentVersion\' ...
            'Explorer\Shell Folders'],'Local AppData');
    else
        allAppDir = winqueryreg('HKEY_CURRENT_USER',...
            ['Software\Microsoft\Windows\CurrentVersion\' ...
            'Explorer\Shell Folders'],'AppData');
    end
    appDir = fullfile(allAppDir, appname,[]);
else
    homedir = java.lang.System.getProperty('user.home');
    appDir = fullfile(char(homedir), UNIXAPPDIR,  appname);
end
if create
    if ~exist(appDir, 'dir')
        [success, msg, ~] = mkdir(appDir); 
        if ~success
            error('phutils:CannotCreateDirectory', ...
                'Unable to create application data directory\n%s\nDetails: %s', ...
                appDir, msg);
        end
    end
end


