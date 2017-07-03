function EdgeGen(Ek,Emin,Emax,Ep,Epc,r,TOL,JR)
% This program generates an idealized hydrogenic ionization-edge profile
% of the form AE^-r but with plural (plasmon+core) scattering added by 
% convolution with a Poisson series of delta-function peaks, to give 
% a series of steps with the correct relative heights; see Eq.(3.117) 
% and Fig. 3.33.
% Background is included, with same exponent r.
% The order n of plasmon scattering is limited by the requirement that
% AE^-r power law holds only for E > 30 eV
%
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n---------------EdgeGen----------------\n\n');

if(nargin < 8)
    fprintf('Alternate Usage: EdgeGen(Ek,Emin,Emax,Ep,Epc,r,TOL,JR)\n\n');
    
    Ek = input ('Edge energy (eV) = ');
    Emin = input('First coreloss channel (eV) = ');
    Emax = input('Last coreloss channel (eV) = ');
    Ep = input('Plasmon energy (eV) = ');
    Epc = input('eV/channel = ');
    r = input('Parameter r (e.g. 4) = ');
    TOL = input('thickness/inelastic-MFP = ');
    JR = input('Jump Ratio = ');
else
    fprintf('Edge energy (eV) = %g\n',Ek);
    fprintf('First coreloss channel (eV) = %g\n',Emin);
    fprintf('Last coreloss channel (eV) = %g\n',Emax);
    fprintf('Plasmon energy (eV) = %g\n',Ep);
    fprintf('eV/channel = %g\n',Epc);
    fprintf('Parameter r (e.g. 4) = %g\n',r);
    fprintf('thickness/inelastic-MFP = %g\n',TOL);
    fprintf('Jump Ratio = %g\n',JR);
end;

A=Ek.^r.*exp(TOL);

Ecore = Emin:Epc:Emax;
Elow = Ecore - Emin + 1e-5;
%outcore = -A.*E.^-r;
core = zeros(size(Ecore));
low = zeros(size(Elow));

%initialize background
%core = A.*Ecore.^-r;
B=0;

%Calculate the maximum number of iterations using Emin
n = floor((Emin-30)./Ep);
fprintf('\nCalculated order n = %d\n',n);

for i=0:n-1
    J = A.*((Ecore - i*Ep).^-r).*(TOL.^i).*exp(-TOL)./factorial(i);
   
    maskcore=(Ecore-i*Ep) < Ek;

    J(maskcore) = 0; 
    
    B = B + A.*((Ecore - i*Ep).^-r).*(TOL.^i).*exp(-TOL)./factorial(i);

    core = core+J;
   
    masklow = Elow>=Ep*i-Emin+Ek;
    ploc = find(masklow,1,'first');
    low(ploc) = low(ploc) + TOL.^i./factorial(i);
end;

%Target Jump Background Intensity

TJBI = A.*Ek.^-r.*exp(-TOL)./JR;

%Actual Jump Background Intensity
CJBI = B(find(Ecore>=Ek,1,'first'));

%Adjusted Background
B = B .* TJBI./CJBI;

%Add background to Edge
core = core + B;

figure;
plot(Elow,low);
title('Low-loss spectrum','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('probability');
figure;
plot(Ecore,core);
title('Core-loss + background intensity','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('core-loss intensity');
%[E2,ignore,outPSD] = specgen(Ep,1,1,TOL,1000,0,0,Epc,length(E),0,0);
fid_core = fopen('EdgeGen.cor','w+');
fid_low = fopen('EdgeGen.low','w+');
fprintf(fid_core,'%g %g\n',[Ecore;core]);
fprintf(fid_low,'%g %g\n',[Elow;low]);

end