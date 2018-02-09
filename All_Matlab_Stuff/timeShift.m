%n1-index set of the input signal-row vector
%n2-index set of output signal-row vector
%n0-time shift
%implements y(n)=x(n-n0)
%interface: n2=timeShift(n1,n0)

function n2=timeShift(n1,n0)
    n2=n1+n0;
end
