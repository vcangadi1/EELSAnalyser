function y = lorentz(x,Ep,FWHM)

%p(1) = FWHM/(2*pi);
%p(2) = Ep;
%p(3) = (FWHM/2)^2;

%y = p(1)./((x - p(2)).^2 + p(3));
%y = (1/pi).* FWHM ./ ((x-Ep).^2 + FWHM.^2);

y = (1./pi) .* (FWHM./2)./((x-Ep).^2+(FWHM./2).^2);