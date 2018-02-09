function lenzplus(e0,e,z,beta,toli)

% LENZPLUS.m calculates Lenz x-secns for elastic and inelastic scattering,
% then fractions of scattering collected by an aperture, including plural
% scattering and broadening of the elastic and inelastic angular distributions
% For details, see Egerton "EELS in the EM" 3rd edition, Appendix B.
% Correction beta->sin(b) in expresssions for dsidb and dsedb [5 Nov 2012]

%Get E0(keV), Ebar(eV), Z, BeTa(mrad)
fprintf(1,'----------------------------------\n'); % start input
if(nargin < 4)
    e0 = input('Lenzplus(8-10-2010): incident energy E0(keV)= ');
    e = input('Ebar(eV) [Enter 0 for 6.75*Z]: ');
    z = input('atomic number Z = ');
    beta = input ('collection semi-angle Beta(mrad)= ');
end;
if(e==0)
    e=6.75*z;
end;
fprintf(1,'E0(keV), Ebar(eV), Z, BeTa(mrad) are: %g, %g, %g, %g\n\n',e0,e,z,beta);

gt=500*e0*(1022+e0)/(511+e0);
te=e/2/gt;
a0=.0529;
gm=1+e0/511;
vr=sqrt(1-1/gm/gm);
k0=2590*gm*vr;
coeff=4*gm*gm*z/a0/a0/k0^4;
r0=.0529/z^.3333; % units of nm
t0=1/k0/r0;
fprintf(1,'Theta0 = %0.4E rad \t\t\t\t\t ThetaE = %0.4E rad\n',t0,te);
b=beta/1000;
b2=b*b;
te2=te*te;
t02=t0*t0;
dsidom=coeff/(b2+te2)/(b2+te2)*(1-t02*t02/(b2+te2+t02)/(b2+te2+t02));
dsidb=2*3.142*sin(b)*dsidom;
%t1=b2/te2/(b2+te2);
%t2=(2*b2+2*te2+t02)/(b2+te2)/(b2+te2+t02);
%t3=-(t02+2*te2)/te2/(t02+te2);
%t4=(2/t02)*log((b2+te2)*(t02+te2)/te2/(b2+t02+te2));
%sigin=3.142*coeff*(t1+t2+t3+t4);
sigin=8*3.142*gm*gm*z^0.333/k0/k0*log((b2+te2)*(t02+te2)/te2/(b2+t02+te2));
%silim=3.142*coeff*2/t02*log(t02/te2); %asymptotic inelastic
silim=16*3.142*gm*gm*z^0.333/k0/k0*log(t0/te);%asymptotic inelastic
f1i=sigin/silim;
%dsedom=z*coeff/(b2+t02)^2; % corrected from EELS2
dsedom=z*coeff/(sin(b/2)*sin(b/2)+sin(t0/2)*sin(t0/2))^2; % no small-angle
dsedb=dsedom*2*3.142*sin(b); %diffl. elastic
selim=4*3.142*gm*gm*z^1.333/k0/k0; %asymptotic elastic
f1e=1/(1+t02/b2);
sigel=f1e*selim;

fprintf(1,'dSe/dOmega = %0.4E nm^2/sr \t\t\t dSi/dOmega = %0.4E nm^2/sr\n',dsedom,dsidom);
fprintf(1,'dSe/dBeta = %0.4E nm^2/rad \t\t\t dSi/dBeta = %0.4E nm^2/rad\n',dsedb,dsidb);
fprintf(1,'Sigma(elastic) = %0.4E nm^2 \t\t\t Sigma(inelastic) = %0.4E nm^2\n',sigel,sigin);
fprintf(1,'F(elastic) = %0.4E \t\t\t\t\t F(inelastic) = %0.4E \n',f1e,f1i);
nu=silim/selim;
fprintf (1,'total-inelastic/total-elastic ratio = %0.4E \n\n',nu);

%Get t/lambdaI
if(nargin<5)
    toli = input('Enter t/lambda(inelastic) or 0 to quit: ');
end;
if(toli ~= 0)
    
    fprintf('t/lambda(beta)= %0.4E\n\n',toli*f1i);
    
    tole=toli/nu;
    xe=exp(-tole);
    xi=exp(-toli);
    fie=f1e*f1i;
    pun=xe*xi;
    pel=(1-xe)*xi*f1e;
    pz=pun+pel;
    pin=xe*(1-xi)*f1i;
    pie=(1-xi)*(1-xe)*fie;
    pi=pin+pie;
    
    fprintf(1,'p(unscat) = %0.4E \t\t P(el) = %0.4E neglecting elastic broadening\n',pun,pel);
    fprintf(1,'p(inel) = %0.4E \t\t\t P(in+el) = %0.4E neglecting inelastic broadening\n',pin,pie);
    fprintf(1,'I0/I = %0.4E \t\t\t\t Ii/I = %0.4E neglecting angular broadening\n',pz,pi);
    pt=pz+pi;
    lr=log(pt/pz);
    fprintf(1,'ln(It/I0) = %0.4E without broadening\n\n',lr);
    
    f2e=1/(1+1.7^2*t02/b2);
    f3e=1/(1+2.2^2*t02/b2);
    f4e=1/(1+2.7^2*t02/b2);
    pe=xe*(tole*f1e+tole^2*f2e/2+tole^3*f3e/6+tole^4*f4e/24);
    peni=pe*xi;
    pu=xi*xe;
    rz=pu+peni; %'unscattered and el/no-inel compts.
    %pel=xi*xe*(exp(tole*f1e)-1); %not used
    %pz=pun+pel; %not used
    pi=xi*(exp(toli*f1i)-1);
    pine=xe*pi;
    pie=pi*pe;
    ri=pine+pie;
    
    fprintf(1,'P(unscat) = %0.4E \t\t P(el only) = %0.4E with elastic broadening\n',pu,peni);
    % ang distrib of inel+el taken same as broadened elastic
    fprintf(1,'P(inel only) = %0.4E \t\t P(in+el) = %0.4E with inelastic broadening\n',pine,pie);
    fprintf(1,'I0/I = %0.4E \t\t\t\t Ii/I = %0.4E with angular broadening\n',rz,ri);
    rt=rz+ri;
    lr=log(rt/rz);
    fprintf(1,'ln(It/I0) = %0.4E with angular broadening\n',lr);
end;
end