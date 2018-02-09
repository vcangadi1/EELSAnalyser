clc
clear all;

[filename, pathname] = uigetfile({'.dm3'},'File Selector');
fullpathname = strcat(pathname,filename);

si_struct = DM3Import( 'fullpathname' );
%EELS_spectrum = si_struct.image_data(1,1,:);

%N = size(si_struct.image_data,3);
%EELS = reshape(EELS_spectrum,1,N).';