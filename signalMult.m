function [x,n]=signalMult(x1,n1,x2,n2)

    if signalValidity(x1,n1)==0
        error('x1 & n1 must be of the same size');
    end 
    if signalValidity(x2,n2)==0
        error('x2 & n2 must be of the same size');
    end

% sizes of the first & second signals
N1=size(x1,2);
N2=size(x2,2);

xz1=x1;
xz2=x2;

% select parts of both signals where they overlap. If they dont overlap,
% the signal x=0 & n=0 is the output
if n1(1,N1)<n2(1,1) || n1(1,1)>n2(1,N2)
    x=0;
    n=0;
else
    if n1(1,1)<n2(1,1)
        nbegin=n2(1,1);
        if n1(1,N1)<n2(1,N2)
            nend=n1(1,N1);
            xz1=x1(1,n2(1,1)-n1(1,1)+1:N1);
            xz2=x2(1,1:N1-(n2(1,1)-n1(1,1)));
        else
            nend=n2(1,N2);
            xz1=x1(1,n2(1,1)-n1(1,1)+1:n2(1,1)-n1(1,1)+N2);
        end
    else
        nbegin=n1(1,1);
        if n1(1,N1)<n2(1,N2)
            nend=n1(1,N1);
            xz2=x2(1,n1(1,1)-n2(1,1)+1:n1(1,1)-n2(1,1)+N1);
        else
            nend=n2(1,N2);
            xz2=x2(1,n1(1,1)-n2(1,1)+1:N2);
            xz1=x1(1,1:N2-(n1(1,1)-n2(1,1)));
        end
    end

% signal multiplication & determination of the index set of the product
% signal
x=xz1.*xz2;
n=nbegin:nend;

end

end