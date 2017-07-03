function [core,back,spectrum] = Afit_curve1(eprestart,eprewidth,epoststart,epostwidth,outcore,outback)
% Program AFit for fitting background in EELS spectra
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n---------------Afit_curve--------------\n\n');

%Read spectrum from input file
si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' )
N = size(si_struct.image_data,3);
fprintf('\nLength of the spectrum z-axis : %d\n',N);
D = si_struct.zaxis.scale;
%fprintf('\nDispersion : %.2f\n',D);
%Origin = si_struct.zaxis.origin;
%fprintf('\nOrigin : %d\n',Origin);
offset = 0;
%Scale = (((0:N-1).* D +Origin+offset)).';
%for i = 1:16,
    %for j = 1:16,
        EELS_spectrum = si_struct.image_data(16,16,:);
        EELS_spectrum = reshape(EELS_spectrum,1,N);
    %end;
%end


of = -56;
Xscale = of;
sp = zeros([N,2]);
sp(:,1) = 1:N;
sp(:,2) = EELS_spectrum;

sp(1:offset,1) = 0;
sp(1:offset,2) = 0;

sp(1:N,1) = sp(1:N,1) ;
spectrum = zeros(size(sp));
spectrum(1:N,1) = sp(1:N,1);
spectrum(1:N,2) = sp(1:N,2);

fprintf(1,'\nEnergy dispersion = %f [eV]\n',spectrum(3,1) - spectrum(2,1));

%Acquire pre/post energy window settings (if not in input parameters)
if(nargin<5)
    eprestart=input('Pre-Edge energy window START [eV]: ');
    eprewidth=input('Pre-Edge energy window WIDTH [eV]: ');
    epoststart=input('Post-Edge energy window START [eV]: ');
    epostwidth=input('Post-Edge energy window WIDTH [eV]: ');
else
    fprintf('Pre-Edge energy window START [eV]: %g\n',eprestart);
    fprintf('Pre-Edge energy window WIDTH [eV]: %g\n',eprewidth);
    fprintf('Post-Edge energy window START [eV]: %g\n',epoststart);
    fprintf('Post-Edge energy window WIDTH [eV]: %g\n',epostwidth);
end

%Calculate sums of Pre and Post energy windows as defined by "efilter"
efilter = ((spectrum(:,1) >= eprestart) & (spectrum(:,1) <=(eprestart + eprewidth))) |((spectrum(:,1) >= epoststart) & (spectrum(:,1) <=(epoststart + epostwidth)));
lspectrum = log(spectrum);
sumx = sum(lspectrum(efilter,1));
sumxovery = sum(lspectrum(efilter,1) ./ lspectrum(efilter,2));
sumoneovery = sum(1 ./ lspectrum(efilter,2));
sumxsqovery = sum(lspectrum(efilter,1).^2 ./ lspectrum(efilter,2));
n=sum(efilter);

%Calculate A and R
d = sumxsqovery.*sumoneovery - sumxovery.*sumxovery;
r =(sumx.*sumoneovery - n.*sumxovery)./d;
a = exp(((n.*sumxsqovery./d - sumx.*sumxovery./d)));
fprintf(1,'\nFit coefficients I(E) = A*E^r\n');
fprintf(1, 'r = %g A = %g\n',r,a);

%Generate core and background curve data from A and R
back = spectrum;
back(:,2) = a.*spectrum(:,1).^r;
core(:,1) = spectrum(:,1);
core(:,2) = spectrum(:,2) - back(:,2);
corefilt = (core(:,1) >= (eprestart + eprewidth)) & (core(:,1) <= (epoststart + epostwidth)) & (core(:,2) > 0);
%core = core(corefilt,:);
dc = size(core);
%Plot spectrum, core, and fitted curve
figure;
plot((1:1024).*D -56+78,spectrum(:,2),'k','LineWidth',2);
hold on;
title('AFit','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Counts');
plot((1:1024).*D -56+78,core(:,2),'g','LineWidth',2);
plot((1:1024).*D -56+78,back(:,2),'r','LineWidth',2);
legend('Spectrum','Core','AFit');
hold off;

%Ask for output file names if none provide with input paramaters
if(nargin<6)
    outcore=input('filename for core: ','s');
    outback=input('filename for background: ','s');
else
    fprintf('filename for core: %s\n',outcore);
    fprintf('filename for background: %s\n',outback);
end;

%Save output to files
fcore = fopen(outcore, 'w');
fback = fopen(outback,'w');
fprintf(fcore,'%f %f\n',core');
fprintf(fback,'%f %f\n',back');
fclose(fcore);
fclose(fback);
end