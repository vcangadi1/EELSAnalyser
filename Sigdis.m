function Sigdis(Z,A,Ed,E0)

% sigdis.m calculates cross sections for bulk atomic displacement or 
% surface sputtering for both SPHERICAL and PLANAR escape potentials, 
% based on an analytical formula (Banhart, 1999; Eq.5) that uses the
% McKinley-Feshbach (1948) approximation, valid for Z < 28
% For Z>28, the Rutherford value should be used as a better approximation.
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n-------------Sigdis------------\n\n'); % start input
fprintf(1,'sigdis: Atomic-displacement cross sections:\n'); 
 
if(nargin<4)
    fprintf('Alternate Usage: Sigdis(Z,A,Ed,E0)\n\n');

    Z = input('Atomic number Z : ');
    A = input('Atomic weight A : ');
    Ed = input('Surface or bulk displacement energy Ed(eV) : ');
    E0 = input('Incident-electron energy E0(keV) : ');
else
    fprintf('Atomic number Z : %g\n',Z);
    fprintf('Atomic weight A : %g\n',A);
    fprintf('Surface or bulk displacement energy Ed(eV) : %g\n',Ed);
    fprintf('Incident-electron energy E0(keV) : %g\n',E0);    
end;

Al = Z / 137;
A0 = 5.29e-11;
R = 13.606; % bohr radius in m, rydberg energy in ev
%evfac = 2000 * E0 * (E0 + 1022) / 511; % rhs factor in eq.(5.17)
t = E0 * (1 + E0 / 1022) / (1 + E0 / 511) ^ 2;
b = sqrt(2 * t / 511);
newrf = (1 - b * b) / b ^ 4;
Emax = (E0 / A) * (E0 + 1022) / 465.7; % originally /460 from reimer
E0min = 511 * (sqrt(1 + A * Ed / 561) - 1);% threshold in keV
fprintf(1, 'Emax(eV) = %g eV, threshold = %g keV\n', Emax, E0min);
coef = 4 * Z ^ 2 * R ^ 2 / (511000) ^ 2;
Emin = sqrt(Ed * Emax); %for planar potential, otherwise Emin = Ed
fprintf(1,'Emin(planar potential) = %g eV\n',Emin);
x = Emax / Ed; % spherical potential
xp = Emax / sqrt(Ed * Emax); % planar potential
sdc = .2494 * Z ^ 2 * newrf * (x - 1);
pdc = .2494 * Z ^ 2 * newrf * (xp - 1);
fprintf(1,'Rutherford value (spherical escape potential)= %g barn\n',sdc);
fprintf(1,'Rutherford value (planar escape potential)= %g barn\n',pdc);
sqb = 1 + 2 * pi * Al * b + (b * b + pi * Al * b) * log(x);
brace = 1 + 2 * pi * Al * b / sqrt(x) - sqb / x;
sdmf = 9.999999E+27 * coef * x * pi * A0 * A0 * (1 - b * b) / b ^ 4 * brace;
fprintf(1,'McKinley-Feshbach-Mott (spherical potential)= %g barn\n',sdmf); 
psqb = 1 + 2 * pi * Al * b + (b * b + pi * Al * b) * log(xp); 
pbrace = 1 + 2 * pi * Al * b / sqrt(xp) - psqb / xp;
pdmf = 9.999999E+27 * coef * xp * pi * A0 * A0 * (1 - b * b) / b ^ 4 * pbrace;
fprintf(1,'McKinley-Feshbach-Mott (planar potential) = %g barn\n',pdmf);

end

