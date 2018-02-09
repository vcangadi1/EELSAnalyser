function [CS,dsbyde] = DSBYDE_K( z,ek,delta1,e0,beta )
%     SIGMAK3 :  CALCULATION OF K-SHELL IONIZATION CROSS SECTIONS
%     USING RELATIVISTIC KINEMATICS AND A HYDROGENIC MODEL WITH
%     INNER-SHELL SCREENING CONSTANT OF 0.5 (last update: 01 May 2010)
%
%     INPUT DATA:
%          z -  atomic number of the element of interest
%         ek -  K-shell ionization energy, in eV
%       einc -  energy increment of output data, in eV
%         e0 -  incident-electron energy, in keV
%       beta -  maximum scattering angle (in milliradians)
%               contributing to the cross section
%
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

%fprintf(1,'\n---------------Sigmak3----------------\n\n');
if(nargin < 5)
    fprintf(1,'Alternate Usage: Sigmak3( Z, EK, Delta, E0, Beta)\n\n');
    
    z = input('Atomic number Z : ');
    ek = input('K-edge threshold energy EK(eV) : ');
    delta1 = input('Integration window Delta (eV) : ');
    e0 = input('Incident-electron energy E0(keV) : ');
    beta = input('Collection semi-angle Beta(mrad) : ');
else
    %fprintf('Atomic number Z : %g\n',z);
    %fprintf('K-edge threshold energy EK(eV) : %g\n',ek);
    %fprintf('Integration window Delta (eV) : %g\n',delta1);
    %fprintf('Incident-electron energy E0(keV) : %g\n',e0);
    %fprintf('Collection semi-angle Beta(mrad) : %g\n',beta);
end
einc = delta1/10;

r=13.606;
e = ek;
b = beta/1000;
t = 511060*(1-1/(1+e0/(511.06))^2)/2;
gg=1+e0/511.06;
p02=t/r/(1-2*t/511060);
f = 0;
s = 0;
sigma = 0;
%     integrate over scattering angle FOR EACH ENERGY LOSS:
dsbdep = 0;
dfprev = 0;
%fprintf(1,'\nE(eV)    ds/dE(barn/eV)  Delta(eV)   Sigma(barn)     f(0)\n');
%for  j=1:30
    qa021 = e^2/(4*r*t) + e^3/(8*r*t^2*gg^3);
    pp2 = p02 - e/r*(gg-e/1022120);
    qa02m = qa021 + 4*sqrt(p02*pp2)*(sin(b/2))^2;
    
    %   dsbyde IS THE ENERGY-DIFFERENTIAL X-SECN (barn/eV/atom)
    dsbyde = 3.5166e8*(r/t)*(r/e) * integral(@(x)gosfunc(e,exp(x),z),log(qa021),log(qa02m));
    dfdipl = gosfunc(e,qa021,z); %dipole value
    delta = e - ek;
    %if(j ~= 1)
        %s = log(dsbdep/dsbyde)/log(e/(e-einc));
        %sginc =(e*dsbyde-(e-einc)*dsbdep)/(1-s);
        sginc =(e*dsbyde-(e-einc)*dsbyde)/(1-0);
        
        sigma = sigma + sginc; % barn/atom
        f=f+(dfdipl+dfprev)/2*einc;
    %end;
    %fprintf(1,'%4g %17.6f %10d %13.2f %8.4f\n', e,dsbyde,delta,sigma,f);
    %if(round(delta,1) == round(delta1,1))
        CS = sigma;
    %end
    if(einc == 0)
        %return;
    end;
    if(delta >= delta1)
        if(sginc < 0.001*sigma)
            %break;
        end;
        einc = einc*2;
    end;
    e = e + einc;
    if(e > t)
        %break;
    end;
    dfprev = dfdipl;
    dsbdep = dsbyde;
%end

function out = gosfunc(E , qa02, z)
% gosfunc calculates (=DF/DE) which IS PER EV AND PER ATOM
% Note: quad function only works with qa02 due to IF statements in function
persistent r;
if(~isscalar(E) || ~isscalar(z))
    error('gosfunc: E and z input parameters must be scalar');
end;
r=13.606;
zs=1.0;
rnk=1;
if(z ~= 1)
    zs = z - 0.50;
    rnk=2;
end;
q = qa02./zs.^2;
kh2 = E./r./zs.^2 - 1;
akh = sqrt(abs(kh2));
if(akh<=0.1)
    akh = 0.1;
end;
if(kh2>=0.0)
    d = 1 - exp(-2.*pi./akh);
    bp = atan(2.*akh./(q-kh2+1));
    if(bp<0)
        bp = bp + pi;
    end;
    c = exp((-2./akh).*bp);
else
    %     SUM OVER EQUIVALENT BOUND STATES:
    d = 1;
    y =(-1./akh.*log((q+1-kh2+2.*akh)./(q+1-kh2-2.*akh)));
    c = exp(y);
end;
a =((q-kh2+1).^2 + 4.*kh2).^3;
out=128*rnk.*E./r./zs.^4.*c./d.*(q+kh2/3+1/3)./a./r;


