function [ssd,psd] = Frat(low_loss_data,fwhm2,core_loss_data)
%     FOURIER-RATIO DECONVOLUTION USING EXACT METHOD (A)
%     WITH LEFT SHIFT BEFORE FORWARD TRANSFORM.
%     RECONVOLUTION FUNCTION R(F) IS EXP(-X*X) .
%     DATA IS READ IN FROM NAMED INPUT FILES
%     OUTPUT DATA APPEARS in a named output file as nn x-y PAIRS
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

%fprintf(1,'\n----------------Frat---------------\n\n');
% get input data if not already provided in function parameters
%if(nargin < 1)
%    fprintf('Alternate Usage: frat(''LLFile'',fwhm,''CLFile'')\n\n');

%    lfile = input ('Name of low-loss file (e.g. CoreGen.low) = ','s');
%    nread = input('Number of low-loss channels [Enter 0 to read all
%    Channels] = ');
%else
%    fprintf('Name of low-loss file = %s\n',lfile);
    
%end;
%if(nread == 0)
%    nread = inf;
%end;


%Read low-loss data from input file
%data = ReadData(lfile,2);
data = low_loss_data;

nd = length(data);
nn = 2^fix(log2(nd)+1); 

%set arrays to zero
lldata=zeros(1,nn);
e=zeros(1,nn); 
d=zeros(1,nn);


%assign data to arrays
e(1:nd) = data(:,1);
lldata(1:nd) = data(:,2);

epc=(e(5)-e(1))/4;
back = sum(lldata(1:5));
%     Set BACK=0. if zero-loss tail dominates first 5 channels
back = back + sum(lldata(1:5))/5;

%     Find zero-loss channel:
nz = find(lldata==max(lldata),1,'first');

%     Find minimum in J(E)/E to estimate zero-loss sum A0:
for i=nz:nd
    if(lldata(i+1)/(i-nz+1)>lldata(i)/(i-nz))
        break;
    end
    nsep=i;
end
sum_nsep = sum(lldata(1:nsep));
a0 = sum_nsep - back*(nsep);
nfin = nd-nz+1;

%     TRANSFER SHIFTED DATA TO ARRAY d:
d(1:nfin) = lldata(nz:nd)-back;

%     EXTRAPOLATE THE SPECTRUM TO ZERO AT channel nn:
a1 = sum(d(nfin-9:nfin-5));
a2 = sum(d(nfin-4:nfin));
r = 2*log((a1+0.2)/(a2+0.1))/log((nd-nz)/(nd-nz-10));
dend = d(nfin)*((nfin-1)/(nn-2-nz))^r;

cosb = 0.5 - 0.5.*cos(pi.*(0:nn-nfin)./(nn-nfin-nz-1));
d(nfin:nn)= d(nfin).*((nfin-1)./(nfin-1:nn-1)).^r - cosb.*dend; 

%     Compute total area:
at = sum(d(1:nn)); %This may be needed when calculating 'gauss'

%     Add left half of Z(E) to end channels in the array D(J):

d(nn+2-nz:nn) = lldata(1:nz-1) - back;

%{
fprintf(1,'ND,NZ,NSEP,DATA(NZ): \n');
fprintf(1,'%g %g %g %g\n', nd,nz,nsep,lldata(nz));
fprintf(1,'BACK,A0,DEND,EPC: \n');
fprintf(1,'%g %g %g %g\n',back,a0,dend,epc);
fwhm1=0.9394*a0/d(1)*epc;
fprintf(1,' zero-loss FWHM = %4.1f eV; \n\n',fwhm1);
%}
% get input data if not already provided in function parameters
%if(nargin < 3)
%    fwhm2 = input(' energy resolution of coreloss SSD (e.g. FWHM above) = ');
%    cfile = input('Name of coreloss file (e.g. CoreGen.cor) = ','s');
%    nc = input('Number of coreloss channels [Enter 0 to read ALL channels] = ');
%else
%    fprintf('Energy resolution of coreloss SSD (FWHM) = %g\n',fwhm2);
%    fprintf('Name of coreloss file = %s\n',cfile);
%end
% if(nc == 0)
%     nc = inf;
% end;
fwhm2=fwhm2/epc;

%Read CORE-loss data from input file
% fidin=fopen(cfile);
% data = fscanf(fidin,'%g%*c %g',[2,nc]);
% fclose(fidin);
%data = ReadData(cfile,2);
data = core_loss_data;
nc = length(data);

e(1:nc) = data(:,1);
c(1:nc) = data(:,2);
epc=(e(5)-e(1))/4;

%     EXTRAPOLATE THE SPECTRUM TO ZERO AT channel nn:
a1 = sum(c(nc-9:nc-5));
a2 = sum(c(nc-4:nc));
r = 2*log((a1+0.2)/(a2+0.1))/log(e(nc)/e(nc-9));
cend = a2/5*(e(nc-2)/(e(1)+epc*(nn-1)))^r;
cosb = 0.5 - 0.5.*cos(pi.*[0:nn-nc]./(nn-nc));
c(nc:nn)= a2./5.*(e(nc-2)./(e(1)+epc.*([nc-3:nn-3]))).^r - cosb.*cend; 
%fprintf(1,'%0.15g %0.15g %0.15g %0.15g %0.15g %0.15g \n', r,cend,c(nc),c(nn),a1,a2);

%     WRITE background-stripped CORE PLURAL SCATTERING DISTRIBUTION TO frat-psd.dat:
%fidout=fopen('Frat.psd','w');
eout = e(1)+epc.*(-1:nn-2);
cpout = real(c(1:nn));
%fprintf(fidout,'%8.15g %8.15g \n',[eout;cpout]);
%fclose(fidout);

psdnn = cpout';
psd = psdnn(1:size(core_loss_data,1));

d = conj(fft(d,nn));
c
c = conj(fft(c,nn));

%     Process the Fourier coefficients:
d = d + 1e-10;
c = c + 1e-10;
x = [0:(nn/2-1) (nn/2):-1:1];
x = 1.887 .* fwhm2 .* x ./ nn;
gauss = a0 ./ 2.718.^(x.^2)./nn;  
%Replace 'a0' by 'at' above to give equal AREAS in SSD and PSD. 
d = gauss.* c ./ d;

d = fft(d,nn);

%Write SSD to output file
% if(nargin < 4)
%     outfile = input('Name of output file (e.g. frat-ssd.dat) = ','s');
% else
%     fprintf('Name of output file = %s\n',outfile);
% end
%fidout=fopen('Frat.ssd','w');
%esout = e(1:nn);
csout = real(d(1:nn));
%fprintf(fidout,'%8.15g %8.15g \n',[eout;csout]);
%fclose(fidout);

ssd = csout'*sum(psdnn)/sum(csout);
ssd = ssd(1:size(core_loss_data,1));

%{
%Plot
figure;
plot(eout,csout,'r');
hold on;
plot(eout,cpout,'g');
legend('SSD','PSD');
title('Frat Output','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Count');
hold off;
end
%}