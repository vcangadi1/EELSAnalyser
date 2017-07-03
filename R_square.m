function R2 = R_square(Signal,Estimate)

%%
S_bar = mean(real(Signal));

R2 = 1 - (sum((real(Signal) - real(Estimate)).^2)/sum((real(Signal) - S_bar).^2));
