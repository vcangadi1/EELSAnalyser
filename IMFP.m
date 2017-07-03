function IMFP(Z, A, frac, alpha, beta, rho, E0)
% Generate inelastic mean free path based on parameterizations of
% Iakoubovskii (2008), with and without correction of thetaE expression
% Jin and Li (2006),  and Malis et al. (1988)
%
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n--------------IMFP-----------------\n\n');

if(nargin<3)
    fprintf('Alternate Usage: IMFPComp(Z, A, Frac, Alpha, Beta, Density, E0)\n');
    fprintf(' Where Z, A, and Frac are equal sized vectors\n\n')
    sumFrac = 0;
    idx = 0;
    while(sumFrac<1)
        idx = idx +1;
        fprintf('Enter values for element %d\n',idx);
        Z(idx) = input('  Enter atomic number Z (Enter 0 if not known): ');
        A(idx) = input('  Enter atomic weight A (Enter 0 if not known): ');
        frac(idx) = input(sprintf('  Enter compound fraction (%g remaining) : ',1-sumFrac));
        sumFrac = sumFrac + frac(idx);
        
    end
    
end
numElem = length(Z);
sumFrac = sum(frac);
if(sumFrac>1)
    
    fprintf('WARNING: Sum of element fractions exceeds 1, reducing faction of element %d by %g\n',numElem,sumFrac-1);
    frac(numElem) = frac(numElem) - (sumFrac - 1);
elseif(sumFrac<1)
    error('Sum of element fractions below 1');
end

fprintf('\nCompound Summary\n');
fprintf('Element: %d Z: %d A: %g Fraction: %g\n',[1:numElem;Z;A;frac]);
fprintf('\n');


if(nargin<7)
    alpha = input('Enter incident-convergence semi-angle alpha (mrad) : ');
    beta = input('Enter EELS collection semi-angle beta (mrad) : ');
    rho = input('Enter specimen density rho (g/cm3) (Enter 0 if not known): ');
    E0 = input('Enter incident energy E0 (keV) : ');
else
    fprintf('Incident-convergence semi-angle alpha (mrad) : %g\n',alpha);
    fprintf('EELS collection semi-angle beta (mrad) : %g\n',beta);
    fprintf('Specimen density rho (g/cm3) : %g\n',rho);
    fprintf('Incident energy E0 (keV) : %g\n',E0);
end
F = (1+E0/1022)/(1+E0/511)^2;
Fg= (1+E0/1022)/(1+E0/511);
TGT = 2.*Fg*E0;
fprintf(1,'2.gamma.T = %g\n\n',TGT);

a2 = alpha^2;
b2 = beta^2;

%caculate effective atomic number
if(Z)
    Zef = sum((frac.*Z.^1.3))./sum((frac.*Z.^0.3));
else
    Zef = 0;
end
fprintf(1,'Effective atomic number Z : %g\n',Zef);
if(A)
    Aef = sum((frac.*A.^1.3))./sum((frac.*A.^0.3));
else
    Aef = 0;
end
fprintf(1,'Effective atomic weight A : %g\n\n',Aef);

% Iakoubovskii et al.(1988)
if(rho)
    qE2 = (5.5*rho^0.3/(F*E0))^2;
    qc2 = 400;
    coeff = (11*rho^0.3)/(200*F*E0);
    num = (a2 + b2 + 2*qE2 + abs(a2-b2))*qc2;
    den = (a2 + b2 + 2*qc2 + abs(a2-b2))*qE2;
    LiI = 1/(coeff*log(num/den)); % Iakoubovskii original
    qE2g = (5.5*rho^0.3/(Fg*E0)).^2; % correction to thetaE
    num2 = (a2 + b2 + 2*qE2g + abs(a2-b2))*qc2;
    den2 = (a2 + b2 + 2*qc2 + abs(a2-b2))*qE2g;
    LiI2 = 1/(coeff*log(num2/den2)); % Iakoubovskii revised
    fprintf(1,'IMFP(Iakoubovskii&,2008) = %g nm\n',LiI);
    fprintf(1,'IMFP(Iakoubovskii revised) = %g nm\n\n',LiI2);
else
    fprintf('IMFP(Iakoubovskii) not calculated since density = 0\n\n');
end

% calculation of convergence correction
if(Zef)
    e=13.5.*Zef./2; % Koppe approximation for mean energy loss
    tgt=E0.*(1.+E0./1022.)./(1.+E0./511.); % keV
    thetae=(e+1e-6)./tgt; % in mrad, avoid NaN for e=0
    a2=alpha.*alpha.*1e-6 + 1e-10;  %radians^2, avoiding inf for alpha=0
    b2=beta.*beta.*1e-6; %radians^2
    t2=thetae.*thetae.*1e-6; %radians^2
    eta1=sqrt((a2+b2+t2).^2-4..*a2.*b2)-a2-b2-t2;
    eta2=2.*b2.*log(0.5./t2.*(sqrt((a2+t2-b2).^2+4.*b2.*t2)+a2+t2-b2));
    eta3=2.*a2.*log(0.5./t2.*(sqrt((b2+t2-a2).^2+4.*a2.*t2)+b2+t2-a2));
    eta=(eta1+eta2+eta3)./a2./log(4../t2);
    f1=(eta1+eta2+eta3)./2./a2./log(1.+b2./t2);
    f2=f1;
    if(alpha./beta>1)
        f2=f1.*a2./b2;
    end;
    bstar=thetae.*sqrt(exp(f2.*log(1.+b2./t2))-1.); % mrad
    fprintf(1,'F1 = %g\n',f1);
    fprintf(1,'F2 = %g\n',f2);
    fprintf(1,'beta* = %g mrad\n\n',bstar);
    
    % Malis et al. (1988)
    Em = 7.6.*Zef.^0.36;
    LiM=106.*F.*E0./Em./log(2.*bstar.*E0./Em);
    fprintf(1,'IMFP(Malis et al.) = %g  nm\n',LiM);
    
    % Jin & Li (2006) formula Em = 42.5Z^0.47 rho/A
    %bs =(log(num2/den2).*qE2).^0.5
    if(rho && Aef)
        Em = 42.5.*Zef.^0.47.*rho./Aef;
        LiJL=106.*F.*E0./Em./log(2.*bstar.*E0./Em);
        fprintf(1,'IMFP(Jin & Li) = %g  nm\n\n',LiJL);
    else
        fprintf('IMFP(Jin & Li) not calculated since A = 0 OR density = 0\n\n');
    end
else
    fprintf('IMFP(Malis et al.) & IMFP(Jin & Li) not calculated since Z = 0\n\n');
end


end

