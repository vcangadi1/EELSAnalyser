%% Matlab programs from EELS in the Electron Microscope 3rd Edition
% Below is a summary of the various programs as described in Appendix B.
% Each program is presented with sample input values and the corresponding
% output including any generated plots. 
% 
% <html>
% <p>Feedback is welcome. General feedback/enquiries can be sent to: </p>
% <P><IMG SRC="Ray_m.jpg" NAME="graphics2" ALIGN=LEFT BORDER=0><BR></P>
% <p>Matlab programming related questions/comments can be sent to: </p>
% <P><IMG SRC="Mike_m.jpg" NAME="graphics3" ALIGN=LEFT BORDER=0><BR></P>
% <p>The complete set of files can be downloaded <a href="EELS3-Matlab-10-12-02.zip">HERE</a></p>
% </html>
% 

%% B.1. First-Order Spectrometer Focusing
% *Prism*
%


%Prism( u, eps1, eps2, K1, g, R, phi, v )
Prism(100,0,45,0.4,10,3,30,100);


%% B.2. Cross Sections for Atomic Displacement and High-Angle Elastic scattering
% *Sigdis*
%


%Sigdis(Z,A,Ed,E0)
Sigdis(6,12,10,200);

%%
% *SigADF*

%SigADF(Z,A,qn,qx,E0)
SigADF(6,12,20,100,100);

%% B.3. Lenz-Model Elastic and Inelastic Cross Sections
% *LenzPlus*

%LenzPlus(e0,e,z,beta,toli)
LenzPlus(100,40,6,10,1.5);

%% B.4. Generation of a Plural-Scattering Distribution
% *SpecGen*

%SpecGen(ep,wp,wz,ez,epc,a0,tol,nd,back,fback,cpe)
SpecGen(16.7,3.2,1,5,0.1,10000,1.5,1000,2,0.5,10);

%% B.5. Fourier-Log Deconvolution
% *Flog*

%SpecGen(ep,wp,wz,ez,epc,a0,tol,nd,back,fback,cpe)
SpecGen(20,2,3,6,0.1,10000,0.5,1000,20,0.1,0.1);

%Flog(infile,fwhm2)
Flog('SpecGen.psd',0);

%%
% *FlogS*

%SpecGen(ep,wp,wz,ez,epc,a0,tol,nd,back,fback,cpe)
SpecGen(20,2,3,6,0.1,10000,5.0,5000,20,0.1,0.1);

%FlogS(infile,fwhm2)
FlogS('SpecGen.psd',0);

%% B.6. Maximum-Likelihood Deconvolution
% *RLucy*

%SpecGen(ep,wp,wz,ez,epc,a0,tol,nd,back,fback,cpe)
SpecGen(20,2,3,6,0.1,10000,0.5,1000,20,0.1,0.1);

%RLucy(specFile, kernelFile, niter)
RLucy('SpecGen.psd','',10);

%% B.7. Drude-Model Spectrum Simulation
% *Drude*

%Drude(ep,ew,eb,epc,e0,beta,nn,tnm)
Drude(15,3,0,0.1,200,5,500,50);

%% B.8. Kramers–Kronig Analysis
% *KraKro*

%Drude(ep,ew,eb,epc,e0,beta,nn,tnm)
Drude(15,3,0,0.1,100,10,1000,50);
%KraKro(infile,a0,e0,beta,ri,nloops,delta)
KraKro('Drude.ssd',1,100,10,1000,2,0.2);

%% B.9. Kröger Simulation of Low-Loss Spectrum
% *Kroeger*
% 

%Drude(ep,ew,eb,epc,e0,beta,nn,tnm)
Drude(15,2,0,0.2,200,5,600,150);
%Kroeger(in, ee, thick, ang )
Kroeger('Drude.eps',200,150,5)

%%
% *KroegerEBplots*

%KroegerEBplots(in,E0,el,beta)
KroegerEBplots('KroegerEBplots_Si.dat',300,3,2.1);

%% B.10. Core-Loss Simulation: 
% *CoreGen*

%CoreGen(Ek,Emin,Emax,Ep,Epc,r,TOL)
CoreGen(232,200,400,20,0.2,4,0.5);

%%
% *EdgeGen*

%EdgeGen(Ek,Emin,Emax,Ep,Epc,r,TOL,JR)
EdgeGen(232,200,400,20,0.2,4,0.5,8);

%% B.11. Fourier-Ratio Deconvolution
% *Frat*

%CoreGen(Ek,Emin,Emax,Ep,Epc,r,TOL)
CoreGen(232,200,400,20,0.2,4,0.5);
%Frat(lfile,fwhm2,cfile)
Frat('CoreGen.low',0,'CoreGen.cor');

%% B.12. Incident-Convergence Correction
% *Concor2*

%concor2(alpha,beta,e,e0)
Concor2(18,12,500,100);

%% B.13. Hydrogenic K-Shell Cross Sections
% *Sigmak3*

%Sigmak3( z,ek,delta1,e0,beta )
Sigmak3(6,284,100,100,10);

%% B.14. Modified-Hydrogenic L-Shell Cross Sections
% *Sigmal3*

%Sigmal3(z,delta1,e0,beta)
Sigmal3(22,100,80,10);

%% B.15. Parameterized K-, L-, M-, N- and O-Shell Cross Sections
% *Sigpar*

%Sigpar( z, dl, shell, e0, beta)
Sigpar(5,50,'K',100,5);


%% B.16. Measurement of Absolute SpecimenThickness
% *tKKs*

%Drude(ep,ew,eb,epc,e0,beta,nn,tnm)
Drude(15,3,0,0.2,200,5,500,100);

%tKKs( inFile, E0, n, beta, I0 )
tKKs('Drude.ssd',200,0,5,1);

%% B.17. Total-Inelastic and Plasmon Mean Free Paths
% *IMFP*

%IMFP(Z, A, prcnt, alpha, beta, rho, E0)
IMFP([6,1],[12,1],[0.33,0.67],5,10,0.9,200);

%%
% *PMFP*

%PMFP(E0, Ep, alpha, beta)
PMFP(200,20,5,10);

%% B.18. Constrained Power-Law Background Fitting
% *Afit*

%Afit(infile,eprestart,eprewidth,epoststart,epostwidth,outcore,outback)
Afit('CoO.dat',500,30,740,30,'Acore.dat','Aback.dat');

%%
% *BFit*

%Bfit(infile,eprestart,eprewidth,epoststart,epostwidth,ecorestart,ecorewidth,differ,outcore,outback)
Bfit('CoO.dat',500,30,740,30,550,50,0.1,'Bcore.dat','Bback.dat');

