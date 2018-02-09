%
% Script demonstrating the use of the function
% function_ClipPoisGaus_stdEst2D.m  [version 2.32 released 26 May 2015]
%
% This software demonstrates the algorithm described in the publications:
% Foi, A., M. Trimeche, V. Katkovnik, and K. Egiazarian, "Practical Poissonian-Gaussian noise modeling and fitting for single-image raw-data", IEEE Trans. Image Process., vol. 17, no. 10, pp. 1737-1754, October 2008.
% L. Azzari and A. Foi, “Gaussian-Cauchy mixture modeling for robust signal-dependent noise estimation”, Proc. 2014 IEEE Int. Conf. Acoustics, Speech, Signal Process. (ICASSP 2014), pp. 5357-5361, Florence, Italy, May 2014. 
%
% Requires functions:   function_ClipPoisGaus_stdEst2D  and  ml_fun_ClipPoisGaus
% Optional function:    function_stdEst2D   -  classical MAD std estimate on the wavelet detail coefficients for AWGN with constant variance (independent homoskedastic), available from http://www.cs.tut.fi/~lasip/2D/
%                       rawimread_fuji_tiff -  extracts color components in rectangular form from SuperCCD RAW data (which is tilted of 45 degrees), available from http://www.cs.tut.fi/~foi/sensornoise.html
%
% Lucio Azzari  and  Alessandro Foi
% firstname.lastname@tut.fi  Tampere University of Technology  2008-2015
% ------------------------------------------------------------------------------------------------------

close all
clear all
disp(' ')


%% ALGORITHM MAIN PARAMETERS
%                                %  the standard-deviation function has the form \sigma=(a*y^polyorder+b*y^(polyorder-1)+c*y^(polyorder-2)+...).^(variance_power/2), where y is the unclipped noise-free signal.
polyorder=1;                     %  order of the polynomial model to be estimated [default 1, i.e. affine/linear]  Note: a large order results in overfitting and difficult and slow convergence of the ML optimization.
variance_power=1;                %  power of the variance [default 1, i.e. affine/linear variance]
%                                %   The usual Poissonian-Gaussian model has the form \sigma=sqrt(a*y+b), which follows from setting polyorder=1 and variance_power=1.

median_est=1;                    %  0: sample standard deviation;  1: MAD   (1)
LS_median_size=1;                %  size of median filter for outlier removal in LS fitting (enhances robustness for initialization of ML) 0: disabled  [default 1 = auto]
tau_threshold_initial=1;         %  (initial) scaling factor for the tau threshold used to define the set of smoothness   [default 1]

% prior_density=0; %(SET BELOW)  %  type of prior density to use for ML    (0)
%                                %    0: zero_infty uniform prior density (R+);  (default, use this for raw-data)
%                                %    1: zero_one uniform prior density [0,1];
%                                %    2: -infty_infty uniform prior density (R);

level_set_density_factor=1;      %   density of the slices in for the expectations   [default 1 ( = 600 slices)]   (if image is really small it should be reduced, say, to 0.5 or less)
integral_resolution_factor=1;    %   integral resolution (sampling) for the finite sums used for evaluatiing the ML-integral   [default 1]
speed_factor=1;                  %   factor controlling simultaneously density and integral resolution factors  [default 1] (use large number, e.g. 1000, for very fast algorithm)

text_verbosity=1;                %  how much info to print to screen 0: none, 1: little, 2: a lot
figure_verbosity=4;              %  show/keep figures?        [default 3]
%                                     0: no figures
%                                     1: only figure with final ML result is shown and kept
%                                     2: few figures are shown during processing but none kept
%                                     3: few figures are shown but only figure with final ML result is kept
%                                     4: show and keep all figures
lambda=1;                        %  [0,1]:  models the data distribution as a mixture of Gaussian and Cauchy PDFs (each with scale parameter sigma), with mixture parameters lambda and (1-lambda): p(x) = (1-lambda)*N(x,y,sigma^2)+lambda*Cauchy(x,y,sigma)     [default 1]
auto_lambda=1;                   %  include the mixture parameter lambda in the maximization of the likelihood   [default 1]
%                                     0: lambda is fixed equal to its input value and not optimized
%                                     1: lambda is optimized (the input value of lambda is used as initial value for the optimization)


