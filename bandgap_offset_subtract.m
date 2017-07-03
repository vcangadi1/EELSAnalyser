clc
close all
clear all
warning('off','all')
%%
EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');
EELS = calibrate_zero_loss_peak(EELS);
for ii = EELS.SI_x:-1:30
    for jj = EELS.SI_y:-1:60
        fprintf('Processing %dX%d\t',ii,jj);
        S = EELS.S(ii,jj);
        %S(270:end) = medfilt1(S(270:end),20,'truncate');
        l = squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
        
        [l,S] = calibrate_zero_loss_peak(l,S);
        y1 = S;
        %%
        %{
        x = l(1415:1542);
        y = S(1415:1542);
        
        [~,pp] = lorentzfit(x,y,[],[],'3');
        zp = pp(1)./((l - pp(2)).^2 + pp(3));
        
plotEELS(l,zp)
hold on
plotEELS(l,S-zp)
       
        %%
        S = S-zp;
         %}
        %%
        %{
        [~,minidx] = min(abs(l-0.54));
        [~,maxidx] = min(abs(l-1.5));
        
        xl = l(minidx:maxidx);
        yl = S(minidx:maxidx);
        
        %zl = feval(fit(xl,yl,'a*exp(-b*x)+c*exp(-d*x)','Lower',[2000,5,350,2.2E-8]),l);
        zl = feval(fit(xl,yl,'a*exp(-b*x)+c*exp(-d*x)+e*exp(-f*x)+g','Lower',[6000,5,5700,4,10^7,20,10]),l);
        y1 = S-zl;
        %}
        %%
        
        c = 1;
        for kk = 0.7:0.1:3.3
            [~,minidx] = min(abs(l-kk));
            [~,maxidx] = min(abs(l-6.6));
            
            y = y1(minidx:maxidx);
            
            %% Square-root function
            
            fun = @(A,l) A(1)*(l(minidx:maxidx)-A(2)).^(A(3));
            
            x0 = [100 3 0.5];
            
            lb = [1 0 0.3];
            ub = [inf inf 1.8];
            options = optimoptions('fminunc','Display','off');
            A = real(lsqcurvefit(fun,x0,l,y,lb,ub,options));
            
            R(c) = R_square(y,A(1)*(l(minidx:maxidx)-A(2)).^(A(3)));
            
            Eg(c) = A(2);
            
            xp(c) = A(3);
            
            amp(c) = A(1);
            
            c = c+1;
        end
        
        bg(ii,jj) = Eg(R==max(R));
        R2(ii,jj) = R(R==max(R));
        Xp(ii,jj) = xp(R==max(R));
        Amp(ii,jj) = amp(R==max(R));
        fprintf('Processed %dX%d\n',ii,jj);
    end
end
warning('on','all')
%%
%{
plotEELS(l(minidx:maxidx),y)
hold on
plotEELS(l(minidx:maxidx),A(1)*sqrt(l(minidx:maxidx)-A(2)))
%}

%R2 = R_square(y,A(1)*sqrt(l(minidx:maxidx)-A(2)));

%fprintf('R-square = %6.6f\tEg = %6.4f\n',R2,A(2));




%plot(Eg,R,'.')










%%

%{
hold on
plotEELS(l,S)
%plot(l,zp)
plotEELS(l,zl)
plotEELS(l,S-zl)
ylim([-3000 3000]);
xlim([-1 20]);

%}