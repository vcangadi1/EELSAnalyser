function tKKs( inFile, E0, n, beta, I0, zlpMethod )
% Absolute Thickness from the K-K Sum Rule
% Assumes collection semi-angle << (Ep/E0)^0.5 (dipole scattering)
% The zero-loss peak is fitted to a Gaussian function and subtracted.
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011
% Version 10.11.26,  surface-mode correction delta_t set to zero

fprintf('   tKKs( ''inFile'',E0,RefIdx,Beta, I0, ''zlpMethod'')\n');
if(nargin < 5)
    inFile = input('Input data file: ','s');
    E0 = input('E0 (keV): ');
    n = input('Refractive Index (for metal/semimetal enter 0): ');
    beta = input('Collection semiangle (mrad): ');
    I0 = input('Zero-loss integral (enter 0 if spectrum has a ZLP): ');
    if(I0==0)
        zlpMethod = input('Enter ZLP Method (Gaussian,Actual,LeftSide,Smoothed)','s');
    end
else
    fprintf('Input data file: %s\n',inFile);
    fprintf('E0 (keV): %g\n',E0);
    fprintf('Refractive Index (For metal/semimetal enter 0): %g\n',n);
    fprintf('Collection angle (mrad): %g\n',beta);
    fprintf('Zero-loss integral (0 if spectrum has a ZLP): %g\n',I0);
    if(I0==0)
        fprintf('ZLP Method: %s\n',zlpMethod);
    end
end

if(n == 0) % if metal/semimetal set n = 1000
    n = 1000;
end;

thetar = 1000.*(50./E0./1000.).^0.5; % Bethe-ridge angle (mrad) for E=50 eV
if(beta >thetar) %approximate treatment for large collection angle 
    beta = thetar;
    fprintf('beta replaced by 50eV Bethe-ridge angle\n');
end;
    
[E,spec] = GetSpectrum(inFile); %read in spectrum from file (see below)

back = mean(spec(1:5));
eVperChan = E(2)-E(1); %eV per channel

if(I0==0) %calculate ZLP integral if input parameter = 0
    %zlpChan = findZeroLossPeak(spec); %find zlp channel (see below)
    zlpChan = find(E>=0,1,'first');
    zlpFWHM = calcFWHM(E, spec, zlpChan); %calculate FWHM of zlp (see below)
    spec = spec - back; %background needs to be removed after finding ZLP
    
    switch lower(zlpMethod)
        case 'gaussian'
            zlp = (spec(zlpChan) - back) .* exp(-(E - E(zlpChan)).^2./(2.* (zlpFWHM./2.35482).^2));
            
        case 'actual'
            zlpRightChan = zlpChan - 1 + findLocalMax(-spec(zlpChan:end),5);
            zlp = (E <= E(zlpRightChan)) .* spec;
            
        case 'leftside'
            zlp = zeros(size(spec));
            zlp(1:zlpChan*2-1) = [spec(1:zlpChan) fliplr(spec(1:zlpChan-1))];
            
        case 'smoothed'
            zlpRightChan = zlpChan - 1 + findLocalMax(-spec(zlpChan:end),5);
            zlp = (E <= E(zlpRightChan)) .* spec;
            zlp = zlp - ((0 < E) .* (E <= E(zlpRightChan))) .* spec(zlpRightChan).*E./E(zlpRightChan);
        otherwise
            error('ZLP reconstruction method unknown');
    end
    
    %calculate guassian function
    %
    %alternate: set zlp to actual peak in spec
    %
    %alternate: set zlp to left half + flipped
    
    
    specInelas = spec - zlp; %remove zlp from spectrum
    
    figure;
    hold on;
    %plot(E,spec,'r');
    plot(E,zlp,'b');
    plot(E,specInelas,'g');
    legend('ZLP','inelastic');
    axis tight;
    hold off;
    title('tKKs input data','FontSize',12);
    xlabel('Energy Loss [eV]');
    
    I0 = trapz(zlp).*eVperChan;  % zero-loss integral
    Ii = trapz(specInelas).*eVperChan; % inelastic integral
    It = I0 + Ii; % total integral
    C = 1 + 0.3 .* log(It./I0); % Eq(5.8)plural-scattering correction
    C = 1 + log(It./I0)./4. + (log(It./I0)).^2./18 + (log(It./I0)).^2./96.; 
    
