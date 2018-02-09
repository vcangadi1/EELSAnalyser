function y=signalValidity(x,n)
    if size(x,2)~=size(n,2)
        y=0;
    else
        y=1;
    end
end