function parforIterateDemo
% Copyright 2013 The MathWorks, Inc.
% How many iterations
N = 300;
% Min and max time for a loop iteration (in ms)
minM = 10;
maxM = 100;
id = zeros(N, 1);s = id; f = id;

parfor i = 1:N    
    S = randi([minM maxM]);
    % Gather information about this iterate
    s(i) = now;    
    iSlowFunction(S);
    f(i) = now;
    id(i) = getMyTaskID;
end

plotIntervals(s, f, id, min(s));


function o = iSlowFunction(M)
% The computation in the loop below takes about 1ms
for ii = 1:M
    o = max(abs(eig(rand(56))));
end