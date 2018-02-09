clc
clear all
%% GaN Series 3 ADF square spectrum profile
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/square_profile_sum24_series3.dm3');
S = EELS.spectrum;
l = (1:1024)'* 0.05;
l = calibrate_zero_loss_peak(l,S,'gauss');

%% Smooth spectrum
SS = [S(1:eV2ch(l,2.35));smooth(S(eV2ch(l,2.4):end),0.05,'rloess')];

Sp = [S(1:eV2ch(l,2.35));feval(Spline(l(eV2ch(l,2.05):end),S(eV2ch(l,2.05):end),0.5),l(eV2ch(l,2.4):end))];

%% Define Start, Stop and Window sizes in eV
strt = 0;
stp = 10;

for k = 20:-1:1

w = k*0.5;
%w = 3; k = 1;

for ii = eV2ch(l,stp):-1:eV2ch(l,strt+w)
    x = l(ii-(eV2ch(l,w)-eV2ch(l,0)):ii);
    y = SS(ii-(eV2ch(l,w)-eV2ch(l,0)):ii);
    [fun,gof] = fit(x,y,'poly1');
    Ag(k,ii) = fun.p1;
    Eg(k,ii) = -(fun.p2)/(fun.p1);
    R2(k,ii) = gof.rsquare;
end

end

%%
Ag(Ag<0.1) = NaN;
R2(R2<0.1) = NaN;
R2(R2<0.5) = NaN;
Eg(Eg<0.1) = NaN;
Eg(Eg>10) = NaN;

figure (1)
plot(R2(:),Eg(:),'*')
xlabel('rsquare (R^2)')
ylabel('Bandgap (Eg)')

figure (2)
plot(Ag(:),Eg(:),'*')
xlabel('Amplitude (Ag)')
ylabel('Bandgap (Eg)')

figure (3)
plot(R2(:),Ag(:),'*')
xlabel('rsquare (R^2)')
ylabel('Amplitude (Ag)')

%% K-means clustering

opts = statset('Display','final');
[idx,C] = kmeans([R2(:),Eg(:)],4,'Distance','cityblock',...
'Replicates',10,'Options',opts,'Start','cluster');
figure;
plot(R2(idx==1),Eg(idx==1),'r.','MarkerSize',12)
hold on
plot(R2(idx==2),Eg(idx==2),'g.','MarkerSize',12)
plot(R2(idx==3),Eg(idx==3),'m.','MarkerSize',12)
plot(R2(idx==4),Eg(idx==4),'c.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids',...
'Location','NE')
title 'Cluster Assignments and Centroids'
grid on
grid minor
hold off