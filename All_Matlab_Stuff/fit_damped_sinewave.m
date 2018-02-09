function [sigr,resr]=fit_damped_sinewave(sig)

% Detlef Amberg, Detlef.Amberg@gmx.de, 04/15

% The sequence
% sigr(k)= Ar*exp(alphar*k) * cos(wr*k+phr), k=0..n-1
% is fitted to the given signal sig

% The solution ist based on lineare Algebra only, 
% no optimization nor nonlinear calculation required

% see  ( some fluency in german required )
% www.matheplanet.de/matheplanet/nuke/html/viewtopic.php?topic=173242

% debug framework
if(1)
    n=1000;
    A=2;
    alpha =-0.002;
    w=pi/50;
    ph=(-pi/2);
    
    %sig=A*exp(alpha*(0:n-1)).*cos(w*(0:n-1)+ph);
    %sig=sig+1*0.3*randn(size(sig)); % add some noise
end; % end debug

sig=sig(:);

% do a coarse frequency estimation
spd=fft(sig);
[~,ind]=max(abs(spd(1:end/2)));
ind=ind-1;% how many sinewaves in the window
nn=length(sig)/ind; % samples per sine wave
% decimate to get close to Nyquist/2, 
% i.e. 4 samples per sinewave
dd=round(nn/4); 
n=length(sig);

% linear fit to the difference equation 
%x(k+2) = 2*sqrt(b)*cos(w)*x(k+1)-b*x(k)
sn0=sig(2*dd+1:end   );
sn1=sig(1*dd+1:end-dd);
sn2=sig(1:end-2*dd);
M=[-sn1 -sn2];
%coff=inv(M'*M)*M'*sn0;
coff=(M'*M)\(M'*sn0);
% calculate poles of the discrete system
rest =roots([1; coff]);
% correct for decimation
rest1=rest.^(1/dd);
far=poly(rest1);

% find general solution from particular solutions 
% using initial values, 
% optional, omit, if no reconstructed signals from
% difference equ. are needed
if(1)
MM=  repmat(rest1.',n,1).^repmat((0:n-1).',1,2);
%coff1=inv(MM.'*MM)*MM.'*sig;
coff1=(MM.'*MM)\(MM.'*sig);
% this should be the reconstructed signal 
% from the difference equation
sig3r=real(MM*coff1);
%plot(1:n,sig,'b.-',1:n,sigr,'r.-')
% calculate fitted signal from difference equation
sig1r=zeros(1,n);
sig1r(1)=sig3r(1);
sig1r(2)=sig3r(2);
for(k=3:n)
 sig1r(k)=-far(2)*sig1r(k-1)-far(3)*sig1r(k-2);
end
end; %optional 

% calculate br, Ar, alphar and phr for  
% x(k)= Ar*exp(alphar*k) * cos(wr*k+phr)
% from difference equ.
% x(k+2) = 2*sqrt(b)*cos(w)*x(k+1)-b*x(k)
br=far(3);
%exp(alpha)=sqrt(b)
alphar=log(sqrt(br));
%-far(2)= 2*sqrt(b)*cos(w)
wr=acos(-far(2)/2/sqrt(br));
M=[ (exp(alphar*(0:n-1)).*sin((0:n-1)*wr)).' ....
    (exp(alphar*(0:n-1)).*cos((0:n-1)*wr)).'];
%coff=inv(M'*M)*M'*sig;
coff=(M'*M)\M'*sig;

cc=coff(2)+j*coff(1);
Ar=abs(cc);
phr=angle(cc');

% calculate fitted signal from explicit equ.
sig2r=Ar*exp(alphar*(0:n-1)) .* cos(wr*(0:n-1)+phr);

% energies and signal/noise ratio, if you need that
Esig=sig2r(:).'*sig2r(:);
noise=sig2r(:)-sig(:);
Enoise=noise.'*noise;
snr=10*log10(Esig/Enoise)

resr = [Ar alphar wr phr]
[A alpha w ph]

%Afterburner:
% adjust amplitude/damping
% omit for better Signal/noise ratios
if(1)
  ind1a = -1;
  ind2a = -1;
  kk=1;
  while(1)  
  nn=1000;
  ee=zeros(1,nn);
  
  vv=(0.2+5*(0:nn-1)/nn);
  for(k=1:nn)  
  sigsig=Ar*exp(vv(k)*alphar*(0:n-1))...
         .* cos(wr*(0:n-1)+phr);
  ee(k)=sum(abs(sig-sigsig(:)));   
  end
  [~,ind1]=min(ee);
  alphar=vv(ind1)*alphar;

  vv=(0.5+2*(0:nn-1)/nn);
  for(k=1:nn)  
  sigsig=vv(k)*Ar*exp(alphar*(0:n-1))...
         .* cos(wr*(0:n-1)+phr);
  ee(k)=sum(abs(sig-sigsig(:)));   
  end;
  [~,ind2]=min(ee);
  Ar=vv(ind2)*Ar;
  
  if(ind1==ind1a)
    if(ind2==ind2a)
        break;
    end
  end
  ind1a=ind1;
  ind2a=ind2;
  kk=kk+1;
  if(kk>100) 
      break; 
  end;
  end;
end;

% calculate fitted signal from explicit equ.
sig2r=Ar*exp(alphar*(0:n-1)) .* cos(wr*(0:n-1)+phr);
sigr=sig2r;

resr = [Ar alphar wr phr]
[A alpha w ph]


plot(0:n-1,sig,'r.-',0:n-1,sig2r,'b.-');
%plot(0:n-1,sig,'r.-',0:n-1,sig1r,'g.-',0:n-1,sig2r,'b.-');
%plot(noise)