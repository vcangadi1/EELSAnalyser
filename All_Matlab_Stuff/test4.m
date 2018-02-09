% For example, one can load and display a file with the appropriate
% scaled axes in nanometers and electrons with the following example script:

close all;
clear all;
clc

dm3struct = DM3Import( 'C:\Users\elp13va.VIE\Dropbox\MATLAB\InGaAs_Vn1061_11+1612014\SI Survey Image 4' );
N = length( dm3struct.image_data );
imagesc( (1:N).*dm3struct.xaxis.scale, (1:N).*dm3struct.yaxis.scale, ...
    dm3struct.image_data.*dm3struct.intensity.scale );
