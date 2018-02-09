function set_grey_scale(obj,event)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global handles RGB data

[l m l] = size(data);
%Grey scale menu
G = str2num(get(handles(46), 'string'));
G = max(min(G,l),1);
RGB = G;

end

