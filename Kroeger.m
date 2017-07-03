function Kroeger(in, ee, thick, ang )
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n---------------Kroeger----------------\n\n');

if(nargin<4)
    fprintf('Alternate Usage: Kroeger(''infile'', E0, t, ang )\n\n');

    in = input('Input data file (e.g. drude.eps) = ','s');
    ee = input('E0 (keV): ');
    thick = input('thickness (nm): ');
    ang = input('Collection Angle (mrad): ');
%    epc = input('eV/channel : ');  %added 21 Mar 2010
else
    fprintf('Input data file = %s\n',in);
    fprintf('E0 (keV): %g\n',ee);
    fprintf('thickness (nm): %g\n',thick);
    fprintf('Collection Angle (mrad): %g\n',ang);
end;



%Read data in from a file
numCols = 3;
inData=ReadData(in,numCols); %ReadData function at bottom

%determine data size
[dsize,numCols]=size(inData);
dsize = dsize -1;
hdsize = (dsize+1)./2;

%Extract energy loss and dielectric function data and take its conjugate
edata = real(inData(:,1));

% if 3 column data combine column 2 and 3 to form complex number
% if 2 column data assume column 2 is complex number
if(numCols == 3)
    epsdata = complex(inData(:,2),-inData(:,3)); %conjugate
elseif (numCols == 2)
    epsdata = conj(inData(:,2));
else
    error('eps data has too many columns');
end;

%adjust input to SI units
thick = thick*1e-9; % input thickness now in nm
ang = ang * 1e-3; % input angular range now in mrad

%Generate sample scattering angles
adata=-ang:ang/(hdsize-0.5):ang;

%shift Energy data
edata = edata+0.00000001;



%Get solution of Kroeger Equation to use in plotData
[P,Pvol] = KroegerCore(edata,adata,epsdata,ee,thick);
%Pvol = real(klammer).*imag(eins);

%plot dielectric data used in the calculation
ploteV(edata,[real(epsdata)';-imag(epsdata)'],'Kroeger input data','',false);
legend('eps1','eps2');

%******create surface PLOTS using ploteVTheta and angular dependence at fixed eV **
ploteVTheta(edata,adata,Pvol,'Kroeger(bulk only)','d^2P/(d\Omega dE) [1/(eV srad)]');
%plotTheta(adata,P(:,find(edata>3,1,'first')),'3eV bulk angular distribution','');
%plotTheta(adata(adata>=0),Pvol(adata>=0,find(edata>3,1,'first')),'3eV bulk','');
ploteVTheta(edata,adata,P,'Kroeger (all terms)','d^2P/(d\Omega dE) [1/(eV srad)]'); 
plotTheta(adata(adata>=0),P(adata>=0,find(edata>1,1,'first')),'1eV total','P=d^2P/d\Omega.dE');
plotTheta(adata(adata>=0),P(adata>=0,find(edata>5,1,'first')),'5eV total','P=d^2P/d\Omega.dE');
plotTheta(adata(adata>=0),P(adata>=0,find(edata>13,1,'first')),'13eV total','P=d^2P/d\Omega.dE');
%ploteV(edata,Pvol(find(adata>0,1,'first'),:),'Volume only, theta=0rad','Pvol=d2P/dO.dE',false);
%ploteV(edata(edata>=1),P(find(adata>9e-5,1,'first'),edata>=1),'All terms, theta=9e-5rad','P=d^2P/d\Omega.dE',false);
ploteV(edata(edata>=1),P(find(adata>=0,1,'first'),edata>=1),'All terms, theta=0','P=d^2P/d\Omega.dE',false);
% false above sets linear vertical scale

%Integrate over detection area
intP=IntegrateTheta(0,ang,edata,epsdata,ee,thick);
ploteV(edata,intP,'Angle-integrated probability','dP/dE [1/eV]',false);

%Integrate over energy loss and print result
epc = edata(2)-edata(1);
intintP = trapz(edata,intP)./epc;
fprintf(1,'\nP(vol+surf) = %g\n',intintP);
%fprintf(1,'-------------------------------\n');

end


function intDatal = IntegrateTheta(startang,endang,edata,epsdata,ee,thick)
%Integrate over scattering angle.
% startang - starting angle for integration in rads
% endang - ending angle for integration in rads
% edata - energy loss channels in eV
% epsdata - conjugate dielectric data (data must be same size as edata)
% ee - electron energy in keV
% thick - specimen thickness in meters

intDatal=zeros(length(edata),1);

%integrate using quad or quadl
for i = 1:length(edata)
    PSin = @(inTheta)KroegerCore(edata(i),inTheta,epsdata(i),ee,thick).*sin(inTheta)';
    intDatal(i) = 2 * pi * quadl(PSin,startang,endang);
end;
 
end




function h = ploteVTheta(xscale,yscale,M,Mtitle,Mzlabel,logbool)
%creates a surface plot of a function M(x,y) where units for x are in eV and y are in rad

%if logbool not set, assume default log scale: ON
if(nargin<6)
    logbool = true;
end;

h = figure();
if(islogical(M))
    surf(xscale,yscale,real(M));
else
    if(logbool)
        M = M .* (M>0); % remove negative values for log (complex?)
        surf(xscale,yscale,real(M),real(log10(M)));
        set(gca,'ZScale','log');
    else
        surf(xscale,yscale,real(M));
        
    end;
end;
shading interp;
colormap jet; % cool % hot % autumn
colorbar;
title(Mtitle,'FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Scattering Angle [rad]');
if(nargin>4)
    zlabel(Mzlabel);
end;
    
end

function h = plotTheta(xscale,M,Mtitle,Mylabel,logbool)
%creates a line plot for a function M(x) where units of x are in rad

%if logbool not set, assume default log scale: ON
if(nargin<5)
    logbool = true;
end;

h = figure();

if(logbool)
    M = M .* (M>0); % remove negative values for log (complex?)
    plot(xscale,real(M));
    set(gca,'YScale','log');
else
    plot(xscale,real(M));

end;
title(Mtitle,'FontSize',12);
xlabel('Scattering Angle [rad]');
if(nargin>3)
    ylabel(Mylabel);
end;
    
end

function h = ploteV(xscale,M,Mtitle,Mylabel,logbool)
%creates a line plot for a function M(x) where units of x are in eV

%if logbool not set, assume default log scale: ON
if(nargin<5)
    logbool = true;
end;

h = figure();
if(logbool)
    M = M .* (M>0); % remove negative values for log (complex?)
    plot(xscale,real(M));
    set(gca,'YScale','log');
else
    plot(xscale,real(M));

end;
title(Mtitle,'FontSize',12);
xlabel('Energy Loss [eV]');
if(nargin>3)
    ylabel(Mylabel);
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