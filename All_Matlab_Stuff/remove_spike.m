function SS = remove_spike(spectrum, FilterOption, filter_window)



%%
if nargin<2
    FilterOption = 'default';
end

%%
switch FilterOption
    case 'median'
        SS = medfilt1(spectrum,filter_window);
    case {'average', 'averaging','mean', 'smooth'}
        SS = smooth(spectrum,filter_window);
    otherwise %'default'
        SS = hampel(spectrum);
end