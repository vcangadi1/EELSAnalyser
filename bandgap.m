clc
close all
clear all
%%
EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
%plotEELS(EELS)

%S = EELS_sum_spectrum(EELS);
S = EELS.S(8,60);
l = EELS.energy_loss_axis;

%%
SS = S.*S;

%%
[l,SS] = calibrate_zero_loss_peak(l,SS);

%%
[~,minidx] = min(abs(l-0.7));
[~,maxidx] = min(abs(l-3.4));
[~,limitidx] = min(abs(l-6.6));

%%SS = medfilt1(SS,10,'truncate');

%[~,locs] = findpeaks(SS,'SortStr','descend');
%[~,min_idx] = min(SS(locs(1):locs(2)));
%minidx = locs(1) + min_idx - 1;
%%
kk = 1;
for ii = maxidx:limitidx
    
    S = SS(minidx:ii);
    ll = l(minidx:ii);
    
    
    [p,gof] = fit(ll,S,'poly1');
    c(kk) = p.p2;
    m(kk) = p.p1;
    r(kk) = gof.rsquare;
    Eg(kk) = -p.p2/p.p1;
    
    
    fprintf('ii = %d\t kk = %d\n',ii,kk);
    kk = kk+1;
end

%%
for ii = minidx:maxidx
    
    S = SS(ii:limitidx);
    ll = l(ii:limitidx);
    
    
    [p,gof] = fit(ll,S,'poly1');
    c(kk) = p.p2;
    m(kk) = p.p1;
    r(kk) = gof.rsquare;
    Eg(kk) = -p.p2/p.p1;
    
    
    
    fprintf('ii = %d\t kk = %d\n',ii,kk);
    kk = kk+1;
end
%%
plot(Eg,r)
xlabel('Eg')
ylabel('R^2')

%%
[~,Egidx] = max(r);
fprintf('BandGap = %6.5f\n',Eg(Egidx));
