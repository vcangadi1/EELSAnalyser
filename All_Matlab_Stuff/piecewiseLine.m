function y = piecewiseLine(x,a,b,c,d,k)
% PIECEWISELINE   A line made of two pieces
% that is not continuous.

y1 = zeros(size(x));

% This example includes a for-loop and if statement
% purely for example purposes.
for i = 1:length(x)
    if x(i) < k,
        y1(i) = a + b.* x(i);
    else
        y1(i) = c + d.* x(i);
    end
end
y = log(y1);
end