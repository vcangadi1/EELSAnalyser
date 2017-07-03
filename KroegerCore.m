function [P,Pvol] = KroegerCore(edata,adata,epsdata,ee,thick)
%Core Kroeger function as defined in E&B Eq. 4

%Define constants
%ec = 14.4;
mel = 9.109e-31; % REST electron mass in kg
h = 6.626068E-34; % Planck's constant
hbar = h/2/pi;
c = 2.99792458E8; % speed of light m/s
bohr = 5.2918*10^-11; % Bohr radius in meters
e = 1.60217646E-19; % electron charge in Coulomb

%Calculate fixed terms of equation
va = 1 - (511 ./(511+ee)).^2; % ee is incident energy in keV
v = c.*sqrt(va);
beta = v./c;
%beta=0;
gamma = 1./sqrt(1-beta^2); %set = 1 to correspond to E+B & Siegle
momentum = mel.*v.*gamma; %used for xya, E&Bnhave no gamma 


%Define independant variables E, Theta
[E,Theta] = meshgrid(edata,adata);
%Define dielectric function variable eps
[eps,ignore] = meshgrid(epsdata,adata);

Theta2 = Theta.^2+1e-15;

ThetaE = E .*e./ momentum ./ v;
ThetaE2 = ThetaE.^2;

lambda2 = Theta2 - eps .* ThetaE2 .* beta.^2; %Eq 2.3
lambda = sqrt(lambda2);
if(~(real(lambda)>=0)) 
    error('negative lambda');
end;
%lambda = -lambda.*(imag(lambda)<0) + lambda .* (imag(lambda)>=0);
% According to Kröger real(lambda0) is defined as positive!
%lambda = complex(abs(real(lambda)),imag(lambda));

phi2 = lambda2 + ThetaE2; %Eq. 2.2
lambda02 = Theta2 - ThetaE2 .* beta.^2;  %eta=1 %Eq 2.4
lambda0=sqrt(lambda02);
if(~(real(lambda0)>=0))
    error('negative lambda0');
end;

de = thick.* E .*e./2./hbar ./ v; %Eq 2.5
%de = thick./2.*ThetaE./hbar;
xy = lambda.*de./ThetaE; %used in Eqs 2.6, 2.7, 4.4
lplus = lambda0.*eps + lambda.*tanh(xy);  %eta=1 %Eq 2.6
lminus = lambda0.*eps + lambda./tanh(xy);   %eta=1 %Eq 2.7

mue2 = 1 - (eps.*beta.^2); %Eq. 4.5
phi20 = lambda02 + ThetaE2; %Eq 4.6
phi201 = Theta2 + ThetaE2 .*(1-(eps+1).*beta.^2); %eta=1, eps-1 in E+B Eq.(4.7)

%Put all the pieces together...
Pcoef = e/(bohr*pi^2*mel*v^2);

Pv = thick.*mue2./eps./phi2;

Ps1 = 2.*Theta2.*(eps-1).^2./phi20.^2./phi2.^2; %ASSUMES eta=1
Ps2 = hbar./momentum;

%Eq 4.2
A1 = phi201.^2./eps;
A2 = sin(de).^2./lplus + cos(de).^2./lminus;
A = A1.*A2;

%Eq 4.3
B1 = beta.^2.*lambda0.*ThetaE.*phi201;
B2 = (1./lplus - 1./lminus).*sin(2.*de);
B = B1.*B2;

%Eq 4.4
C1 = -beta.^4.*lambda0.*lambda.*ThetaE2;
C2 = cos(de).^2.*tanh(xy)./lplus;
C3 = sin(de).^2./tanh(xy)./lminus;
C = C1.*(C2+C3);

Ps3 = A + B + C;

Ps = Ps1.*Ps2.*Ps3;

%Calculate P and Pvol (volume only)
P = real(Pcoef).*imag(Pv - Ps); %Eq 4.1
Pvol = real(Pcoef).*imag(Pv);


end
