clc
close all
clear all
%%

EELS = readEELSdata('InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');

%% calibrate zlp
EELS = calibrate_zero_loss_peak(EELS);


%% Select 13eV to 30eV

[~,minidx] = min(abs(EELS.calibrated_energy_loss_axis-13.005),[],3);
[~,maxidx] = min(abs(EELS.calibrated_energy_loss_axis-27.48),[],3);

SImage = EELS.SImage(:,:,minidx:maxidx);

%% Remove spike artifacts
SImage = medfilt1(SImage,20,[],3,'truncate');

%% Generate Plasmon peaks
rsq = zeros(EELS.SI_x,EELS.SI_y,11);
for mm = 30:-1:29,
    for nn = 60:-1:59,
        l = squeeze(EELS.calibrated_energy_loss_axis(mm,nn,minidx:maxidx));
        S = squeeze(SImage(mm,nn,:));
        
        lf = squeeze(EELS.calibrated_energy_loss_axis(mm,nn,:));
        Sf = squeeze(EELS.SImage(mm,nn,:));
        
        tic;
        In = (0:1/10:1)';
        Ep = 19.55-4.02*In;
        FWHM = 4.187+4.73727*In-5.09438*In.^2;
        A = 21110.50558;
        
        Sp = zeros(length(l),length(In));
        
        for i=1:length(In),
            Sp(:,i) = (2*A/pi)*(FWHM(i)./(4*(l-Ep(i)).^2+FWHM(i).^2));
        end
        
        %% Generate InGaN core-loss
        
        [GaN,InN,InGaN] = referenced_InGaN('ll_1_20.csv');
        %%
        InN(isnan(InN)) = 0;
        GaN(isnan(GaN)) = 0;
        InGaN(isnan(InGaN)) = 0;
        
        GaN = GaN(1:966);
        InN = InN(1:966);
        InGaN = InGaN(1:966,:);
        
        InGaN = [GaN,InGaN,InN];
        %%
        for ii = 1:11,
            pInN = Sp(1:708,end);
            pInGaN = Sp(1:708,ii);
            pGaN = Sp(1:708,1);
            
            cInN = InGaN(1:708,end);
            cInGaN = InGaN(1:708,ii);
            cGaN = InGaN(1:708,1);
            
            X = [ pInN pInGaN pGaN cInN cInGaN cGaN];
            
            y = S(1:708);
            
            [~,~,~,~,stats] = regress(y,X);
            
            rsq(mm,nn,ii) = stats(1);
            r(ii) = stats(1);
        end
        
        [~,ind] = max(r);
        
        pInN = Sp(1:708,end);
        pInGaN = Sp(1:708,ind);
        pGaN = Sp(1:708,1);
        
        cInN = InGaN(1:708,end);
        cInGaN = InGaN(1:708,ind);
        cGaN = InGaN(1:708,1);
        
        X = [ pInN pInGaN pGaN cInN cInGaN cGaN];
        
        y = S(1:708);
        
        b(mm,nn,:) = regress(y,X);
        count = 11;
        while(sum(squeeze(b(mm,nn,:))<0)>0 && count>0)
            r(ind) = 0;
            [~,ind] = max(r);
            
            pInN = Sp(1:708,end);
            pInGaN = Sp(1:708,ind);
            pGaN = Sp(1:708,1);
            
            cInN = InGaN(1:708,end);
            cInGaN = InGaN(1:708,ind);
            cGaN = InGaN(1:708,1);
            
            X = [ pInN pInGaN pGaN cInN cInGaN cGaN];
            
            y = S(1:708);
            
            b(mm,nn,:) = regress(y,X);
            count = count -1;
            
            con_ind(mm,nn)=ind;
        end
        
        
        
        fprintf('Spectrum (%d,%d) processed',mm,nn);
        
        
        toc;
    end
end



%% Subtract Plasmon from Spectrum

for i=1:length(In),
    Np(:,i) = (2*A/pi)*(FWHM(i)./(4*(lf-Ep(i)).^2+FWHM(i).^2));
end

plasm = [Np(:,end),Np(:,con_ind(mm,nn)),Np(:,1)]*squeeze(b(mm,nn,1:3));

%plotEELS(lf,plasm)

figure;
plotEELS(lf,squeeze(EELS.SImage(mm,nn,:))-plasm);

RS = squeeze(EELS.SImage(mm,nn,:))-plasm;

%% Subtract zero_loss background

[~,minidx] = min(abs(lf-0.54));
[~,maxidx] = min(abs(lf-1.5));

xl = lf(minidx:maxidx);
yl = RS(minidx:maxidx);

%zl = feval(fit(xl,yl,'a*exp(-b*x)+c*exp(-d*x)+e','Lower',[2000,5,350,2.2E-8,10]),lf);
zl = feval(fit(xl,yl,'a*exp(-b*x)+c*exp(-d*x)+e*exp(-f*x)+g','Lower',[6000,5,5700,4,10^7,20,10]),lf);

y1 = RS-zl;

%%
c = 1;
for kk = 0.7:0.1:3.5,
    [~,minidx] = min(abs(lf-kk));
    [~,maxidx] = min(abs(lf-6.6));
    
    y = y1(minidx:maxidx);
    y(y<200) = 0;
    %y=medfilt1(y,'truncate');
    
    %% Square-root function
    
    fun = @(A,lf) A(1)*(lf(minidx:maxidx)-A(2)).^0.5;
    
    x0 = [100,3];
    
    lb = [100 1];
    ub = [inf inf];
    options = optimoptions('fminunc','Display','off');
    A = real(lsqcurvefit(fun,x0,lf,y,lb,ub,options));
    
    R(c) = real(R_square(y,A(1)*(lf(minidx:maxidx)-A(2)).^0.5));
    pp(c,1:2) = A;
    Eg(c) = A(2);
    
    c = c+1;
end

%bg(ii,jj) = Eg(R==max(R));
%R2(ii,jj) = R(R==max(R));
%fprintf('Processed %dX%d\n',ii,jj);

Eg(R==max(R))
R(R==max(R))
