function [hsp] = GatanRead()

[filename, pathname] = uigetfile({'*.elp';'*.dm3';'*.*'},'File Selector');


disp(filename);
disp(pathname);
