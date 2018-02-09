function [p,a] = NewtonPoly(xData,yData,x)
% Returns the polynomiL coefficients a and value of Newton’s polynomial at x.
% USAGE: [p,a] = newtonPoly(xData,yData,x)
% Inputs:
% xData - data points for independent variable x.
% yData - data points for dependent variable y.
% x - value of independent variable at which the polynomial is
% evaluated.
% Outputs:
% a - coefficient array of the polynomial.
% p - the value of the polynomial at x.
n=length(xData);
a = yData;
for k = 2:n,
    a(k:n) = (a(k:n) - a(k-1))./(xData(k:n) - xData(k-1));
end
n = length(xData);
p = a(n);
for k = 1:n-1,
    p = a(n-k) + (x - xData(n-k))*p;
end