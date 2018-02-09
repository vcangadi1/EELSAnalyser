
%si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );

%function [ed_c] = findedges_Cu_Ga_As_950offset(EELS,i,j)

load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

%i = 12;
%j = 5;
%h = plotEELS(EELS);
% Median filtering
SImage = zeros(size(EELS.SImage));
for i = 1:EELS.SI_x,
    for j = 1:EELS.SI_y,
        SImage(i,j,:) = medfilt1(squeeze(EELS.SImage(i,j,:)),5,'truncate');
        SImage(i,j,:) = medfilt1(squeeze(SImage(i,j,:)),5,'truncate');
        SImage(i,j,:) = medfilt1(squeeze(SImage(i,j,:)),5,'truncate');
    end
end
EELS.SImage = SImage;
% PCA denoise
EELS.PCA.Comp_Num = 10;
EELS = PCA_denoise(EELS);
EELS.SImage = EELS.PCA.denoised;

h = plotEELS(EELS);
i = 56;
j = 16;
delta = 50/EELS.dispersion;

yaxis = squeeze(EELS.SImage(i,j,:));

ang = zeros(size(yaxis));
for m=1:EELS.SI_z-1,
    dy = yaxis(m+1) - yaxis(m);
    temp = (atan(dy).*180/pi);
    if(temp<=0)
        ang(m) = 0;
    else
        ang(m) = temp;
    end
end
ang(m+1) = ang(m);

%figure;
%plot(EELS_spectrum);
%hold on;
%plot(ang*1000,'.r','LineWidth',3);
save('ang.mat','ang');

block = 0;
window = 1;
%wsize = si_struct.sensitivity;
wsize =15;
while(block*window+wsize<EELS.SI_z)
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
w = 10;
for m=1:ne,
    [minval,ind] = min( yaxis(ed1(m)-w:ed1(m)+w));
    ed_c(m) = (ed1(m)-w+ind-1);
end

disp(ed_c.');

k = 1;
minE = yaxis(ed_c(1));
for i=1:length(ed_c),
    if(yaxis(ed_c(i))<=minE)
        E(k) = ed_c(i);
        minE = yaxis(ed_c(i));
        k = k+1;
    end
end
E = unique(E);
for i = 1:length(E)-1,
    if(E(i)+delta>E(i+1))
        E(i+1) = E(i);
    end
end
E = unique(E);
disp(E);
%figure;
%plot(xaxis,ang*20,'-r')
%hold on
%plot(xaxis,EELS_spectrum,'LineWidth',2)
%plot(xaxis,45,'LineWidth',3)
%stem(ed*2000,'-r','LineWidth',1)
%grid on