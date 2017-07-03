clc

%load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
EELS = readEELSdata;
Z = EELS_sum_spectrum(EELS);
Z(Z<=0)=0.01;
%Z = EELS.spectrum;

[llow,Z] = calibrate_zero_loss_peak(EELS.energy_loss_axis',Z);

%% Find Sigma (standard deviation)

Sig = fwhm(llow,Z)/(2*sqrt(2*log(2)));

%% Find the exact zero_loss peak, which indicates mean (mu) position in gaussian

fit_error = @(mu) sum((Z - gauss_distribution(llow,mu,Sig)).^2);
%fit_error = @(mu) sum((Z - normpdf(llow,mu,Sig)).^2);

a0 = 0;

best_mu = fminsearch(fit_error, a0);

g = normpdf(llow,best_mu,Sig);

f = @(a,g) a*g;
tempZ = Z/sum(Z);

a = lsqcurvefit(f,10,g,tempZ);

G = a*sum(Z)*g;

%% Deconvolve zero-loss peak
Zn = ifftshift(shift_zlp(G,llow));

R = deconvlucy([Z;flipud(Z)],Zn/sum(Zn));
[q,r] = deconv([Z;flipud(Z)],Zn/sum(Zn));

%%
plotEELS(llow,Z)
hold on
plotEELS(llow,Z-G)

plotEELS(llow,G)

plotEELS(llow,R(1:1024))
%% Find Bandgap by subtracting zero-loss peak

ind = crossing(Z-G);
min_error = @(i) interp1(llow(ind(end):end),Z(ind(end):end)-G(ind(end):end),i).^2;
band_gap = fminsearch(min_error, llow(ind(end)));
