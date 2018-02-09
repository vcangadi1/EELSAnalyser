function rZ = fourier_log(low_loss_data)


llow = low_loss_data(:,1);
Z = low_loss_data(:,2);

[Wp,Ep] = plasmon_fit(llow,Z);
llz = low_loss(llow,Ep,Wp,0,3);

[W0,~,A0,G] = zero_loss_fit(llow,Z);
ZLP = A0*G(llow,0,W0);

rZ = ifft(fft(ZLP).*log(abs((fft(Z/max(Z)))./(fft(llz/max(llz))))));