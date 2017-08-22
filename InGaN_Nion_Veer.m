clc
close all
clear all
%%

EELS = readEELSdata('/Users/veersaysit/Desktop/EELS data/InGaN/60kV/EELS Spectrum Image9-0.015eV-ch.dm3');

%% calibrate zlp
EELS = calibrate_zero_loss_peak(EELS,'gauss');


%% Select 13eV to 30eV

[~,minidx] = min(abs(EELS.calibrated_energy_loss_axis-13.005),[],3);
[~,maxidx] = min(abs(EELS.calibrated_energy_loss_axis-27.48),[],3);

SImage = EELS.SImage(:,:,minidx:maxidx);

%% Remove spike artifacts
SImage = medfilt1(SImage,20,[],3,'truncate');

%% Generate Plasmon peaks
rsq = zeros(EELS.SI_x,EELS.SI_y,11);
for mm = EELS.SI_x:-1:1
    for nn =EELS.SI_y:-1:1
        l = squeeze(EELS.calibrated_energy_loss_axis(mm,nn,minidx:maxidx));
        S = squeeze(SImage(mm,nn,:));
        tic;
        In = (0:1/10:1)';
        Ep = 19.55-4.02*In;
        FWHM = 4.187+4.73727*In-5.09438*In.^2;
        A = 21110.50558;
        
        Sp = zeros(length(l),length(In));
        
        for i=1:length(In)
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
        for ii = 1:11
            pInN = Sp(1:708,end);
            pInGaN = Sp(1:708,ii);
            pGaN = Sp(1:708,1);
            
            cInN = InGaN(1:708,end);
            cInGaN = InGaN(1:708,ii);
            cGaN = InGaN(1:708,1);
            cl = l(1:708);
            
            X = [pInN pInGaN pGaN cInN cInGaN cGaN cl ones(708,1)];
            
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
        cl = l(1:708);
        
        X = [pInN pInGaN pGaN cInN cInGaN cGaN cl ones(708,1)];
        
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
        cl = l(1:708);
        
       X = [pInN pInGaN pGaN cInN cInGaN cGaN cl ones(708,1)];
        
        y = S(1:708);
        
      b(mm,nn,:) = regress(y,X);
      count = count - 1;
      
      con_ind(mm,nn)=ind;
      end
      used_InGaN_con=con_ind.*0.1;
      
          
     fprintf('Spectrum (%d,%d) processed',mm,nn);
        fpInN = Sp(1:966,end);
       fpInGaN = Sp(1:966,ind);
        fpGaN = Sp(1:966,1);
        
      fcInN = InGaN(1:966,end);
        fcInGaN = InGaN(1:966,ind);
        fcGaN = InGaN(1:966,1);
        tsum(mm,nn) = sum(fcInN)*b(mm,nn,4)+sum(fcGaN)*b(mm,nn,6)+sum(fcInGaN)*b(mm,nn,5);
       wcInGaN(mm,nn) = (sum(fcInGaN)*b(mm,nn,5))/tsum(mm,nn);
        wcGaN(mm,nn) = (sum(fcGaN)*b(mm,nn,6))/tsum(mm,nn);
       wcInN(mm,nn) = (sum(fcInN)*b(mm,nn,4))/tsum(mm,nn);
       
       
        
        psum(mm,nn) = sum(fpInN)*b(mm,nn,1)+sum(fpGaN)*b(mm,nn,3)+sum(fpInGaN)*b(mm,nn,2);
       wpInGaN(mm,nn) = (sum(fpInGaN)*b(mm,nn,2))/psum(mm,nn);
        wpGaN(mm,nn) = (sum(fpGaN)*b(mm,nn,3))/psum(mm,nn);
        wpInN(mm,nn) = (sum(fpInN)*b(mm,nn,1))/psum(mm,nn);
        
        toc;
   end
    


end

%% r-square maps
best_rsq = max(rsq,[],3);
figure;
plotEELS(best_rsq,'map');

%% weighted core-loss maps
figure;
subplot 321
plotEELS(wcGaN,'map');
title('weighted core-loss maps GaN')
subplot 323
plotEELS(wcInGaN,'map');
title('weighted core-loss maps InGaN')
subplot 325
plotEELS(wcInN,'map');
title('weighted core-loss maps InN')


%% weighted plasmon maps
subplot 322
plotEELS(wpGaN,'map');
title('weighted plasmon maps GaN')
subplot 324
plotEELS(wpInGaN,'map');
title('weighted plasmon maps InGaN')
subplot 326
plotEELS(wpInN,'map');
title('weighted plasmon maps InN')

%% plot used InGaN for fitting
figure;
plotEELS(used_InGaN_con,'map');
%{
figure;
plotEELS(l(1:708),X*b)
hold on
plotEELS(l(1:708),S(1:708))
title([num2str(rsq(ii)),' ', num2str(ii)]);

%%
fprintf('%6.6f rsquare -------- %6.2f\n',rsq(ii),ii);

tsum = sum(cInN)*b(5)+sum(cGaN)*b(end)+sum(cInGaN)*b(6);
fprintf('Weighting cInGaN = %6.2f\n',(sum(cInGaN)*b(6))/tsum);
fprintf('Weighting cGaN = %6.2f\n',(sum(cGaN)*b(end))/tsum);
fprintf('Weighting cInN = %6.2f\n',(sum(cInN)*b(5))/tsum);

psum = sum(pInN)*b(2)+sum(pGaN)*b(4)+sum(pInGaN)*b(3);
fprintf('Weighting pInGaN = %6.2f\n',(sum(pInGaN)*b(3))/psum);
fprintf('Weighting pGaN = %6.2f\n',(sum(pGaN)*b(4))/psum);
fprintf('Weighting pInN = %6.2f\n',(sum(pInN)*b(2))/psum);

%%
figure;
plotEELS(l(1:708),X*b)
hold on
plotEELS(l(1:708),S(1:708))


%}