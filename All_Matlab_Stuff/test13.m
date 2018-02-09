clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );
EELS_spectrum = si_struct.image_data(1,1,:);
EELS_spectrum = reshape(EELS_spectrum,1,1024).';
D = si_struct.zaxis.scale;
yaxis = smooth(EELS_spectrum,15);
%xaxis = ((1:1024).*D -56+78).';
xaxis = (1:1:1024).';
for m=1:1023,
    dy = yaxis(m+1) - yaxis(m);
    dx = xaxis(m+1) - xaxis(m);
    temp = (atan(dy/dx).*180/pi);
    if(temp<=0)
        ang(m) = NaN;
    else 
        ang(m) = temp;
    end
end
ang(m+1) = ang(m);

block = 0;
window = 1;
wsize = 32;
while(block*window+wsize<1024)
    strt = block*window+1;
    stp = block*window+wsize;
    edge(block+1) = edgedetect(strt,stp,ang);
    block = block+1;
end

flag = 0;
for m=1:length(edge),
    if(edge(m)~=0)
        if(flag == 0)
            disp(edge(m));
            ed(m)=1;
            flag=1;
        end
    else
        flag = 0;
        ed(m)=0;
    end
end

k=1;
for m=1:length(ed),
    if(ed(m)>0)
        ed1(k)=m;
        k=k+1;
    end
end

ne = length(ed1);
ed_c = zeros(size(ed1)).';
for m=1:ne,
    [minval,ind] = min( EELS_spectrum(ed1(m)-10:ed1(m)+10));
    ed_c(m) = (ed1(m)-10+ind-1);
end

disp(ed_c);
%figure;
%plot(xaxis,ang*20,'-r')
%hold on
%plot(xaxis,EELS_spectrum,'LineWidth',2)
%plot(xaxis,45,'LineWidth',3)
%stem(ed*2000,'-r','LineWidth',1)
%grid on