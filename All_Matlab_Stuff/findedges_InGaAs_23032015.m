
%si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );

function [ed_c] = findedges_InGaAs_23032015(si_struct)

D = si_struct.zaxis.scale;
N = size(si_struct.image_data,3);
EELS_spectrum = si_struct.EELS_spectrum;
%EELS_spectrum = reshape(EELS_spectrum,1,N).';

yaxis = smooth(EELS_spectrum,15);
%yaxis = EELS_spectrum;
%xaxis = ((1:N).*D -56+78).';
xaxis = (1:1:N).';
for m=1:N-1,
    dy = yaxis(m+1) - yaxis(m);
    dx = xaxis(m+1) - xaxis(m);
    temp = (atan(dy/dx).*180/pi);
    if(temp<=0)
        ang(m) = temp;
    else
        ang(m) = temp;
    end
end
ang(m+1) = ang(m);
avgang = sum(ang)./length(ang);

%figure;
%plot(EELS_spectrum);
%hold on;
%plot(ang*1000,'.r','LineWidth',3);
save('ang.mat','ang');

block = 0;
window = 1;
wsize = si_struct.sensitivity;
while(block*window+wsize<N)
    strt = block*window+1;
    stp = block*window+wsize;
    edge(block+1) = edgedetect(strt,stp,ang,avgang);
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
w = 5;
for m=1:ne,
    [minval,ind] = min( EELS_spectrum(ed1(m)-w:ed1(m)+w));
    ed_c(m) = (ed1(m)-w+ind-1);
end

disp(ed_c);
%figure;
%plot(xaxis,ang*20,'-r')
%hold on
%plot(xaxis,EELS_spectrum,'LineWidth',2)
%plot(xaxis,45,'LineWidth',3)
%stem(ed*2000,'-r','LineWidth',1)
%grid on