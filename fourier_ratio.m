function rE = fourier_ratio(low_loss_data, Sigma, core_loss_data, FilterOption)

llow = low_loss_data(:,1);

if nargin < 4
    FilterOption = 'none'; %'chebwin';
end

Z = low_loss_data(:,2)/sum(low_loss_data(:,2));

Zn = ifftshift(shift_zlp(Z,llow));

lcor = core_loss_data(:,1);
pE = core_loss_data(:,2);

%% Fourier-Ratio deconvolution

if Sigma > 0
    R = normpdf(lcor,lcor(floor(length(lcor)/2)),Sigma);
    rE = ifft(fft(R).*fft(pE)./fft(Zn));
elseif Sigma == 0
    rE = fftshift(ifft(fft(pE)./fft(Zn)));
end

%% Remove ringing effect
% Filter
if ~strcmpi(FilterOption,'none')
    L = 100;
    fhandle = str2func(FilterOption);
    h = window(fhandle,L*2);
    H = [zeros((length(Z)-L*2)/2,1);h;zeros((length(Z)-L*2)/2,1)];
    
    % Fourier transform the spectrum
    fftrE = fftshift(fft(rE));
    hrE = fftrE .* H;
    rE = abs(ifft(hrE));
end

%% Set anthing below zero to zero

%rE(rE<0) = 0;

%% Plot
%{
%figure(1);
hold on
plotEELS(lcor,pE)
plotEELS(lcor,rE)
hold off
legend({'Plural scattering','fourier-ratio deconv'},'FontWeight','bold');
legend boxoff
box on
%}