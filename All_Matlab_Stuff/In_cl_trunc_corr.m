function cor = In_cl_trunc_corr(x)
%%
%
%%
x_value = [1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1 0];
correction_to_sum = [2.204065904 2.008173594 1.836564383 1.68407018,...
                     1.549137032 1.433339148 1.326518424 1.230818344,...
                     1.145418392 1.064222791 1];

%%
f = polyfit(x_value,correction_to_sum,2);

%%
cor = polyval(f,x);