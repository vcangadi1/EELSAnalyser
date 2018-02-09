function y = voigt_fun(x,W0,Ep,Wp)

g = 1./(W0./(2*sqrt(log(4))))./sqrt(2*pi) .* exp(-(x/(sqrt(2) .* (W0./(2*sqrt(log(4)))))).^2);

l = (1./pi) .* (Wp./2)./((x-Ep).^2+(Wp./2).^2);

y = conv(g,l,'same');