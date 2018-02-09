clc
close all
%clear all
warning('off','all')
%%
EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
EELS = calibrate_zero_loss_peak(EELS);
for ii = 14:-1:14
    for jj = 38:-1:38
        fprintf('Processing %dX%d\t',ii,jj);
        S = EELS.S(ii,jj);
        S(270:end) = medfilt1(S(270:end),20,'truncate');
        l = squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
        
        [l,S] = calibrate_zero_loss_peak(l,S);
        y1 = S;
        %%
        [~,minidx] = min(abs(l-15));
        [~,maxidx] = min(abs(l-19.7));
        
        x = l(minidx:maxidx);
        y = S(minidx:maxidx);
        
        [~,pp] = lorentzfit(x,y,[],[],'3');
        
        zp = pp(1)./((l - pp(2)).^2 + pp(3));
        
%        plotEELS(l,zp)
%        hold on
%        plotEELS(l,S-zp)
        
        %%
        oS = S;
        S = S-zp;
        
        %%
        
        [~,minidx] = min(abs(l-0.54));
        [~,maxidx] = min(abs(l-1.5));
        
        xl = l(minidx:maxidx);
        yl = S(minidx:maxidx);
        
        %zl = feval(fit(xl,yl,'a*exp(-b*x)+c*exp(-d*x)','Lower',[2000,5,350,2.2E-8]),l);
        zl = feval(fit(xl,yl,'a*exp(-b*x)+c*exp(-d*x)+e*exp(-f*x)+g','Lower',[6000,5,5700,4,10^7,20,10]),l);
        y1 = S-zl;
        
%        plotEELS(l,S)
%        hold on
%        plotEELS(l,S-zl)
%        ylim([-1000 1000]);
        %%
        
        Sp = y1;
        
        [~,minidx] = min(abs(l-1));
        [~,maxidx] = min(abs(l-2));
        
        rng = maxidx-minidx;
        
        [~,maxidx] = min(abs(l-5));
        
        c = 1;
        for kk = minidx:maxidx-rng
            fun = 315*(l(minidx:kk+rng)-l(kk)).^0.5;
            Spect = Sp(minidx:kk+rng);
            R2(c) = R_square(Spect,fun);
            Eg(c) = l(kk);
            c = c+1;
        end
        %R2(R2<0) = 0;
        bg(ii,jj) = Eg(R2==max(R2(:)));
        if R2(R2==max(R2(:)))<0
            Rsq(ii,jj) = 0;
        else
            Rsq(ii,jj) = R2(R2==max(R2(:)));
        end
        R2(R2<0) = 0;
        fprintf('Processed = %d X %d\n',ii,jj);
        
    end
end
warning('on','all')