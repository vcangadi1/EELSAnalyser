function [ZZ,zlp_peak,zfwhm] = fit_zero_loss_peak(energy_loss_axis,low_loss)


%%

ZZ = low_loss;
ll = energy_loss_axis;
zfwhm = fwhm(ll,ZZ)/(2*sqrt(2*log(2)));

fun = @(A) sum((ZZ-A(1)*normpdf(ll,A(2),zfwhm)).^2);

A0 = [100,0];

A = fminsearch(fun, A0);

zlp_peak = A(2);

ZZ = A(1)*normpdf(ll,A(2),zfwhm);