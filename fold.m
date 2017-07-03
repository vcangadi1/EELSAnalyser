function [x,n] = fold(y,n1)

x = y(length(y):-1:1);

n = -n1(length(n1):-1,1);

end