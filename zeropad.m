function [x,n] = zeropad(x,n,N)

if(min(N)<min(n))
    for i  = min(N):min(n)-1,
        x = [0 x];
    end
else
    for i  = min(n):min(N)-1,
        x(1) = [];
    end
end

if(max(n)<max(N))
    for i  = max(n):max(N)-1,
        x = [x 0];
    end
else
    for i  = max(N):max(n)-1,
        x(length(x)) = [];
    end
end

n = N;

end