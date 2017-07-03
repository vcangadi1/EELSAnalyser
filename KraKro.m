function KraKro(infile,a0,e0,beta,ri,nloops,delta)
%     Kramers-Kronig analysis using Johnson method 
%     Program generates output into the 5-column file KRAKRO.DAT
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf('\n--------------KraKro-----------------\n\n');

%Read spectrum from input file
if(nargin < 1)
    fprintf('Alternate Usage: KraKro(''InFile'',A0,E0,Beta,RefIndex,Iterations,delta)\n\n');

    infile = input('Name of input file (e.g. Drude.ssd): ','s');
else
    fprintf('Name of input file: %s\n',infile);
end
data = ReadData(infile,2);

%Acquire initial settings (if not included in input parameters)
if(nargin < 7)
    a0 = input('Zero-loss sum (1 for Drude.ssd): ');
    e0 = input('E0(keV): ');
    beta = input('BETA(mrad): ');
    ri = input('ref.index: ');
%    nf = input('FFT-array multiplier (e.g. 4): ');
    nloops = input('no. of iterations: ');
    delta = input('stability parameter (0.1 - 0.5 eV): ');
else
    fprintf('Zero-loss sum (1 for Drude.ssd): %g\n',a0);
    fprintf('E0(keV): %g\n',e0);
    fprintf('BETA(mrad): %g\n',beta);
    fprintf('ref.index: %g\n',ri);
    fprintf('no. of iterations: %g\n',nloops);
    fprintf('stability parameter (0.1 - 0.5 eV): %g\n',delta);
    
end

%Calculate NN based on size of input file
dsize = length(data);
nn = 2^fix(log2(dsize)+1)*4;  %add factor at end, shifts X lower
nlines=dsize;

%Assign data to SSD and pad unused space with zeroes
en=zeros(1,nn);
ssd = zeros(1,nn);
en(2:dsize+1) = data(:,1);
ssd(2:dsize+1) = data(:,2);
d = ssd;  % single-scattering distribution (intensity or probability)
epc=(en(5)-en(1))/4;  % eV/channel

t = e0*(1 + e0/1022.12)/(1 + e0/511.06)^2; %t=mv^2/2
rk0 = 2590*(1 + e0/511.06)*sqrt(2*t/511.06); %k0 (wavenumber)
tgt = e0*(1022.12 + e0)/(511.06 + e0); % 2.gamma.t
e = epc .* [1:nn-1]; % energy-loss values
fprintf(1,' nlines= %d , nn = %d, epc = %f\n',nlines,nn,epc);

%     Calculate Im(-1/EPS), Re(1/EPS), EPS1, EPS2 and SRFINT data:
for num=1:nloops;
       
    %     Apply aperture correction APC at each energy loss:
    area = sum(d(2:nn)).*epc; %integral of [(dP/dE).dE]  *** added epc
    apc=log(1+(beta .* tgt ./ e) .^2);
    d(2:nn) = d(2:nn) ./ apc;
    dsum = sum(d(2:nn)./e).*epc; % sum of counts/energy  ******add epc
    
    rk=dsum/1.571/(1 - 1/ri/ri); % normalisation factor  *** no epc
    tnm = 332.5*rk/(a0)*e0*(1 + e0/1022.12)/(1 + e0/511.06)^2; %*** no epc in denom
    tol = area/a0;
    rlam = tnm/tol;
    fprintf(1,' LOOP %d : t(nm) = %f , t/lambda = %f lambda(nm) = %f\n',num,tnm,tol,rlam);
    d = d ./ rk; % Im(-1/eps)
    imreps = d; % stored value, not to be transformed
    
    d = fft(d,nn); % Fourier transform      
    d = -2 .* imag(d) ./ nn; %Transfer sine coefficients to cosine locations:
    d(1:nn/2) = -d(1:nn/2);        
    d = fft(d,nn); % Inverse transform
    
    %       Correct the even function for reflected tail:
    dmid = real(d(nn/2));
    d(1:nn/2) = real(d(1:nn/2)) + 1 - dmid/2 .*((nn/2) ./([nn-1:-1:nn/2])).^2;
    d(nn/2+1:nn) =1+dmid .*((nn/2) ./([nn/2+1:nn])) .^2 ./2;

    %t = e0*(1+e0/1022.12)/(1+e0/511.06)^2;
    %rk0 = 2590*(1+e0/511.06)*sqrt(2*t/511.06);
    
    re = real(d(2:nn));
    den = re .*re + imreps(2:nn) .*imreps(2:nn);     
    eps1 = re ./ den;
    eps2 = imreps(2:nn) ./ den;
    
    %       Calculate surface energy-loss function and surface intensity:
    srfelf = 4 .*eps2./((1+eps1).^2+eps2.^2) - imreps(2:nn); %has double-peak!!
    %eps=complex(eps1,eps2);
    %srfelf=imag(-4./(1.+eps))- imreps(2:nn); %  gives SAME as above
    adep=tgt./(e+delta).*atan(beta.*tgt./e)-beta./1000./(beta.^2+e.^2./tgt.^2);
    % delta in range 0.1 to 0.5, according to Alexander&Crozier
    srfint = 2000.*rk./rk0./tnm.*adep.*srfelf;
    d(2:nn) = ssd(2:nn) - srfint; % correct ssd for surface-loss intensity

    d(1) = 0;
end;

%Limit data to requested NLINES
e = e(1:nlines);
eps1 = eps1(1:nlines);
eps2 = eps2(1:nlines);
re = re(1:nlines);
imreps = imreps(2:nlines+1); % Mike's change
srfelf = srfelf(1:nlines); 
srfint = srfint(1:nlines);
ssd = ssd(1:nlines);

%Write data to KraKro.dat
fout=fopen('KraKro.dat','w');
fprintf(fout,'%f %f %f %f %f\n', [e;eps1;eps2;re;imreps]);
fclose(fout);

%Plot EPS1, EPS2, RE, DI
figure;
plot(e,imreps(1:nlines),'k'); % imag(-1/eps)
hold on;
plot(e,re,'m'); % Re[1/eps]
plot(e,eps1,'r');
plot(e,eps2,'g');
plot(e,srfelf,'b');
legend('Imag(-1/eps)','Real(1/eps)','eps1','eps2','Im(-4/1+eps)');
title('KraKro','FontSize',12);
xlabel('Energy Loss [eV]');

%limit the yscale of plot to +/- 2* the elf peak
yScaleMax = max(imreps).*2;
ylim([-yScaleMax yScaleMax]);

hold off;

%Plot ssd,srfint
figure;
plot(e,ssd,'k'); 
hold on;
plot(e,srfint,'m'); 
%plot(e,eps1,'r');
%plot(e,eps2,'g');
%plot(e,srfelf,'b');
legend('ssd','srfint');
title('KraKro intensities','FontSize',12);
xlabel('Energy Loss [eV]');
hold off;

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


