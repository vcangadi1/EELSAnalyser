function Concor2(alpha,beta,e,e0)
%     CONCOR2: EVALUATION OF CONVERGENCE CORRECTION F USING THE
%     FORMULAE OF SCHEINFEIN AND ISAACSON (SEM/1984, PP.1685-6).
%     FOR ABSOLUTE QUANTITATION, DIVIDE THE AREAL DENSITY BY F2.
%     FOR ELEMENTAL RATIOS, DIVIDE EACH CONCENTRATION BY F2 OR F1.
%
%     ALPHA AND BETA SHOULD BE IN MRAD,  E IN EV , E0 IN KEV .
%
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011


fprintf(1,'\n---------------Concor2--------------\n\n');
if(nargin~=4)
    fprintf('Alternate Usage: Concor2(alpha,beta,E,E0)\n\n');
    
    alpha = input('Alpha (mrad) : ');
    beta = input('Beta (mrad) : ');
    e = input('E (eV) : ');
    e0 = input('E0 (keV) : ');
%fprintf(1,'++++++++++++++++++++\n');

else
    fprintf('Alpha (mrad) : %g\n',alpha);
    fprintf('Beta (mrad) : %g\n',beta);
    fprintf('E (eV) : %g\n',e);
    fprintf('E0 (keV) : %g\n',e0);
end;

tgt=e0.*(1.+e0./1022.)./(1.+e0./511.);
thetae=(e+1e-6)./tgt; % avoid NaN for e=0
%     A2,B2,T2 ARE SQUARES OF ANGLES IN RADIANS**2
a2=alpha.*alpha.*1e-6 + 1e-10;  % avoid inf for alpha=0
b2=beta.*beta.*1e-6;
t2=thetae.*thetae.*1e-6;
eta1=sqrt((a2+b2+t2).^2-4..*a2.*b2)-a2-b2-t2;
eta2=2..*b2.*log(0.5./t2.*(sqrt((a2+t2-b2).^2+4..*b2.*t2)+a2+t2-b2));
eta3=2..*a2.*log(0.5./t2.*(sqrt((b2+t2-a2).^2+4..*a2.*t2)+b2+t2-a2));
eta=(eta1+eta2+eta3)./a2./log(4../t2);
f1=(eta1+eta2+eta3)./2./a2./log(1.+b2./t2);
f2=f1;
if(alpha./beta>1)
    f2=f1.*a2./b2;
end;
bstar=thetae.*sqrt(exp(f2.*log(1.+b2./t2))-1.);
fprintf(1,'\nf1 %g f2 %g bstar %g\n',f1,f2,bstar);

end

