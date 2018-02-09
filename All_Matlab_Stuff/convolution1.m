% Convolution
function [y,yn]=convolution1(x1,n1,x2,n2)
    
    if signalValidity(x1,n1)==0
        error('x1 & n1 must be of the same size');
    end 
    if signalValidity(x2,n2)==0
        error('x2 & n2 must be of the same size');
    end

    % Time reverse the second signal 
    [xr2,nr2]=timeReversal(x2,n2);
    
    N1=size(n1,2);
    N2=size(n2,2);
    
    % endpoints of signals
    n11=n1(1,1);
    n12=n1(1,N1);
    n21=n2(1,1);
    n22=n2(1,N2);
    
    % y-resulting signal ; yn-index set of the resulting signal
    y=zeros(1,N1+N2-1);
    yn=n11+n21:n12+n22;
    
    % convolution operation
    i=0;
    for n=n11+n21:n12+n22
        nrs2=timeShift(nr2,n);
        p=signalMult(x1,n1,xr2,nrs2);
        i=i+1;
        y(1,i)=sum(p);
    end
    
end