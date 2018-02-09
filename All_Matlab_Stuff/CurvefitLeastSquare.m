clc, clear all, close all;
si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' )
N = size(si_struct.image_data,3);
fprintf('\nLength of the spectrum z-axis : %d\n',N);
D = si_struct.zaxis.scale;
fprintf('\nDispersion : %.2f\n',D);
Origin = si_struct.zaxis.origin;
fprintf('\nOrigin : %d\n',Origin);
Scale = (((0:N-1)-Origin-31).* D).';
for i = 1:16,
    for j = 1:16,
        EELS_spectrum = si_struct.image_data(i,j,:);
        EELS_spectrum = reshape(EELS_spectrum,1,N);
    end;
end
sp = zeros([1024,2]);
sp(:,1) = Scale;
sp(:,2) = EELS_spectrum;
Data = ...
  [0.0000    5.8955
   0.1000    3.5639
   0.2000    2.5173
   0.3000    1.9790
   0.4000    1.8990
   0.5000    1.3938
   0.6000    1.1359
   0.7000    1.0096
   0.8000    1.0343
   0.9000    0.8435
   1.0000    0.6856
   1.1000    0.6100
   1.2000    0.5392
   1.3000    0.3946
   1.4000    0.3903
   1.5000    0.5474
   1.6000    0.3459
   1.7000    0.1370
   1.8000    0.2211
   1.9000    0.1704
   2.0000    0.2636];

t = sp(1:150,1);%Data(:,1);
y = sp(1:150,2);%Data(:,2);
% axis([0 2 -0.5 6])
% hold on
plot(t,y,'ro')
title('Data points')
% hold off

F = @(x,xdata)x(1)*exp(x(2)*xdata) + x(3)*exp(-x(4)*xdata);

x0 = [1 1 1 0];

[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y)

hold on
%plot(t,F(x,t))
hold off

Fsumsquares = @(x)sum((F(x,t) - y).^2);
opts = optimoptions('fminunc','Algorithm','quasi-newton');
[xunc,ressquared,eflag,outputu] = ...
    fminunc(Fsumsquares,x0,opts)

fprintf(['There were %d iterations using fminunc,' ...
    ' and %d using lsqcurvefit.\n'], ...
    outputu.iterations,output.iterations)
fprintf(['There were %d function evaluations using fminunc,' ...
    ' and %d using lsqcurvefit.'], ...
    outputu.funcCount,output.funcCount)

p5 = polyfit(t,y,5);
y3 = polyval(p5,t);

figure
plot(t,y,'o',t,y)
title('Fifth-Degree Polynomial Fit')

