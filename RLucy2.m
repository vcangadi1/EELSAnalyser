function RLucy2(specFile, kernelFile, niter)
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011
% Revised version (Nov 2011) by Yongkai Zhou deals correctly with spectra
% that do not contain a zero-loss peak.

    fprintf(1,'\n----------------RLucy2---------------\n\n');
if(nargin < 3)
    fprintf('Alternate Usage: RLucy2(''specFile'', ''kernelFile'', numIterations)\n\n');

    specFile = input('RLucy2: Spectrum data file name (e.g. SpecGen.psd): ','s');
    kernelFile = input('Kernel file name (leave blank to generate from spectrum): ','s');   
    niter = input('Number of iterations (e.g. 15): ');
else
    fprintf('RLucy2: Spectrum data file name: %s\n',specFile);
    fprintf('Kernel file name (generate from spectrum if blank): %s\n',kernelFile);   
    fprintf('Number of iterations: %g\n',niter);    
end;

%read in spectrum file 
data = ReadData(specFile,2);

nd = length(data);
e = data(:,1);
spec = data(:,2);

back=mean(spec(1:5)); %calculate background from first five data points


if(isempty(kernelFile))
    %     Find zero-loss channel:
    nzpre = find(spec>back.*5,1,'first'); %find where data starts to rise at least 5x 'back'
    nz = nzpre -1 + findLocalMax(spec(nzpre:nd),5);
    % Create kernel from first half of zero loss peak
    kernel = [spec(1:nz) ;flipud(spec(1:nz-1))];
else
    % read in kernel file
    data = ReadData(kernelFile,2);
    kernel = data(:,2);
    ndkernel = length(kernel);
    %     Find zero-loss channel:
    nzpre = find(kernel>back.*5,1,'first'); %find where data starts to rise at least 5x 'back'
    nz = nzpre -1 + findLocalMax(kernel(nzpre:ndkernel),5);
end;
ksize = length(kernel); %kernel size

% pad kernel if it is smaller than spec
if(ksize<nd)
    kernel(ksize+1:nd) = back;
end;

kernelOrig = kernel; %keep copy of original kernel

%shift zero loss peak to start
ptm = circshift(kernel,-nz+1); 

% nomalize kernel
ptm = ptm./sum(ptm); 

kernel = fft(ptm);

% set starting spectrum (o(k)) as spec
% you may also set it as a constant value (e.g. orr(1:nd) = 1; ) or results you previous done
orr = spec;

%  set up plk
ptm = fft(orr);
ptm = ptm .* kernel;
plk = ifft(ptm);

fdk = 0;
%  start deconvolution
for iter = 1:niter;

    fnum = spec + fdk;
    fden = fdk;
    % check if above code can be removed from for loop
    
    fden = fden + plk;
    ptm = fnum;
    ptm(fden~=0) = ptm(fden~=0) ./ fden(fden~=0);

    plk = fft(ptm);
    ptm = kernel;
    ptm = ptm .* plk;
    plk = ifft(ptm);
    orr = orr .* plk;
    ptm = fft(orr);
    ptm = ptm .* kernel;
    plk = ifft(ptm);

end;

%Plot results
figure;
plot(e,kernelOrig);
title('RLucy Kernel','FontSize',12);
ylabel('Counts');

figure;
plot(e,spec,'g');
hold on;
plot(e,real(orr),'b');
title('RLucy Output','FontSize',12);
legend('Original Spectrum','Sharpened Spectrum');
xlabel('Energy Loss [eV]');
ylabel('Counts');
hold off;

%fidin=fopen('kernel.dat','w');
%fprintf(fidin,'%g %g\n',[e;kernelOrig]);
%fclose(fidin);

end

function lm = findLocalMax(in,window)
lm = 0;
for k=1:length(in);
    if(sum(in(k+window:k+2*window-1))<sum(in(k:k+window-1)))
        lm = find(in==max(in(k:k+2*window-1)),1,'first');
        break;
    end;
end;
if(lm==0)
    error('findlocalmax: no maximum found');
end;
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
