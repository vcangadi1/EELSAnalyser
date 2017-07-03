clc
clear
close all
%%

directory_name = uigetdir;
files = dir(directory_name);

fileIndex = find(~[files.isdir]);
S = 0;
B = 0;
for i = 1:length(fileIndex)
    fileName = strcat('eelsdb/',files(fileIndex(i)).name);
    fprintf('%s\n',fileName);
    EELS = MSAImport(fileName);
end