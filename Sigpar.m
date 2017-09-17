function sigma = Sigpar( z, dl, shell, e0, beta)

% SIGPAR2.FOR calculates sigma(beta,delta) from f-values stored
% in files FK.DAT, FL.DAT, FM45.DAT, FM23.DAT and FNO45.DAT
% based on values given in Ultramicroscpy 50 (1993) 13-28.
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

%fprintf(1,'\n---------------Sigpar----------------\n\n');

if(nargin < 3)
    fprintf('Alternate Usage: Sigpar(Z,Delta,Shell,E0,Beta)\n\n');
    z = input('Enter Z: ');
    dl = input('Enter Delta (eV): ');
    shell = input('Enter edge type (K,L,M23,M45,N or O): ','s');
else
    %fprintf('Z: %g\n',z);
    %fprintf('Delta (eV): %g\n',dl);
    %fprintf('Edge type (K,L,M23,M45,N or O): %s\n',upper(shell));
end

%Select f-values table based on edge type
if(strcmp(shell,'K'))
    infile = 'Sigpar_fk.dat';
    numCol = 6;
elseif(strcmp(shell,'L'))
    infile = 'Sigpar_fl.dat';
    numCol = 6;
elseif(strcmp(shell,'M23'))
    infile = 'Sigpar_fm23.dat';
    numCol = 3;
elseif(strcmp(shell,'M45'))
    infile = 'Sigpar_fm45.dat';
    numCol = 6;
elseif(strcmp(shell,'N') || strcmp(shell,'O'))       
    infile = 'Sigpar_fno45.dat';
    numCol = 5;
else
    error('Invalid Edge Type ''%s''',t);        
end

%Read edge type data
inData = ReadData(infile,numCol);

%lookup z value in edge type table
idx = inData(:,1) == z;
fdata = inData(idx,:);
if (isempty(fdata))
    error('Z value %d not found for edge type %s (%s)',z,shell,infile);
end


%get f-values from table
if(strcmp(shell,'K') || strcmp(shell,'L') || strcmp(shell,'M45'))
    ec = fdata(2);
    f50 = fdata(3);
    f100 = fdata(4);
    f200 = fdata(5);
    erp = fdata(6);
    fd = fdcalc(dl,f50,f100,f200);
elseif(strcmp(shell,'M23'))     
    ec = fdata(2);
    f30 = fdata(3);
    dl = 30;
    fd = f30;
    erp = 10;
    %fprintf('For delta = 30eV\n');
elseif(strcmp(shell,'N') || strcmp(shell,'O'))
    ec = fdata(2);
    f50 = fdata(3);
    f100 = fdata(4);
    erp = fdata(5);
    fd = fdcalc(dl,f50,f100,f100);
end

%get e0 and beta
%fprintf('Ec = %0.15g eV,  f(delta) =  %0.15g \n',ec,fd);
if(nargin < 5)
    e0 = input('Enter E0(keV): ');
    beta = input('Enter beta(mrad): ');
else
    %fprintf('E0(keV): %g\n',e0);
    %fprintf('beta(mrad): %g\n',beta);
end
if((beta^2)>(50*ec/e0))
    %fprintf('Dipole Approximation NOT VALID, sigma will be too high!\n');
end

%Calculate Sigma
ebar=sqrt(ec*(ec+dl));
gamma=1+e0/511;
g2=gamma^2;
v2=1-1/g2;
b2=beta^2;
thebar=ebar/e0/(1+1/gamma);
t2=thebar*thebar;
gfunc=log(g2)-log((b2+t2)/(b2+t2/g2))-v2*b2/(b2+t2/g2);
squab=log(1+b2/t2)+gfunc;
%sigma=1.3e-16*g2/(1+gamma)/ebar/e0*fd*squab;
sigma=1.3e-16*g2/(1+gamma)/ebar/e0*fd*squab/10^-24;
%fprintf('sigma = %0.3g cm^2; \n',sigma);
if(~((beta^2)>(50*ec/e0)))
   %fprintf('estimated accuracy = %0.4g %% \n',erp);
end;
end


%function to calculate 'fd'
function fd = fdcalc(dl,f50,f100,f200)
if(dl<=50)
    fd=f50*dl/50.;
elseif((dl>50)&&(dl<100)) ;
    fd=f50+(dl-50)/50*(f100-f50);
elseif((dl>=100)&&(dl<250)) ;
    fd=f100+(dl-100)/100*(f200-f100);
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
%fprintf('Data file ''%s'' is assumed to have %d columns\n',infile,cols);
outdata = fscanf(fidin,'%g%*c',[cols,inf]);
fclose(fidin);
outdata = outdata.';

end
