% Copyright 2013 The MathWorks, Inc.
N = 400;
% Build a waitbar to track progress
h = waitbar(0,'Creating requests on pool ...');
for idx = N:-1:1
    % Compute the rank of N magic squares
    F(idx) = parfeval(@rank,1,magic(idx));
end
h = waitbar(0,h, 'Waiting for FevalFutures to complete ...');
results = zeros(1,N);
for idx = 1:N
    [completedIdx,thisResult] = fetchNext(F);
    % store the result
    results(completedIdx) = thisResult;
    % update waitbar
    waitbar(idx/N,h,sprintf('Latest result: %d',thisResult));
end
delete(h)