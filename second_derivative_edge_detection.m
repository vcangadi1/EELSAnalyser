
S = feval(Spline(l,S),l);
G = gradient(gradient(S));
plotEELS(l,G)

Sigma = 1;
R = normpdf(l,l(512),Sigma)/sum(normpdf(l,l(512),Sigma));
rE = fftshift(ifft(fft(R).*fft(G)));
hold on
plotEELS(l,rE)
