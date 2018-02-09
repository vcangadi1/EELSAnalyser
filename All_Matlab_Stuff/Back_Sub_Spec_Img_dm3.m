clc;
clear all;
close all;

p_x = 1;
p_y = 1;


[filename, pathname] = uigetfile({'.dm3'},'File Selector');
fullpathname = strcat(pathname,filename);
si_struct = DM3Import(fullpathname);

%si_struct.disp = str2double(regexp(fullpathname,'(\d+(?:\.\d+)?(?=disp))','tokens','once'));
%si_struct.offset = str2double(regexp(fullpathname,'(\d+?(?=off))','tokens','once'));

eels = si_struct.image_data(p_x, p_y, 1:1000);
eels = reshape(eels,1000,1);

fn = InGaAs_fit((1:length(eels)),eels);


x = (1:length(eels));
y = fn(x);

figure;
%subplot(1,2,1)
hold on;
plot(x+350,y);
plot(x+350,eels);

r = eels-y;
figure;
%subplot(1,2,2);
plot(x+350,r);