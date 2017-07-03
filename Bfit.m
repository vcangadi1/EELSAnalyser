function [core,back,spectrum] = Bfit(infile,eprestart,eprewidth,epoststart,epostwidth,ecorestart,ecorewidth,differ,outcore,outback)
% Program bfit for fitting background in EELS spectra using two area formula in iterationloop
% Exponent R is assumed to be the same both in core and post edge area
% 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011

fprintf(1,'\n------------Bfit-----------\n\n');


%Read spectrum from input file
if(nargin<1)
    fprintf('Alternate Usage: Bfit(''infile'',eprestart,eprewidth,epoststart,epostwidth,ecorestart,ecorewidth,differ,outcore,outback)\n\n');
    infile=input('Input file: ','s');
else
    fprintf('Input file: %s\n',infile);
end;
spectrum = ReadData(infile,2);

edispersion = spectrum(3,1) - spectrum(2,1);
fprintf('\nEnergy dispersion %g [eV/ch]\n',edispersion);



%Acquire pre/post/core energy window settings (if not in input parameters)
if(nargin<8)
    eprestart=input('Pre-Edge energy window START [eV]: ');
    eprewidth=input('Pre-Edge energy window WIDTH [eV]: ');
    epoststart=input('Post-Edge energy window START [eV]: ');
    epostwidth=input('Post-Edge energy window WIDTH [eV]: ');
    ecorestart=input('Core-loss energy window START [eV]: ');
    ecorewidth=input('Core-loss energy window WIDTH [eV]: ');
    differ=input('convergence criteria in percent difference in R in consequentive loops: ');
else
    fprintf('Pre-Edge energy window START [eV]: %g\n',eprestart);
    fprintf('Pre-Edge energy window WIDTH [eV]: %g\n',eprewidth);
    fprintf('Post-Edge energy window START [eV]: %g\n',epoststart);
    fprintf('Post-Edge energy window WIDTH [eV]: %g\n',epostwidth);
    fprintf('Core-loss energy window START [eV]: %g\n',ecorestart);
    fprintf('Core-loss energy window WIDTH [eV]: %g\n',ecorewidth);
    fprintf('convergence criteria in percent difference in R in consequentive loops: %g\n',differ);
end;
epreend = eprestart+eprewidth;
epremid = eprestart+eprewidth/2;
epostend = epoststart+epostwidth;
ecoreend = ecorestart+ecorewidth;

%Define energy windows as logical array indices
prefilter = spectrum(:,1) >= eprestart & spectrum(:,1) < epreend;
pre1filter = spectrum(:,1) >= eprestart & spectrum(:,1) < epremid;
pre2filter = spectrum(:,1) >= epremid & spectrum(:,1) < epreend;
corefilter = spectrum(:,1) >= ecorestart & spectrum(:,1) < ecoreend;
postfilter = spectrum(:,1) >= epoststart & spectrum(:,1) < epostend;

%Calculate sums of Pre, Post and Core energy windows as defined above
ipre = sum(spectrum(prefilter,2)) .* edispersion;
ipre1 = sum(spectrum(pre1filter,2)) .* edispersion;
ipre2 = sum(spectrum(pre2filter,2)) .* edispersion;
icore = sum(spectrum(corefilter,2)) .* edispersion;
ipost = sum(spectrum(postfilter,2)) .* edispersion;

%Calculate initial values of A and R
fprintf(1,'\nIpre1 %g, Ipre2 %g, Ipre %g, di %g\n',ipre1,ipre2,ipre,ipre -(ipre1+ipre2));
r = 2.*log(ipre1 ./ipre2)./log(epreend./eprestart);
a = ipre.*(1 - r)./(epreend.^(1-r) - eprestart .^(1-r));
fprintf(1,'first estimates of R = %g, A = %g\n\n',r,a);

%Iterate until last two calculations of R are within defined convergence criteria
for loop=1:30
    fprintf(1,'+++++++++++++ iteration loop # %d +++++++++++++ \n',loop);
    r_prev_loop = r;
    icoreback = a./(1-r).*(ecoreend.^(1-r) - ecorestart .^(1-r));
    b =(icore - icoreback).*(1 - r)./(ecoreend.^(1 - r) - ecorestart .^(1 - r)); %constant B for the core intensity
    ipostcore = b.*(epostend.^(1-r) - epoststart .^(1-r))./(1-r); %calculating the CORE contribution in the post-edge region
    ipostback = ipost - ipostcore;
    r = 2.*log(ipre .*epostwidth./(ipostback.*eprewidth))./log(epoststart .*epostend./(eprestart.*epreend));
    a = ipre.*(1 - r)./(epreend.^(1 - r) - eprestart .^(1-r));
    %icorecalc = b./(1-r).*(ecoreend.^(1-r) - (ecorestart) .^(1-r)); %calculated core-loss intensity
    %icorediff = icore -(icoreback + icorecalc);
    fprintf(1,'POST EDGE WINDOW IpostCore = %f\n',ipostcore);
    fprintf(1,'CORE WINDOW Measured = %g\n',icore);
    fprintf(1,'exponent R = %g, background A = %g\n',r,a);
    if((r./r_prev_loop > 1-differ/100) &&(r./r_prev_loop < 1+differ/100))
        fprintf(1,'END change in R less than %g percent in last two loops',(1-r/r_prev_loop)*100); %check this
        break;
    end;
end;
disp('fit coefficients I(E) = A*E^r');
fprintf('r = %g, A = %g\n',-r,a);

%Generate core and background curve data from A and R 
back = spectrum;
back(:,2) = a.*spectrum(:,1).^-r;
core(:,1) = spectrum(:,1);
core(:,2) = spectrum(:,2) - back(:,2);
backfilt = (back(:,2) > 0) & (back(:,1) > 20);
corefilt = (core(:,1) >= epreend) & (core(:,2) > 0);
back = back(backfilt,:);
core = core(corefilt,:);

%Plot spectrum, core, and fitted curve
figure;
plot(spectrum(:,1),spectrum(:,2),'k','LineWidth',2);
hold on;
title('BFit','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Count');
plot(core(:,1),core(:,2),'g','LineWidth',2);
plot(back(:,1),back(:,2),'r','LineWidth',2);
legend('Spectrum','Core','BFit');

hold off;

%Ask for output file names if none provide with input paramaters
if(nargin<10)
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