else % if ZLP is missing and I0 is supplied as an input number
    spec = spec - back; 
    specInelas = spec;
    Ii = trapz(spec).*eVperChan; % spectrum sum
    C = 1; % assume that a spectrum with no ZLP is a SSD
end

delta_t = 8; % in nm, surface correction
a0 = 0.0529; % in nm
T = E0.*(1+E0./1022)./(1+E0./511).^2;
thetaE = (E./E0).*(E0+511)./(E0+1022); %in mrad

tCoeff = 2000.*a0.*T./(C.*I0.*(1 - n.^-2));  % eV
tInt = specInelas ./ (E .*  log(beta./thetaE)); % integrand, eV^-2
trap=trapz(tInt);
% figure;
% plot(E,real(tInt));
% axis tight;
% title('Integrand in Eq.(5.9)','FontSize',12);
% xlabel('Energy Loss [eV]');

delta_t = 0; % gives best results with Drude test data
t = tCoeff .* trapz(tInt).*eVperChan - delta_t; % Eq.(5.9)

fprintf(1,'specimen thickness(nm) = %g\n',t);
%fprintf(1,'I0 = %g\n',I0);
%fprintf(1,'C = %g\n',C);
if(C==1) % SSD with no ZLP
    fprintf(1,'t/IMFP = %g\n',Ii./I0);
    fprintf(1,'IMFP(nm) = %g\n',t./(Ii./I0));
else % spectrum with ZLP and plural scattering
    %fprintf(1,'It = %g\n',It);
    fprintf(1,'t/IMFP = %g\n',log(It./I0));
    fprintf(1,'IMFP(nm) = %g\n',t./log(It./I0));
end
fprintf(1,'-------------------------------\n');
end
 
function [E,spec] = GetSpectrum(inFile)
%general function to read in spectrum data from a data file
%function assumes 2 column input file

fidin=fopen(inFile);
data = fscanf(fidin,'%g%*c %g',[2,inf]);
fclose(fidin);
E = data(1,:);
spec = data(2,:);
%if(E(1)<=0)
%    E = E - E(1); 
%end;
%E = E(2:end);
%spec = spec(2:end);

%replace actual zero value with near zero
Ezero = find(E==0);
if(Ezero)
   E(Ezero)=1e-5;
end;

end

function zlpChan = findZeroLossPeak(spec)
% Returns zero loss peak channel from a spectrum
back=mean(spec(1:5)); %calculate background from first five data points
nzpre = find(spec>back.*5,1,'first'); %find where data starts to rise at least 5x 'back'
zlpChan = nzpre -1 + findLocalMax(spec(nzpre:end),5);
end


function fwhm = calcFWHM(E, spec, peakChan)
%Calculates FWHM from a spectrum and the location of a peak,

halfMax = spec(peakChan)./2;
x1 = find(spec(1:peakChan)>= halfMax,1,'first');
x2 = peakChan - 1 + find(spec(peakChan:end) <= halfMax,1,'first');
midE1 = ((halfMax-spec(x1-1)).*E(x1) + (spec(x1)-halfMax).*E(x1-1))./(spec(x1) - spec(x1-1));
midE2 = ((spec(x2-1)-halfMax).*E(x2) + (halfMax - spec(x2)).*E(x2-1))./(spec(x2-1)-spec(x2));

fwhm = E(x2)-E(x1);
%fwhm = midE2 - midE1;

end


function lm = findLocalMax(in,window)
lm = 0;
for k=1:length(in)-2*window+1;
    if(sum(in(k+window:k+2*window-1))<=sum(in(k:k+window-1)))
        lm = find(in==max(in(k:k+2*window-1)),1,'first');
        break;
    end;
end;
if(lm==0)
    lm = k;
    %error('findlocalmax: no maximum found');
end;
end
