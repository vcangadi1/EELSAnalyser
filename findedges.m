
%si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );

function [ed_c] = findedges(EELSdata_cube,SI_x,SI_y)

z = size(EELSdata_cube,3);
EELS = reshape(EELSdata_cube(SI_x,SI_y,:),z,1);

for m=1:z-1,
    dy = EELS(m+1) - EELS(m);
    temp = (atan(dy).*180/pi);
    if(temp<=0)
        ang(m) = NaN;
    else 
        ang(m) = temp;
    end
end
ang(m+1) = ang(m);

wsize = 32;
for i=1:z-wsize,
    edge(i)=edgedetect(i,i+wsize,ang);
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
w = 20;
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