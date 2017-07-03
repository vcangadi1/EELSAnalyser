clc

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/GaN_EPistar-nanowiresVEELS_28032017/GaN_SingleFrame_DIFFmode_ADFaperture_8cmCl_0.5s_0.05disp.dm3');

%% calibrate 

l = (1:EELS.Image_y)'*0.05;
S = sum(EELS.Image)';
l = calibrate_zero_loss_peak(l,S,'gauss');

%% subtract plasmon

%[Wp,Ep,Ap,L,gofp] = plasmon_fit(l,S);

%S = S - Ap*L(l,Ep,Wp);


%[FitResults,GOF,baseline,coeff,BestStart,xi,yi,BootResults]=peakfit([l,S],0,2,1,13,80);

%% fit range

p = eV2ch(l,plasmon_peak(l,S));
z = eV2ch(l,0);

%[~,minidx] = min(S(z:p));
%minidx = minidx + z;
minidx = eV2ch(l,7);
maxidx = eV2ch(l,12);


%%

p0 = [1E1,0.5,3.4,100];
lb = [1,0.1,0,0];
ub = [1E10,1,6,1E10];

fit_error = @(p) sum(S(minidx:maxidx)-p(1)*(p(2)*(l(minidx:maxidx)-p(3))).^0.5+p(4)).^2;

options = optimoptions(@fmincon,'Display','iter','MaxIterations',1500,'PlotFcns',{@optimplotx,@optimplotfval,@optimplotfunccount});

p = fmincon(fit_error,p0,[],[],[],[],lb,ub,[],options);

close all;

%%

figure
plotEELS(l,S)
plotEELS(l,real(p(1)*(p(2)*(l-p(3))).^0.5+p(4)))

disp(p)
