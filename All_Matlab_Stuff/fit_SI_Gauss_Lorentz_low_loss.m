clc
clear all

EELS = readEELSdata('EELS Spectrum Image1-thickness-map.dm3');
EELS.SImage(5,44,:) = EELS.SImage(5,45,:);

%% fit with TOL as fitting parameter

SI = zeros(size(EELS.SImage));

for ii = 5:-1:1
    for jj = EELS.SI_y:-1:1
        
        S = EELS.S(ii,jj);
        l = calibrate_zero_loss_peak(EELS.energy_loss_axis,S,'gauss');
        %l = squeeze(EELS.calibrated_energy_loss_axis(ii,jj,:));
        [W0,E0,A0,G] = zero_loss_fit(l,S);
        [Wp,Ep,Ap,L] = plasmon_fit(l,S);
        
        TOL = tbylambda(l,S);
        
        N = floor(l(end)/Ep);
        n = (0:N);
        %fun = @(p,l) (p(1)*(poisson(n,p(2))*[G(l,0,W0),L(l,n(2:end)*p(3),p(4))]')');
        fun = @(p,l) (p(1)*(poisson(n,p(2))*[G(l,0,W0),plural_scattering(L(l,n(2:end)*p(3),p(4)),G(l,0,p(5))')]')');
        p0 = [1E5,TOL,Ep,Wp,W0];
        lb = [0,0,0,0,0];
        ub = [inf,10,1.5*Ep,inf,inf];
        options = optimset('Display','off');
        p = lsqcurvefit(fun,p0,l,S,lb,ub,options);
        SI(ii,jj,:) = p(1)*(poisson(n,p(2))*[G(l,E0,W0),plural_scattering(L(l,n(2:end)*p(3),p(4)),G(l,E0,p(5))')]')';
        A(ii,jj) = p(1);
        t_map(ii,jj) = p(2);
        %R2(ii,jj) = rsquare(S,p(1)*(poisson(n,p(2))*[G(l,E0,W0),plural_scattering(L(l,n(2:end)*p(3),p(4)),G(l,E0,p(5))')]')');
        R2(ii,jj) = rsquare(S,p(1)*(poisson(n,p(2))*[G(l,0,W0),L(l,n(2:end)*p(3),p(4))]')');
        fprintf('ii = %d, jj = %d\n',ii,jj);
    end
end

%figure;
%plotEELS(l,S)
%plotEELS(l,p(1)*(poisson(n,p(2))*[G(l,E0,W0),L(l,n(2:end)*Ep,Wp)]')')
%rsquare(S,p(1)*(poisson(n,p(2))*[G(l,E0,W0),L(l,n(2:end)*Ep,Wp)]')')
