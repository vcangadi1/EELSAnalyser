function Drude(ep,ew,eb,epc,e0,beta,nn,tnm)
%Given the plasmon energy (ep), plasmon FWHM (ew) and binding energy (eb), 
%this program generates:
%EPS1, EPS2 from modified Eq. (3.40), ELF=Im(-1/EPS) from Eq. (3.42),
%single scattering from Eq. (4.26) and SRFINT from Eq. (4.31)
%The output is e,ssd into the file Drude.ssd (for use in Flog etc.) 
%and e,eps1 ,eps2 into Drude.eps (for use in Kroeger etc.)
% Gives probabilities relative to zero-loss integral (I0 = 1) per eV
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011)
% Version 10.11.26

fprintf('   Drude(ep,ew,eb,epc,e0,beta,nn,tnm)\n');
if(nargin~=8)
    ep = input('plasmon energy (eV): ');
    ew = input('plasmon width (eV) : ');
    eb = input('binding energy (eV), 0 for a metal : ');
    epc = input('ev per channel : ');
    e0 = input('incident energy E0(kev) : ');
    beta = input('collection semiangle beta(mrad) : ');
    nn = input('number of data points : ');
    tnm = input('thickness(nm) : ');
else
    fprintf('plasmon energy (eV): %g\n',ep);
    fprintf('plasmon width (eV) : %g\n',ew);
    fprintf('binding energy (eV): %g\n',eb);
    fprintf('ev/channel : %g\n',epc);
    fprintf('E0(kev) : %g\n',e0);
    fprintf('beta(mrad) : %g\n',beta);
    fprintf('number of data points : %g\n',nn);
    fprintf('thickness(nm) : %g\n',tnm);
    
end;
b = beta./1000.; %rad
T = 1000..*e0.*(1.+e0./1022.12)./(1.+e0./511.06).^2; %eV
tgt = 1000..*e0.*(1022.12 + e0)./(511.06 + e0); %eV
rk0 = 2590. .*(1.+e0./511.06).*sqrt(2..*T./511060);
fideps=fopen('Drude.eps','w');
fidssd=fopen('Drude.ssd','w');

iw = 2:nn;
e = epc.*(iw - 1);
eps = 1 - ep.^2./(e.^2-eb.^2+e.*ew.*1i);
eps1 = real(eps);
eps2 = imag(eps);
%eps1 = 1. - ep.^2./(e.^2+ew.^2);
%eps2 = ew.*ep.^2./e./(e.^2+ew.^2);
elf = ep.^2.*e.*ew./((e.^2-ep.^2).^2.+(e.*ew).^2);
rereps = eps1./(eps1.*eps1+eps2.*eps2);
the = e./tgt; % varies with energy loss!
%srfelf = 4..*eps2./((1+eps1).^2+eps2.^2) - elf; %equivalent
srfelf=imag(-4./(1.+eps))-elf; % for 2 surfaces
angdep = atan(b./the)./the - b./(b.*b+the.*the);
srfint = angdep.*srfelf./(3.1416.*0.0529.*rk0.*T); % probability per eV
anglog = log(1.+ b.*b./the./the);
volint = tnm./3.1416./0.0529./T./2..*elf.*anglog; % probability per eV
ssd = volint + srfint;

%fprintf(fidssd,['%0.15g %0.15g %0.15g %0.15g \n'], [e;volint;srfint;ssd]);
fprintf(fidssd,['%0.15g %0.15g\n'], [e;ssd]);
fprintf(fideps,['%0.15g %0.15g %0.15g \n'], [e;eps1;eps2]);
fclose(fidssd);
fclose(fideps);
%fprintf(1,'For Ep(eV) = %f, width(eV) = %f, Eb(eV) = %f, eV/ch = %f \n',ep,ew,eb,epc)
%fprintf(1,'beta(mrad) = %f, E0(keV) = %f, t(nm) = %f, #chan = %f\n',beta,e0,tnm,nn)

%Integrate over all energy loss 
Ps = trapz(e,srfint); % 2 surfaces but includes negative begrenzungs contribn.
Pv = trapz(e,volint); % integrated volume probability
lam = tnm/Pv; % does NOT depend on free-electron approximation (no damping). 
lamfe = 4..*0.05292.*T./ep./log(1+(b.* tgt ./ ep) .^2); % Eq.(3.44) approximation
fprintf(1,'Ps(2surfaces+begrenzung terms)=%g,Pv=t/lambda(beta)= %g\n',Ps,Pv);
fprintf(1,'Volume-plasmon MFP(nm) = %g, Free-electron MFP(nm) = %f\n',lam,lamfe);
fprintf(1,'--------------------------------\n');

%Plot E, EPS1, EPS2, bulk and surface energy-loss functions
figure;
plot(e,eps1,'r');
hold on;
plot(e,eps2,'g');
plot(e,elf,'k');
plot(e,srfelf,'b');
plot(e,rereps,'m');
legend('eps1','eps2','Im[-1/eps]','Im[(-4/(1+eps)]','Re[1/eps]');
title('Drude dielectric data','FontSize',12);
xlabel('Energy Loss [eV]');
%limit the yscale of plot to +/- 2* the elf peak
yScaleMax = elf(find(e>=ep,1,'first')).*2;
ylim([-yScaleMax yScaleMax]);

hold off;

%Plot volume, surface and total intensities
figure;
plot(e,volint,'r');
hold on;
plot(e,srfint,'g');
plot(e,ssd,'b');
legend('volume','surface','total');
title('Drude probabilities','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('dP/dE [/eV]');
%ylim([-10 10]);
hold off;

end


