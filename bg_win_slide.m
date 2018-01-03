clc
clear all

%% Spectrum

%% GaN Series 1 spectrum profile
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/Profile Of sum_GaN_series1_25images.dm3');
%S = EELS.spectrum;
%l = EELS.energy_loss_axis;

%% GaN Series 1 Plasmon subtracted spectrum profile
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/Profile Of sum_GaN_series1_25images.dm3');
%S = EELS.spectrum;
%l = EELS.energy_loss_axis;
%[Wp,Ep,Ap,L] = plasmon_fit(l,S);
%S = S-Ap*L(l,Ep,Wp);

%% GaN Series 1 FL deconv
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/Profile Of sum_GaN_series1_25images (deconvolved).dm3');
%S = EELS.spectrum(1:end-1);
%l = EELS.energy_loss_axis(1:end-1);

%% GaN Series 3 ADF spectrum profile
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/Profile Of sum24_series3.dm3');
%S = EELS.spectrum;
%l = (1:1024)'* 0.05;
%l = calibrate_zero_loss_peak(l,S,'gauss');

%% GaN Series 3 ADF Plasmon subtracted spectrum profile
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/Profile Of sum24_series3.dm3');
%S = EELS.spectrum;
%l = (1:1024)'* 0.05;
%l = calibrate_zero_loss_peak(l,S,'gauss');
%[Wp,Ep,Ap,L] = plasmon_fit(l,S);
%S = S-Ap*L(l,Ep,Wp);

%% GaN Series 3 ADF FL deconv
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/Data_27_06_2017/Profile Of sum24_series3 (deconvolved).dm3');
%S = EELS.spectrum;
%l = EELS.energy_loss_axis;

%% GaAs
%EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaAs100_Q4_EELStest_130705/Pos1_20muCA/EELS_0.6mm_0.1s.dm3');
%S = sum(EELS.Image(128:136,:))';
%l = (1:1024)'* 0.05;
%l = calibrate_zero_loss_peak(l,S,'gauss');

%% GaAs 1s FL
EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaAs100_Q4_EELStest_130705/Pos1_20muCA/Profile Of EELS_0.6mm_1s (deconvolved).dm3');
S = EELS.spectrum;
l = EELS.energy_loss_axis;

%% Smooth spectrum
SS = [S(1:eV2ch(l,2.35));smooth(S(eV2ch(l,2.4):end),0.05,'rloess')];

Sp = [S(1:eV2ch(l,2.35));feval(Spline(l(eV2ch(l,2.05):end),S(eV2ch(l,2.05):end),0.5),l(eV2ch(l,2.4):end))];

%plotEELS(l,S)

%% ZLP
%{

Z = table2array(singleframeZL1D0)';

[~,ind_Z] = max(Z);

Z = circshift(Z,eV2ch(l,0)-ind_Z);

ZZ = [Z(1:eV2ch(l,2.35));smooth(Z(eV2ch(l,2.4):end),0.05,'rloess')];

Zp = [Z(1:eV2ch(l,2.35));feval(Spline(l(eV2ch(l,2.05):end),Z(eV2ch(l,2.05):end),0.5),l(eV2ch(l,2.4):end))];

%plotEELS(l,Sp - Zp)
%}
%%

%fl = ifft(fft(Z,1024).*log(fft(S,1024)./fft(Z,1024)));
%flp = [fl(1:eV2ch(l,0.95));feval(Spline(l(eV2ch(l,0.95):end),fl(eV2ch(l,0.95):end),0.5),l(eV2ch(l,1):end))];

%% Define Start, Stop and Window sizes in eV
strt = 0; %in eV
stp = 10; %in eV

for k = 20:-1:1 %k is a counter

w = k*0.5; % w is in eV
%w = 3; k = 1;

for ii = eV2ch(l,stp):-1:eV2ch(l,strt+w)
    x = l(ii-(eV2ch(l,w)-eV2ch(l,0)):ii);
    y = SS(ii-(eV2ch(l,w)-eV2ch(l,0)):ii);
    [fun,gof] = fit(x,y,'a*sqrt_fun(x,b).^0.5',...
        'StartPoint',[1,1],...
        'lower',[-1,-1],...
        'upper',[1E10,12]);
    Ag(k,ii) = fun.a;
    Eg(k,ii) = fun.b;
    R2(k,ii) = gof.rsquare;
end

end

%%
Ag(Ag<0) = NaN;
R2(R2<0) = NaN;
Eg(Eg<0) = NaN;

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
[idx,C] = kmeans([R2(:), Eg(:)],4,'Distance','cityblock',...
'Replicates',5,'Options',opts);
fig1 = figure;
% Create axes
axes1 = axes('Parent',fig1);
hold(axes1,'on');

plot(R2(idx==1),Eg(idx==1),'r.','MarkerSize',12)
plot(R2(idx==2),Eg(idx==2),'g.','MarkerSize',12)
plot(R2(idx==3),Eg(idx==3),'m.','MarkerSize',12)
plot(R2(idx==4),Eg(idx==4),'c.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids',...
'Location','NW')
title 'Cluster Assignments and Centroids'
grid on
grid minor
% Create title
title('Cluster Assignments and Centroids');
xlabel('R^2')
ylabel('Bandgap (E_g in eV)')

xlim([0 1])

box(axes1,'on');
grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',14,'FontWeight','bold','XMinorGrid','on','YMinorGrid',...
    'on','ZMinorGrid','on');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest','FontSize',14,'Box','on');

hold off