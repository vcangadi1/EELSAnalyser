function rZ = fourier_log(low_loss_data,Optional_ZLP)


llow = low_loss_data(:,1);
Z = low_loss_data(:,2);

if nargin < 2
    [W0,~,A0,G] = zero_loss_fit(llow,Z);
    ZLP = A0*G(llow,0,W0);
else
    ZLP = Optional_ZLP;
end

rZ = ifft(fft(ZLP).*log(fft(Z/max(Z))./fft(ZLP/max(ZLP))));