%x1 - input signal-row vector
%n1 - index set of input signal-row vector
%x2 - output signal-row vector
%n2 - index set of output signal-row vector
%interface - [x2,n2]=timeReversal(x1,n1)

function [x2,n2]=timeReversal(x1,n1)
    
    if signalValidity(x1,n1)==0
        error('x1 & n1 must be of the same size');
    end

    N=size(x1,2);
    
    %initialize the output signals
    x2=zeros(1,N);
    n2=zeros(1,N);
    
    %flip the input signal x1
    j=N;
    for i=1:N
        x2(1,i)=x1(1,j);
        j=j-1;
    end
    
    %flip the index set n1 and take its negative
    j=N;
    for i=1:N
        n2(1,i)=-n1(1,j);
        j=j-1;
    end
end