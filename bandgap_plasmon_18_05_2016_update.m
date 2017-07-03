clc
close all
clear all
warning('off','all')
%%

EELS = readEELSdata;

%% calibrate zlp
EELS = calibrate_zero_loss_peak(EELS);


%% Select 13eV to 30eV

[~,minidx] = min(abs(EELS.calibrated_energy_loss_axis-13.005),[],3);
[~,maxidx] = min(abs(EELS.calibrated_energy_loss_axis-27.48),[],3);

SImage = EELS.SImage(:,:,minidx:maxidx);

%% Remove spike artifacts
SImage = medfilt1(SImage,20,[],3,'truncate');

%% Generate Plasmon peaks
rsq = zeros(EELS.SI_x,EELS.SI_y,20);

for mm =EELS.SI_x:-1:1,
    for nn =EELS.SI_y:-1:1,
        l = squeeze(EELS.calibrated_energy_loss_axis(mm,nn,minidx:maxidx));
        S = squeeze(SImage(mm,nn,:));
        lf = squeeze(EELS.calibrated_energy_loss_axis(mm,nn,:));
        Sf = squeeze(EELS.SImage(mm,nn,:));
        tic;
        In = (0:1/20:1)';
        Ep = 19.55-4.02*In;
        FWHM = 4.187+4.73727*In-5.09438*In.^2;
        A = 21110.50558;
        
        Sp = zeros(length(l),length(In));
        
        for i=1:length(In),
            Sp(:,i) = (2*A/pi)*(FWHM(i)./(4*(l-Ep(i)).^2+FWHM(i).^2));
        end
        
        %% Generate InGaN core-loss
        
        [GaN,InN,InGaN] = referenced_InGaN('nion coreloss consider peak distance.csv');
        %%
        InN(isnan(InN)) = 0;
        GaN(isnan(GaN)) = 0;
        InGaN(isnan(InGaN)) = 0;
        
        GaN = GaN(1:966);
        InN = InN(1:966);
        InGaNt = InGaN(1:966,:);
        
        InGaN = [GaN,InGaNt,InN];
        %%
         for ii = 1:20,
            pInN = Sp(1:767,end);
            pInGaN = Sp(1:767,ii);
            pGaN = Sp(1:767,1);
            
            cInN = InGaN(1:767,end);
            cInGaN = InGaN(1:767,ii);
            cGaN = InGaN(1:767,1);
            
            X = [ pInN pInGaN pGaN cInN cInGaN cGaN];
            X(X<0) = 0;
            
            y = S(1:767);
            
            [~,~,~,~,stats] = regress(y,X);
            
            rsq(mm,nn,ii) = stats(1);
            r(ii) = stats(1);
        end
        
        [~,ind] = max(r);
        if ind == 0
            ind = 1;
        end
        
        pInN = Sp(1:767,end);
       pInGaN = Sp(1:767,ind);
        pGaN = Sp(1:767,1);
        
        cInN = InGaN(1:767,end);
        cInGaN = InGaN(1:767,ind);
        cGaN = InGaN(1:767,1);
        
     X = [ pInN pInGaN pGaN cInN cInGaN cGaN];
     X(X<0) = 0;
        
        y = S(1:767);
        
      b(mm,nn,:) = regress(y,X);
      count = 20;
      con_ind(mm,nn)=ind;
      while(sum(squeeze(b(mm,nn,:))<0)>0 && count>0)
          r(ind) = 0;
      [~,ind] = max(r);
              if ind == 0
            ind = 1;
        end
            
            pInN = Sp(1:767,end);
       pInGaN = Sp(1:767,ind);
        pGaN = Sp(1:767,1);
        
        cInN = InGaN(1:767,end);
        cInGaN = InGaN(1:767,ind);
        cGaN = InGaN(1:767,1);
        
     X = [ pInN pInGaN pGaN cInN cInGaN cGaN];
     X(X<0) = 0;
        
        y = S(1:767);
        
      b(mm,nn,:) = regress(y,X);
      count = count -1;
      
      con_ind(mm,nn)=ind;
      end
        
        
        
        fprintf('Spectrum (%d,%d) processed',mm,nn);
        
        
        toc;
    end
end
Np=zeros(length(lf),length(In));
 for i=1:length(In),
            Np(:,i) = (2*A/pi)*(FWHM(i)./(4*(lf-Ep(i)).^2+FWHM(i).^2));
        end
        
for mm=EELS.SI_x:-1:1,
    for nn = EELS.SI_y:-1:1,
        
        %% Subtract Plasmon from Spectrum
        
       lf = squeeze(EELS.calibrated_energy_loss_axis(mm,nn,:));
      
        plasm = [Np(:,end),Np(:,con_ind(mm,nn)),Np(:,1)]*squeeze(b(mm,nn,1:3));
        
        %plotEELS(lf,plasm)
        
        %figure;
        %plotEELS(lf,squeeze(EELS.SImage(mm,nn,:))-plasm);
        
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
        
        
        [~,minidx] = min(abs(lf-1));
        [~,maxidx] = min(abs(lf-1.645));
        
        rng = maxidx-minidx;
        
        [~,maxidx] = min(abs(lf-5));
        
        c = 1;
        for kk = minidx:maxidx-rng,
            fun = 550*(lf(minidx:kk+rng)-lf(kk)).^0.5;
            Spect = y1(minidx:kk+rng);
            R2(c) = R_square(Spect,fun);
            Eg(c) = lf(kk);
            c = c+1;
        end
        %R2(R2<0) = 0;
        bg(mm,nn) = Eg(R2==max(R2));
        if R2(R2==max(R2(:)))<0
            Rsq(mm,nn) = 0;
        else
            Rsq(mm,nn) = R2(R2==max(R2));
        end
       
        clear R2
        fprintf('Processed = %d X %d\n',mm,nn);
        
    end
end
warning('on','all')