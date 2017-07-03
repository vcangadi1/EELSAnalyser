function set_RGB (obj,event)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global handles RGB data

[l m l] = size(data);
%True color menu
R = str2num(get(handles(39), 'string'));
R = max(min(R,l),1);
G = str2num(get(handles(41), 'string'));
G = max(min(R,l),1);
B = str2num(get(handles(43), 'string'));
B = max(min(R,l),1);

RGB = [R G B];

end

