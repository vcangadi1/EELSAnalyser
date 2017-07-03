function [core,back,spectrum] = Afit(infile,eprestart,eprewidth,epoststart,epostwidth,outcore,outback)
% Program AFit for fitting background in EELS spectra
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n---------------Afit--------------\n\n');

%Read spectrum from input file
if(nargin<1)
    fprintf('Alternate Usage: Afit(''infile'',eprestart,eprewidth,epoststart,epostwidth,outcore,outback)\n\n');
    infile=input('Input file: ','s');
else
    fprintf('Input file: %s\n',infile);
end
spectrum = ReadData(infile,2);

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
core = core(corefilt,:);

%Plot spectrum, core, and fitted curve
figure;
plot(spectrum(:,1),spectrum(:,2),'k','LineWidth',2);
hold on;
title('AFit','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Counts');
plot(core(:,1),core(:,2),'g','LineWidth',2);
plot(back(:,1),back(:,2),'r','LineWidth',2);
legend('Spectrum','Core','AFit');
hold off;

%Ask for output file names if none provide with input paramaters
if(nargin<7)
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

function outdata = ReadData(infile,cols)
% Reads in data file with predetermined number of columns
% Inputs
% infile: file name string
% cols: number of columns the data is assumed to have.

fidin=fopen(infile);
if(fidin == -1)
    error(['Filename: ''',infile,''' could not be opened']);
end
fprintf('Data file ''%s'' is assumed to have %d columns\n',infile,cols);
outdata = fscanf(fidin,'%g%*c',[cols,inf]);
fclose(fidin);
outdata = outdata.';

end
