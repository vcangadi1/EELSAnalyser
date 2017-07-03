%function [YY,NN] = convolution(x,n,h,m)
clc
x = [1 1 2 3];
n = 0:3;
h = 1:2;
m = -1:0;

strt = min(min(m), min(n));

NN = strt : strt+length(n)+length(m)-2;

[h1,m1] = fold(h,m);

[h1,m1] = shift(h1,m1,-m(1));


N = min(n)-length(m)+1:max(n)+length(m)-1;

[x1,n1] = zeropad(x,n,N);

for i = 1 : length(m)+length(n)-1,
    [h1,m1] = zeropad(h1,m1,N);
    size(x1);
    size(h1);
    y(i) = sum(x1.*h1);
    [h1,m1] = shift(h1,n1,-1);
end

YY = y;