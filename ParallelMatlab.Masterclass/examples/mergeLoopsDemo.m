function mergeLoopsDemo( Na, Nb, Nc )
% Copyright 2013 The MathWorks, Inc.
a = zeros(Na, Nb, Nc); b = a;
% Nested set of for loops
tic
for ii = 1:Na
    for jj = 1:Nb
        for kk = 1:Nc
            a(ii, jj, kk) = mod(ii*jj*kk, 20);
        end
    end
end
toc
% ----------------------------
% Merge the loops together - this does NOT preserve iteration 
% order, but does allow linear indexing of merged variables 
% in the same way.
tic
[N, iterFun] = mergeLoopRanges([Na Nb Nc]);
parfor xx = 1:N
    % Compute the original ii, jj & kk for this loop iterate.
    [ii,jj,kk] = feval(iterFun, xx);
    b(xx) = mod(ii*jj*kk, 20);
end
toc
fprintf('Answers are the same: %d\n', isequal(a, b));