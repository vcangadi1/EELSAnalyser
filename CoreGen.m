function [low_loss_spectrum,core_loss_spectrum] = CoreGen(Ek,Emin,Emax,Ep,Epc,r,TOL)
% This program generates an idealized hydrogenic ionization-edge profile
% of the form AE^-r but with plural (plasmon+core) scattering added by 
% convolution with a Poisson series of delta-function peaks, to give 
% a series of steps with the correct relative heights.
% It can be used as input to test the Frat.m deconvolution program.
% 
% See Eq.(3.117) and Fig. 3.33
% in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n----------------CoreGen---------------\n\n');

% get input data if not already provided in function parameters
if(nargin < 6)
    fprintf('Alternate Usage: CoreGen(Ek,Emin,Emax,Ep,Epc,r,TOL)\n\n');
    
    Ek = input ('Edge energy (eV) = ');
    Emin = input('First coreloss channel (eV) = ');
    Emax = input('Last coreloss channel (eV) = ');
    Ep = input('Plasmon energy (eV) = ');
    Epc = input('eV/channel = ');
    r = input('Parameter r (e.g. 4) = ');
    TOL = input('thickness/inelastic-MFP = ');
else
     fprintf('Edge energy (eV) = %g\n',Ek);
     fprintf('First coreloss channel (eV) = %g\n',Emin);
     fprintf('Last coreloss channel (eV) = %g\n',Emax);
     fprintf('Plasmon energy (eV) = %g\n',Ep);
     fprintf('eV/channel = %g\n',Epc);
     fprintf('Parameter r (e.g. 4) = %g\n',r);
     fprintf('thickness/inelastic-MFP = %g\n',TOL);
end;

A=Ek.^r.*exp(TOL);
n=10;
Ecore = Emin:Epc:Emax;
Elow = Ecore - Ek;
%outcore = -A.*E.^-r;
core = zeros(size(Ecore));
low = zeros(size(Elow));
for i=0:n-1
    J = A.*((Ecore - i*Ep).^-r).*(TOL.^i).*exp(-TOL)./factorial(i);
    maskcore=(Ecore-i*Ep)>=Ek;
    J = J.*maskcore;
    core = core+J;
    masklow = Elow>=Ep*i;%-Emin+Ek;
    low(find(masklow,1,'first')) = TOL.^i./factorial(i);
end;

low_loss_spectrum = low';
core_loss_spectrum = core';

figure;
plot(Elow,low);
title('Low-loss spectrum','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('probability');
figure;
plot(Ecore,core);
title('Core-loss intensity','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('core-loss intensity');
%[E2,ignore,outPSD] = specgen(Ep,1,1,TOL,1000,0,0,Epc,length(E),0,0);
fid_core = fopen('CoreGen.cor','w+');
fid_low = fopen('CoreGen.low','w+');
fprintf(fid_core,'%g %g\n',[Ecore;core]);
fprintf(fid_low,'%g %g\n',[Elow;low]);

end