%% ====================================================================================================================================
%% LOAD BITMAP/RAW IMAGE    %  raw-data images which are loaded below can be downloaded from http://www.cs.tut.fi/~foi/sensornoise.html
%% ====================================================================================================================================
if 1 %% load "noise-free" image and add noise   (OTHERWISE LOAD RAW DATA, SEE BELOW)
    add_noise=1;                % add noise to image
    a=0.1^2;   b=0.04^2;        % noise parameters a,b
    %    a=0.1^2;   b=0.02^2;       % noise parameters a,b
    %    a=0.0^2;   b=0.2^2;        % noise parameters a,b
    %    a=(1/30);  b=0.1^2;        % noise parameters a,b
    
    clipping_below=1;   %  on/off   [keep off for pure-poissonian (no gaussian terms) noise, since there are no negative errors]
    clipping_above=1;   %  on/off
    prior_density=1;                 %  type of prior density to use for ML    (0)
    %                                %    1: zero_one uniform prior density [0,1];
    
    
    %     y=im2double(imread('image_man1024.tiff'));
    %     y=im2double(imread('image_testpat1024.tiff'));
    y=im2double(imread('y_piecewise.tif'));
    %     y=im2double(imread('y_piecewise_fibo.tif'));
    
else %%  RAW  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    add_noise=0;  %% DO NOT ADD NOISE TO RAW-DATA (IT HAS ENOUGH NOISE ALREADY! :) )
    clipping_below=1;  %%%% on off   %% RAW-DATA IS ASSUMED TO BE CLIPPED FROM ABOVE AND BELOW
    clipping_above=1;  %%%% on off
    prior_density=0;                 %  type of prior density to use for ML    (0)
    %                                %    0: zero_infty uniform prior density (R+);  (default, use this for raw-data)
    
    % The following tiff files are obtained from the .CR2 or .RAF or .NEF proprietary raw files using DCRAW.EXE with the options  -D -4 -T -j -v
    % (see http://www.cybercom.net/~dcoffin/dcraw/   or   www.insflug.org/raw/ )
    
    if 1 %%  CANON EOS350D  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        z=imread('Canon_EOS350D-ISO1600-Blurred_Target-IMG_1888.tiff');
        %         z=imread('Canon_EOS350D-ISO1600-Staircase-IMG_1908.tiff');
        %         z=imread('Canon_EOS350D-ISO1600-Dark_shot-IMG_2113.tiff');
        %         z=imread('Canon_EOS350D-ISO100-Blurred_Target-IMG_1890.tiff');
        %         z=imread('Canon_EOS350D-ISO100-Staircase-IMG_1907.tiff');
        %         z=double([z(1:2:end,1:2:end),z(2:2:end,2:2:end);z(1:2:end,2:2:end),z(2:2:end,1:2:end)])/4095;     %% [G1,G2;R,B]
        z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/4095;  %% [R,B;G1,G2]
    elseif 0 %%  FUJIFILM FinePix S5600/S9600  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         filenamzz='FinePix_S9600_ISO80-DSCF2238.tiff';
        %         filenamzz='FinePix_S9600_ISO100-DSCF2239.tiff';
        %         filenamzz='FinePix_S9600_ISO200-DSCF2241.tiff';
        %         filenamzz='FinePix_S9600_ISO400-DSCF2243.tiff';
        %         filenamzz='FinePix_S9600_ISO800-DSCF2244.tiff';
        %         filenamzz='FinePix_S9600_ISO1600-STAIRCASE-DSCF1273.tiff';
        %         filenamzz='FinePix_S9600_ISO1600-BOTTLE-DSCF1278.tiff';
        filenamzz='FinePix_S5600_ISO1600-TARGET.tiff';
        %         filenamzz='FinePix_S5600_ISO1600-Leatherman-DSCF6503.tiff';
        
        if exist('rawimread_fuji_tiff','file')~=2&&exist('rawimread_fuji_tiff','file')~=6
            disp(' !!!   SuperCCD raw-data is rotated 45 degrees and needs special reordering to be split into subcomponents.');
            disp(' !!!   Please download  rawimread_fuji_tiff  from http://www.cs.tut.fi/~foi/sensornoise.html ');
            disp(' ');
            return
        end
        
        z=double([rawimread_fuji_tiff(filenamzz,2);rawimread_fuji_tiff(filenamzz,1),rawimread_fuji_tiff(filenamzz,3)])/15840; %  [GG;R,G]
        %% !!! note that the constant 15840 is not exact, there are very minor variations between channels and subchannels
        %% !!! note also that especially at low ISO values (e.g. <=200), the response of the different channels and subchannels
        %% !!! is not equal, thus one should estimate separately each channel and possibly each subchannel (i.e. subsampling
        %% !!! individual channels), as they lead to slightly different curves.
    elseif 0  %%  CANON EOS 40D  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if 0  % ISO 100
            z=imread('Canon_EOS_40D-ISO100-IMG_2226.tiff');
            z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/13824; %  ISO 1600 800 400 200
        elseif 0  % ISO 200 400 800 1600
            %             z=imread('Canon_EOS_40D-ISO200-IMG_2214.tiff');
            %             z=imread('Canon_EOS_40D-ISO400-IMG_2212.tiff');
            %             z=imread('Canon_EOS_40D-ISO800-IMG_2210.tiff');
            %             z=imread('Canon_EOS_40D-ISO1600-IMG_2207.tiff');
            z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/16224;% [R,B;G1,G2]
        elseif 1 % ISO 1000 3200
            z=imread('Canon_EOS_40D-ISO3200-IMG_2221.tiff');
            %             z=imread('Canon_EOS_40D-ISO1000-IMG_2227.tiff');
            z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/16383;% [R,B;G1,G2]
        elseif 0 % ISO 640
            z=imread('Canon_EOS_40D-ISO640-IMG_2219.tiff');
            z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/12742; %  ISO 640
        end
        % % % % % % % % Saturation values for Canon 40D depend on the ISO parameter
        % % % % % % % %   ISO 100: 13824, ISO 125: 16383, ISO 160: 12745, ISO 200: 16224, ISO 250: 16383, ISO 320: 12743, ISO 400: 16224, ISO 500: 16383, ISO 640: 12742, ISO 800: 16223, ISO 1000: 16383, ISO 1250: 12743, ISO 1600: 16224, ISO 3200: 16383.
        % % % % % % % % See discussions and explanations in the following forums:
        % % % % % % % %   http://www.adobeforums.com/webx/.3c055802
        % % % % % % % %   http://www.slo-foto.net/modules.php?name=Forums&file=viewtopic&p=116805
        % % % % % % % %   http://forums.dpreview.com/forums/read.asp?forum=1019&message=25631202
        % % % % % % % %   http://forums.dpreview.com/forums/readflat.asp?forum=1019&thread=25607049
        % % % % % % % %   http://forums.dpreview.com/forums/read.asp?forum=1019&message=25645921
    elseif 0 %% CANON EOS400D  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % (similar situation as for the 40D)
        if 0 % ISO 1600
            z=imread('Canon_EOS400D-ISO1600-Blurred_Target-IMG3386.tiff');  %
            z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/4058;  %% [R,B;G1,G2]
        else % ISO 100
            z=imread('Canon_EOS400D-ISO100-Blurred_Target-IMG3384.tiff');  % ISO 100  EOS400D
            z=double([z(1:2:end,2:2:end),z(2:2:end,1:2:end);z(1:2:end,1:2:end),z(2:2:end,2:2:end)])/3726;  %% [R,B;G1,G2]
        end
    elseif 0 %%  NIKON D80  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         z=double(imread('NIKOND80_ISO1600-_DSC2475.tiff'));   % NIKON D80 ISO1600
        z=double(imread('NIKOND80_ISO100-_DSC2464.tiff'));   % NIKON D80 ISO1000
        z=[z(1:2:end,1:2:end)/3981,z(1:2:end,2:2:end)/4095;z(2:2:end,2:2:end)/3967,z(2:2:end,1:2:end)/4095];   %% NIKON D80
        % %         http://www.adobeforums.com/webx?14@@.3bc03c04.3c054460/11
    end
    %     z=z(1:1:end,1:1:end);   %% SUBSAMPLE? MIGHT BE SENSIBLE CHOICE IF IMAGE IS HUGE AND MEMORY IS NOT  (SEE ALSO NOTE ABOUT Fujifilm S9600!!!)
end

if ~exist('z','var')&&~exist('y','var')
    disp('================================================')
    disp('             No image loaded !!!!')
    disp('================================================')
    disp(' ');
    disp(' Sample raw images can be downloaded from  http://www.cs.tut.fi/~foi/sensornoise.html ');
    disp(' ');
    disp(' ');
    return
end


%% ADD NOISE & CLIP
if add_noise
    %% % THESE LINES BELOW CAN BE USED TO FIX THE PSEUDORANDOM NOISE
    %     init=0;
    %     init=round(100000*rand(1));
    %     randn('state',init);  rand('state',init);
    %     randn('seed', init);  rand('seed', init);
    
    if a==0   % no Poissonian component
        z=y;
    else      % Poissonian component
        chi=1/a;
        z=poissrnd(max(0,chi*y))/chi;
    end
    z=z+sqrt(b)*randn(size(y));   % Gaussian component
    
    % CLIPPING          %%% the variable z represents either the non-clipped $z$ or the clipped $\tilde{z}$  (the actual role of the variable is specified by the clipping_above and clipping_below parameters)
    if clipping_above
        z=min(z,1);
    end
    if clipping_below
        z=max(0,z);
    end
else
    if ~exist('z','var')
        z=y;
        clear y;
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALL ESTIMATION FUNCTION WITH GIVEN OBSERVATION AND PARAMETERS
fitparams=function_ClipPoisGaus_stdEst2D(z,polyorder,variance_power,clipping_below,clipping_above,prior_density,median_est,LS_median_size,tau_threshold_initial,level_set_density_factor,integral_resolution_factor,speed_factor,text_verbosity,figure_verbosity,lambda,auto_lambda);
% fitparams = [ \hat{a} and \hat{b} ]  contains the estimates of the a,b parameters.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% p & q parameters are used in the paper
%% Foi, A., S. Alenius, V. Katkovnik, and K. Egiazarian, "Noise measurement for raw-data of digital imaging sensors by automatic segmentation of non-uniform targets", IEEE Sensors Journal, vol. 7, no. 10, pp. 1456-1461, October 2007.
if polyorder==1&&variance_power==1
    q=sqrt(fitparams(1));
    p=-fitparams(2)/fitparams(1);
end

%% comparison with ground-truth (in case original noise-free image exists)  %% THIS IS MEANINGFUL ONLY FOR THE CASE polyorder==1&&variance_power==1, as the examples have these orders
if add_noise
    rangex=[0:0.00001:1];
    mean_fit_error=mean((max(0,polyval(fitparams,rangex))).^(variance_power/2)-sqrt(max(0,polyval([a b],rangex))));
    rangex=[-0.1:0.0005:1.1];
    if exist('function_stdEst2D','file')==2||exist('function_stdEst2D','file')==6
        homoskedastic_MAD_estimate=function_stdEst2D(z,3);  %% this the classical Donoho's MAD estimate in the wavelet domain, for AWGN with constant variance
        disp(['mean fit error : ',num2str(mean_fit_error,4), '  homoskedastic MAD estimate for z: ', num2str(homoskedastic_MAD_estimate,5), ' for y: ' num2str(function_stdEst2D(y,3),5), '  noise sample std: ',num2str(std(z(:)-y(:)),4)]);
    else
        disp(['mean fit error : ',num2str(mean_fit_error,4), '   noise sample std: ',num2str(std(z(:)-y(:)),4)]);
    end
    if figure_verbosity==1||figure_verbosity>2
        hold on
        plot(rangex,max(0,sqrt(a*rangex+b)))
        if exist('function_stdEst2D','file')==2||exist('function_stdEst2D','file')==6
            plot([-10 0 1 10],homoskedastic_MAD_estimate*[1 1 1 1],'g-.')
        end
        hold off
    end
end
drawnow
pause(eps)
