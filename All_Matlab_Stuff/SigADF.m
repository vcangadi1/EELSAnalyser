function SigADF(Z,A,qn,qx,E0)

% sigadf.m calculates high-angle cross sections for high-angle elastic
% scattering, as utilized in an annular dark-field (ADF)detector 
% 
% based on an analytical formula (Banhart, 1999; Eq.5) using the
% McKinley-Feshbach (1948) approximation, valid for Z < 28
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, 
% with correction made (8 Sept. 2011) to Eq.(3.12f) and  to Mott x-secn.

fprintf(1,'\n------------SigADF-------------\n\n'); % start input
fprintf(1,'SigADF: HAADF elastic cross sections\n'); 
if(nargin<5)
    fprintf('Alternate Usage: SigADF(Z,A,minAng,maxAng,E0)\n\n');

    Z = input('Atomic number Z : ');
    A = input('Atomic weight A : ');
    qn = input('Minimum scattering angle(mrad) : ');
    qx = input('Maximum scattering angle(mrad) : ');
    E0 = input('Incident-electron energy E0(keV) : ');
else
    fprintf('Atomic number Z : %g\n',Z);
    fprintf('Atomic weight A : %g\n',A);
    fprintf('Minimum scattering angle(mrad) : %g\n',qn);
    fprintf('Maximum scattering angle(mrad) : %g\n',qx);
    fprintf('Incident-electron energy E0(keV) : %g\n',E0);    
end;

Al = Z / 137; % fine-structure constant
a0 = 5.29e-11; % in m
R = 13.606; % bohr radius in m, rydberg energy in ev
%evfac = 2000 * E0 * (E0 + 1022) / 511; % rhs factor in eq.(5.17)
t = E0 * (1 + E0 / 1022) / (1 + E0 / 511) ^ 2; % m0v^2/2
b = sqrt(2 * t / 511); % v/c
k0 = 2590E9*(1+E0/511)*b;  % m^-1
q0 = 1000*Z^0.3333/k0/a0; % Lenz screening angle in mrad

fprintf(1,'\nLenz screening angle = %g mrad\n',q0);
if(q0 >qn) 
    fprintf('WARNING: minimum angle < Lenz screening angle!\n');
end;

newrf = (1 - b * b) / b ^ 4; % relativistic factor
smin = (sin(qn/2000))^2;
smax = (sin(qx/2000))^2;
x = 1/smin - 1/smax; % spherical potential
sdc = .2494 * Z ^ 2 * newrf * x; %Rutherford
fprintf(1,'Rutherford cross section = %g barn\n',sdc);

coef = 4 * Z ^ 2 * R ^ 2 / (511000) ^ 2;
sqb = 1 + 2 * pi * Al * b + (b * b + pi * Al * b) * log(x);
brace = 1 + 2 * pi * Al * b / sqrt(x) - sqb / x;
sdmf = 9.999999E+27 * coef * x * pi * a0 * a0 * (1 - b*b) / b ^ 4 * brace;
fprintf(1,'McKinley-Feshbach-Mott cross section = %g barn\n',sdmf);


end
