function y=lagrange(pointx,pointy,x)
%
% LAGRANGE: Approx a desired point vlaue using Lagrange interpolating polynomials
% LAGRANGE(xpoint, ypoint, x) provides a function that passes through the points:
% {(xpoint(1),ypoint(1)), (xpoint(2), ypoint(2)), …,(xpoint(N),ypoin(N))} and calculate the value at x.
%
% Inputs:
% pointx - independent variable
% pointy - dependent variable
% x - value of independent variable at which the interpolation is calculated
% Output:
% y - interpolated value of dependent variable at x
% If xpoint and ypoint have different number of elements, the function will return the value ‘NaN’.
%
if size (pointx,1) ==1
    pointx =pointx';
end
if size (pointy,1) ==1
    pointy =pointy';
end
n=size(pointx,1);
L=ones(n,size(x,1));
if (size(pointx,1)~=size(pointy,1))
    fprintf(1,'\nERROR!\nPOINTX and POINTY must have the same number of elements\n');
    y=NaN;
else
    for i=1:n
        for j=1:n
            if (i~=j)
                L(i,:)=L(i,:).*(x-pointx(j))/(pointx(i)-pointx(j));
            end
        end
    end
    y=0;
    for i=1:n
        y=y+pointy(i)*L(i,:);
    end
end