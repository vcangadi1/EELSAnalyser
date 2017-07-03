function KroegerEBplots(in,E0,el,beta)
% this function takes a set of energy channels and their corresponding
% dielectric values and creates a set of plots similar to ones found in E&B
% Fig 3 & 4a (pg 90)


fprintf(1,'\n---------------KroegerEBplots----------------\n\n');

if(nargin<3)
    in = input('Input data file (e.g. KroegerEBplots_Si.dat) = ','s');
    E0 = input('E0 (keV): ');
    el = input('Energy loss for angular distribution (eV): ');
    beta = input('Angular Range (mrad): ');
else
    fprintf('Input data file = %s\n',in);
    fprintf('E0 (keV): %g\n',E0);
    fprintf('Energy loss for angular distribution (eV) %g\n',el);
    fprintf('Angular Range (mrad): %g\n',beta);
end

numCols = 3; 
inData=ReadData(in,numCols);

%Extract energy loss and dielectric function data and take its conjugate
edata = real(inData(:,1));
edata = edata+0.00000001;

% if 3 column data combine column 2 and 3 to form complex number
% if 2 column data assume column 2 is complex number
if(numCols == 3)
    epsdata = complex(inData(:,2),-inData(:,3)); %conjugate
elseif (numCols == 2)
    epsdata = conj(inData(:,2));
else
    error('eps data has too many columns');
end

%get height of 1 nm plot to normalize with (Fig. 4a)
temp=IntegrateTheta(0,beta*1e-3,edata,epsdata,E0,10e-10);
%temp = KroegerCore(edata,beta*1e-3,epsdata,E0,10e-10).';
max10 = max(temp); 

TSthick = [100000,10000,5000,2500,1000,500,250,100,50,10]; 
evFix = find(edata>=el,1,'first'); %set fixed eV to ~ el

for i=1:length(TSthick)
    fprintf('Currently processing %5.0d nm\n',TSthick(i)./10);
    %Integrate for specific thickness (Fig 4a)
    TSintP(i,:) = IntegrateTheta(1e-8,beta*1e-3,edata,epsdata,E0,TSthick(i).*1e-10);
    %TSPbetaFixed(i,:) = squeeze(KroegerCore(edata,beta*1e-3,epsdata,E0,TSthick(i).*1e-10));
%     size(TSPbetaFixed)
%     figure;
%     plot(TSPbetaFixed(i,:));
    %normalize height of plot using max10 and shift data upward (Fig 4a)
    maxy = max(TSintP(i,:));
    TSintP(i,:) = TSintP(i,:) .* max10 ./ maxy + max10*(10-i)/2;
    %maxy = max(TSPbetaFixed(i,:));
    %TSPbetaFixed(i,:) = TSPbetaFixed(i,:) .* max10 ./ maxy + max10*(10-i)/2;

    %kroeger for specific energy (edata(evFix)) and thickness (Fig. 3).
    TSPeVFixed(i,:) = KroegerCore(edata(evFix),(0:100/512:100).*1e-6,epsdata(evFix),E0,TSthick(i).* 1e-10);
    TSPeVFixed(i,:) = TSPeVFixed(i,:) .* 10^((10-i)/2); %apply y shift as in Fig 3
end



figure;
%hold on;

%Fig 3
[TSadata,ignore] = meshgrid(0:100/512:100,TSthick);
%subplot(1,2,1);

plot((TSadata.*1e-3)',log10(TSPeVFixed'));
%set(gca,'YScale','log');
legend('10000nm -4.5','1000nm -4.0','500nm -3.5','250nm -3.0','100nm -2.5','50nm -2.0','25nm -1.5','10nm -1.0','5nm -0.5','1nm');%,'trapz');
title(sprintf('%gkeV, %f eV',E0,edata(evFix)),'FontSize',12);
xlabel('Scattering Angle [mrad]');
ylabel('log10(P)[1/(eV srad)]');
set(gca,'YTick',[0:13]);

%Fig 4a
[TSedata,ignore] = meshgrid(edata,TSthick);
%subplot(1,2,2);
figure;
plot(TSedata',TSintP');
%plot(TSedata',TSPbetaFixed');
%set(gca,'YScale','log');
legend('10000nm','1000nm','500nm','250nm','100nm','50nm','25nm','10nm','5nm','1nm');%,'trapz');
title(sprintf('%gkeV, %g mrads',E0,beta),'FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('''Normalized dP/dE [1/eV]''');
set(gca,'YTickLabel',[]);

%figure;

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