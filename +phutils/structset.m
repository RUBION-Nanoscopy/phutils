function struc = structset( struc, varargin )
% STRUCTSET  Sets the field of a struct
%
%  structset( struc, f1,v1, f2,v2,...)
%      Sets field f1 of struct <struc> to v1 and so on. If <struc> already
%      has fields, the values are silently overwritten
%      
%  Note that for simly generating a struct s from a cell array c, the
%  following is easier:
%    
%     s = struct( c{:} );
%
% See also struct, set

    if mod(numel(varargin), 2) ~= 0
        error('phutils:BadSizedArgument',...
            'The arguments must be key-value pairs.'); 
    end
    
    for i=1:2:numel(varargin)
        struc.(varargin{i}) = varargin{i+1};
    end
    
    