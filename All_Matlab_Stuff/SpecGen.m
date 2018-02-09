function [outssd,outpsd] = SpecGen(ep,wp,wz,ez,epc,a0,tol,nd,back,fback,cpe)
%      SpecGen.m: GENERATES A PLURAL-SCATTERING DISTRIBUTION
%      FROM A GAUSSIAN-SHAPED SSD OF WIDTH WP, PEAKED AT EP,
%      WITH BACKGROUND AND POISSON SHOT NOISE 
% Details in R.F.Egerton: EELS in the Electron Microscope, 3rd edition, Springer 2011)
% Version 10.11.26

fprintf('   SpecGen(ep,wp,wz,ez,epc,a0,tol,nd,back,fback,cpe)\n');

    persistent psd ssd ;

if isempty(psd), psd=zeros(1,1024); end;
if isempty(ssd), ssd=zeros(1,1024); end;
fid_1=fopen('SpecGen.ssd','w+');
%      contains SSD in xy format, with no background
fid_2=fopen('SpecGen.psd','w+');
%      contains the plural scattering distrib. with Z-L at EZ

if(nargin < 11) % counts number of inputs
    ep = input('SpecGen: plasmon energy (eV) = ');
    wp = input('plasmon FWHM (eV) : ');
    wz = input('zero-loss FWHM (eV): ');
    ez = input('zero-loss offset from first channel (eV): ');
    epc = input('eV/channel: ');
    a0 = input('zero-loss counts: ');
    tol = input('t/lambda: ');
    nd = input('number of channels: ');
    back = input('instrumental background level (counts/channel): ');
    fback = input('instrumental noise/background (e.g. 0.1): ');
    cpe = input('spectral counts per beam electron (e.g. 0.1): ');    
else
    fprintf('SpecGen: plasmon energy (eV) = %g\n',ep);
    fprintf('plasmon FWHM (eV) : %g\n',wp);
    fprintf('zero-loss FWHM (eV): %g\n',wz);
    fprintf('zero-loss offset from first channel (eV): %g\n',ez);
    fprintf('eV/channel: %g\n',epc);
    fprintf('zero-loss counts: %g\n',a0);
    fprintf('t/lambda: %g\n',tol);
    fprintf('number of channels: %g\n',nd);
    fprintf('instrumental background level (counts/channel): %g\n',back);
    fprintf('instrumental noise/background (e.g. 0.1): %g\n',fback);
    fprintf('spectral counts per beam electron (e.g. 0.1): %g\n',cpe);
end


fprintf(1,'-------------------------------\n');
fpoiss = cpe^0.5; %
sz = wz/1.665; %convert from FWHM to standard deviation
sp = wp/1.665;
hz = a0/sz/1.772; %height of ZLP (epc* removed)
rlnum=1.23456;

outpsd = zeros(nd,1);
outssd = outpsd;
eout = outssd;

%     calculate intensity at each energy loss E :
for i=1:nd
    e = (i)*epc - ez;
    fac = 1;
    psd(i) = 0;
    %     sum contribution from each order of scattering:
    for order=0:14
        sn=sqrt(sz*sz+order*sp*sp);
        xpnt=(e-order*ep)^2/sn/sn;
        if(xpnt>20.0)
            expo=0.0;
        end;
        if(xpnt<=20.0)
            expo=exp(-xpnt);
        end;
        dne=hz*sz/sn*expo/fac*tol^order;
        rndnum=2*((fix(rlnum))-rlnum);
        snoise=fpoiss*(sqrt(dne)*rndnum);
        rlnum=9.8765*rndnum;
        if(order==1) %check if 1 or 0
            bnoise=fback*back*rndnum;
            ssd(i)=dne+sqrt(snoise*snoise+bnoise*bnoise);
            outssd(i)=ssd(i)+ back;
            fprintf(fid_1,'%0.15g %0.15g \n', e,ssd(i)+back);
        end;
        psd(i)=psd(i)+dne;
        fac=fac*(order+1);
        
    end;
    snoise=fpoiss*(sqrt(psd(i))*rndnum);
    fprintf(fid_2,'%0.15g %0.15g \n', e,psd(i)+sqrt(snoise*snoise+bnoise*bnoise)+back);
    outpsd(i)=psd(i)+sqrt(snoise*snoise+bnoise*bnoise)+back;
    eout(i) = e;
end;
%%
if isrow(outpsd)
    outpsd = outpsd';
end
if isrow(outssd)
    outssd = outssd';
end
%%
figure;
plot(eout,outssd,'b');
hold on;
plot(eout,outpsd,':r');
legend('SSD','PSD');
title('SpecGen','FontSize',12);
xlabel('Energy Loss [eV]');
ylabel('Counts/channel');
hold off;
fclose(fid_1);
fclose(fid_2);