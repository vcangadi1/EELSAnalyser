function CS = Sigmal3(z,delta1,e0,beta)
%     SIGMAL3 : CALCULATION OF L-SHELL CROSS-SECTIONS USING A
%     MODIFIED HYDROGENIC MODEL WITH RELATIVISTIC KINEMATICS.
%     see Egerton, Proc. EMSA (1981) p.198 & 'EELS in the TEM' 3rd Edition.
%     THE GOS IS REDUCED BY A SCREENING FACTOR RF, BASED ON DATA
%     FROM SEVERAL SOURCES; SEE ULTRAMICROSCOPY 50 (1993) p.22.
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

%fprintf(1,'\n----------------Sigmal3---------------\n\n');
global  IE3 XU IE1;

IE3=[73,99,135,164,200,245,294,347,402,455,513,575,641,710,779,855,931,1021,1115,1217,1323,1436,1550,1675];
XU=[.52,.42,.30,.29,.22,.30,.22,.16,.12,.13,.13,.14,.16,.18,.19,.22,.14,.11,.12,.12,.12,.10,.10,.10];
IE1=[118,149,189,229,270,320,377,438,500,564,628,695,769,846,926,1008,1096,1194,1142,1248,1359,1476,1596,1727];

if(nargin ~= 4)
    fprintf(1,'Alternate Usage:  sigmal3( Z, delta(eV), E0 (keV), beta (mrad))\n');
    
    z = input('Atomic number Z : ');
    delta1 = input('Integration window Delta(eV) : ');
    e0 = input('Incident-electron energy E0(keV) : ');
    beta = input('Collection semi-angle Beta(mrad) : ');
else
    %fprintf('Atomic number Z : %g\n',z);
    %fprintf('Integration window Delta(eV) : %g\n',delta1);
    %fprintf('Incident-electron energy E0(keV) : %g\n',e0);
    %fprintf('Collection semi-angle Beta(mrad) : %g\n',beta);
end

einc = delta1./10;
r = 13.606;
 iz = fix(z)-12;
 el3 = (IE3(iz));

e = el3;
b = beta/1000;
t = 511060*(1-1/(1+e0/(511.06))^2)/2;
gg = 1+e0/511.06;
p02 = t/r/(1-2*t/511060);
f = 0;
s = 0;
sigma = 0;
%fprintf(1,'\nE(eV)    ds/dE(barn/eV)  Delta(eV) Sigma(barn^2)     f(0)\n');

%     CALCULATE cross sections FOR EACH ENERGY LOSS:
for j=1:40
    qa021 = e^2/(4*t*r) + e^3/(8*r*t^2*gg^3);
    pp2 = p02-e/r*(gg-e/1022120);
    qa02m = qa021 + 4*sqrt(p02*pp2)*(sin(b/2))^2;

    dsbyde = 3.5166e8*(r/t)*(r/e) * quad(@(x)gosfunc(e,exp(x),z),log(qa021),log(qa02m));
    dfdipl = gosfunc(e,qa021,z);
    delta = e - el3;
    if(j ~= 1)
        s =  log(dsbdep/dsbyde)/log(e/(e-einc));
        sginc=(e*dsbyde-(e-einc)*dsbdep)/(1-s);
        sigma = sigma + sginc;
        %        SIGMA is the EELS cross section cm^2 per atom
        f = f +(dfdipl+dfprev)*einc/2;
         if(delta >= 10)
             %fprintf(1,'%4g %17.6f %10d %13.2f %8.4f\n', e,dsbyde,delta,sigma,f);
         end;
         if(round(delta) == round(delta1))
             CS = sigma;
         end
    end;
    if(delta >= delta1)
        if(sginc < 0.001*sigma)
            break;
        end;
        einc = einc*2;
    end;
    
    e = e + einc;
    if(e > t)
        e = e - einc;
        break;
    end;
    dfprev = dfdipl;
    dsbdep = dsbyde;
end;
%fprintf(1,'%g \t %g \t %g \t %g \t %g\n', e,dsbyde,delta,sigma,f);
end

function out = gosfunc(E , qa02, z)
% gosfunc calculates (=DF/DE) which IS PER EV AND PER ATOM
% Note: quad function only works with qa02 due to IF statements in function

global  IE3 XU IE1;

if(~isscalar(E) || ~isscalar(z))
    error('gosfunc: E and z input parameters must be scalar');
end;

r = 13.606;
zs = z  - 0.35*(8-1) - 1.7;
iz = fix(z)-12;
u = XU(iz);
el3 = (IE3(iz));
el1 = (IE1(iz));

q = qa02 ./ (zs .^2);
kh2 =(E ./ (r.*zs .^2)) - 0.25;
akh = sqrt(abs(kh2));
if(kh2 >= 0)
    d = 1 - exp(-2.*pi ./ akh);
    bp = atan(akh ./ (q-kh2 + 0.25));
    if(bp < 0)
        bp = bp + pi;
    end;
    c = exp((-2 ./ akh).*bp);
else
    d = 1;
    c=exp((-1 ./ akh).*log((q+0.25-kh2+akh) ./ (q+0.25-kh2-akh)));
end;
if(E-el1<=0)
    g=2.25.*q .^4-(0.75+3.*kh2).*q .^3+(0.59375-0.75.*kh2-0.5.*kh2 .^2).*q.*q...
        +(0.11146+0.85417.*kh2+1.8833.*kh2.*kh2+kh2 .^3).*q + 0.0035807...
        +kh2 ./ 21.333 + kh2.*kh2 ./ 4.5714 + kh2 .^3 ./ 2.4 + kh2 .^4 ./ 4;
    a =((q-kh2 + 0.25) .^2 + kh2) .^5;
else
    g=q .^3-(5 ./ 3.*kh2+11 ./ 12).*q .^2+(kh2.*kh2 ./ 3+1.5.*kh2+65 ./ 48).*q...
        +kh2 .^3 ./ 3+0.75.*kh2.*kh2+23 ./ 48.*kh2+5 ./ 64;
    a =((q-kh2 + 0.25) .^2 + kh2) .^4;
end;
rf =((E+0.1-el3) ./ 1.8 ./ z ./ z) .^u;
if(abs(iz-11)<=5 && E-el3<=20)
    rf=1;
end;
out=rf.*32.*g.*c ./ a ./ d.*E ./ r ./ r ./ zs .^4;

end
