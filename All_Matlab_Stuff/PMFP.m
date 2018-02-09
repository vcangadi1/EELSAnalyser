function PMFP(E0, Ep, alpha, beta)
% Calculate plasmon mean free paths using a free-electron formula Eq.(3.58)
% with m = m0 and assuming small width of the plasmon peak.
% Equally good for calculating total-inelastic MFP using a value of
% Em in Eq.(5.38) or a more approximate value using Eq.(5.2).
% Probe convergence alpha incorporated using Scheinfein & Isaacson formula.
% Above values assume dipole conditions (beta* < Bethe-ridge angle).
% The program also estimates a total-inelastic MFP by using dipole formula
% with effective collection angle bstar = Bethe-ridge angle.
% To obtain this value, enter alarge value (~ 100 mrad) for alpha or beta.
if(nargin<4)
    E0 = input('PMFP: Incident-electron energy E0 (keV): ');
    Ep = input('Plasmon energy of mean energy loss (eV): ');
    alpha = input('Convergence semiangle (mrad) [can be 0]: ');
    beta  =  input('Collection semiangle (mrad): ');
else
    fprintf('PMFP: Incident-electron energy E0 (keV): %g\n',E0);
    fprintf('Plasmon energy of mean energy loss (eV): %g\n',Ep);
    fprintf('Convergence semiangle (mrad) [can be 0]: %g\n',alpha);
    fprintf('Collection semiangle (mrad): %g\n',beta);
end
F = (1+E0/1022)/(1+E0/511)^2;
Fg = (1+E0/1022)/(1+E0/511);
T = E0.*F; %keV
tgt = 2.*Fg*E0;
a0 = 0.0529;  %nm
%fprintf(1,'2.gamma.T = %g\n\n',tgt);

% calculation of convergence correction
%tgt=2.*E0.*(1.+E0./1022.)./(1.+E0./511.); % keV
thetae=(Ep+1e-6)./tgt; % in mrad, avoid NaN for e=0
a2=alpha.*alpha.*1e-6 + 1e-10;  %radians^2, avoiding inf for alpha=0
b2=beta.*beta.*1e-6; %radians^2
t2=thetae.*thetae.*1e-6; %radians^2
eta1=sqrt((a2+b2+t2).^2-4..*a2.*b2)-a2-b2-t2;
eta2=2.*b2.*log(0.5./t2.*(sqrt((a2+t2-b2).^2+4.*b2.*t2)+a2+t2-b2));
eta3=2.*a2.*log(0.5./t2.*(sqrt((b2+t2-a2).^2+4.*a2.*t2)+b2+t2-a2));
eta=(eta1+eta2+eta3)./a2./log(4../t2);
f1=(eta1+eta2+eta3)./2./a2./log(1.+b2./t2);
f2=f1;
if(alpha./beta>1)
    f2=f1.*a2./b2;
end
bstar=thetae.*sqrt(exp(f2.*log(1.+b2./t2))-1.); % mrad
fprintf(1,'effective semiangle beta* = %g mrad\n',bstar);

thetabr = 1000 .* (Ep./E0./1000.).^0.5;
fprintf(1,'Bethe-ridge angle(mrad) = %g nm\n',thetabr);

if (bstar < thetabr)
    pmfp = 4000.*a0.*T./Ep./log(1+bstar.^2/thetae.^2);
    imfp = 106.*F.*E0./Ep./log(2.*bstar.*E0./Ep);
    fprintf(1,'Free-electron   MFP(nm) = %g nm\n',pmfp);
    fprintf(1,'Using Eq.(5.2), MFP(nm) = %g nm\n',imfp);
else
    fprintf(1,'Dipole range is exceeded\n');
    tmfp = 4000.*a0.*T./Ep./log(1+thetabr.^2/thetae.^2);
    fprintf(1,'total-inelastic MFP(nm) = %g nm\n',tmfp);
end
fprintf(1,'\n-------------------------------\n\n');
end