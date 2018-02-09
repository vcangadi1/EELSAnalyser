function [even, odd, prime] = parforSearchDemo
% Copyright 2013 The MathWorks, Inc.
% Choose 400 random integers
% (around 1e13) to analyze
n = randi(1e13, 400, 1);

even = 0;
odd = 0;
prime = [];
parfor i = 1:numel(n)
    thisN = n(i);
    if mod(thisN, 2) == 0
        even = even + 1;
    else
        odd = odd + 1;
    end
    if isequal(factor(thisN), thisN)
        prime = [prime thisN];
    end
end