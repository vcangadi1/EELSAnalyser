function Flog(infile,fwhm2)
%     FOURIER-LOG DECONVOLUTION USING EXACT METHODS (A) OR (B)
%     Single-scattering distribution is written to the file FLOG.DAT
%
% (Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011)


fprintf(1,'\n----------------Flog---------------\n\n');

%Read spectrum from input file
if(nargin < 1)
    fprintf('Alternate Usage: Flog(''Filename'',FWHM2)\n\n');
    infile = input('Name of input file (e.g. SpecGen.psd) = ','s');
%    nspec = input('Number of data points to be read [Enter 0 to read all data points] = ');
else
    fprintf('Name of input file = %s\n',infile);
end 
data = ReadData(infile,2);

nd = length(data);
e(1:nd) = data(:,1);
psd(1:nd) = data(:,2);
epc=(e(5)-e(1))/4;
back=mean(psd(1:5));

%Calculate nn based on size of input file and round up to next power of 2
nn = 2^fix(log2(nd)+1); 
d=zeros(1,nn);
z=zeros(1,nn);

%     Find zero-loss channel:

nzpre = find(psd>back.*5,1,'first'); %find where data starts to rise at least 5x 'back'
nz = nzpre -1 + findLocalMax(psd(nzpre:nd),5);

%     Find minimum in J(E)/E to separate zero-loss peak:

nsep = nz - 1 + findLocalMax(-psd(nz:nd),5);

dsum =   sum(psd(1:nsep));
a0 = dsum - back*(nsep);
nsep2 = nsep - nz + 1;
nfin = nd - nz + 1;

%     TRANSFER SHIFTED DATA TO ARRAY d :
d(1:nfin) = psd(nz:nfin+nz-1) - back;

%     EXTRAPOLATE THE SPECTRUM TO ZERO AT END OF ARRAY:
a1 = sum(d(nfin-9:nfin-5));
a2 = sum(d(nfin-4:nfin));
r = 2*log((a1+0.2)/(a2+0.1))/log((nd-nz)/(nd-nz-10));
if(r<=0)
    r=0;
end
dext = d(nfin)*((nfin-1)/(nn-2-nz))^r; % check (nfin-0.5) ??

cosb = 0.5 - 0.5.*cos(pi.*[0:nn-nfin]./(nn-nfin-nz-1));
d(nfin:nn)= d(nfin).*((nfin-1)./[nfin-1:nn-1]).^r - cosb.*dext; 


%     COPY ZERO-LOSS PEAK AND SMOOTH RIGHT-HAND END:
z(1:nsep2) = d(1:nsep2) - d(nsep2)./2 .* (1 - cos(pi./2.*[0:nsep2-1]./(nsep2-1)));
z(nsep2:2*nsep2-1)=d(nsep2) ./2 .*(1-cos(pi./2.*[nsep2-1:-1:0]./(nsep2-1)));

%     ADD LEFT HALF OF Z(E) TO END CHANNELS OF ARRAYS D AND Z:
d(nn+2-nz:nn) = psd(1:nz-1) - back;
z(nn+2-nz:nn) = psd(1:nz-1) - back;

fprintf(1,['NreaD,NZ,NSEP,BACK = %0.4g %0.4g %0.4g %0.4g \n'],nd,nz,nsep,back);
fprintf(1,['eV/channel = %0.4g,  zero-loss intensity = %0.4g \n'],epc,a0);
fwhm1=0.9394*a0/d(1);
%fprintf(1,' FWHM = %4.4g eV. \n',fwhm1*epc);
fprintf(1,' FWHM = %4.4g channels. \n',fwhm1);                                                                                                                                                        

if(nargin < 2)
    fwhm2 = input('Enter new FWHM or 0 to keep same ZLP: ');
    %fwev2 = input('Enter new FWHM or 0 to keep same ZLP: ');
    %fwhm2 = fwev2/epc;
else
    fprintf('New FWHM (0 to keep same ZLP): %g\n',fwhm2);

end

% Compute Fourier transforms
z = conj(fft(z,nn));
d = conj(fft(d,nn));

% Process the Fourier coefficients:
d = d + 1e-10;
z = z + 1e-10;
dbyz = log(d./z)/nn; % /nn for correct scaling
if (fwhm2==0) % use ZLP as reconvolution function
    d = z .* dbyz;
else
    x = [0:(nn/2-1) (nn/2):-1:1];
    x = 1.887 .* fwhm2 .* x ./ nn; 
    gauss = (x <= 9.0) .* exp(-x.*x); %original
    %gauss = exp(-x.*x); 
    d = dbyz .* gauss .* a0;
end

d = fft(d,nn);

% Write data to Flog.ssd
fidout=fopen('Flog.ssd','w+');
eout = epc.*[nz:nn-1+nz];
dout = real(d);
fprintf(fidout,'%8.15g %8.15g \n',[eout;dout]);
fclose(fidout);

%Plot ssd and psd
figure;
plot(eout+e(1),dout,'b');
hold on;
plot(e,psd,':r');
legend('SSD','PSD');
title('FLog deconvolution','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Count/channel');
hold off;

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
