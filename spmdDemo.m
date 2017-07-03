function spmdDemo
% Copyright 2013 The MathWorks, Inc.
%#ok<*NOPRT,*PFOUS,*NASGU>
% The problem at hand is to monte-carlo integrate the 2D function f from
% zero to lim. However we want to carry out this integration samples times
% to see what our integration error is, and keep increasing the number of
% samples by a factor of growN from an initial value of initN until the
% standard deviation is within tolerance defined by tol.
f = @iFunctionToItegrate;
lim = 2*pi;
initN = 100;
growN = 1.1;
samples = 500;
tol = 1e-2; 

% ---- Solve the problem with parfor ----
tic
N = initN; n = 0;
while true
    int = zeros(1, samples);
    parfor ii = 1:samples
        int(ii) = iMontecarloIntegral(f, N, lim); 
    end
    if std(int) < tol 
        break
    else
        N = ceil(N*growN);
        n = n + 1;
    end
end
t = toc;
fprintf('Time to solve using parfor : %5.2f secs with %d iterations\n', t, n);

nParfor = n;
% ---- Solve the problem with spmd ----
tic
N = initN; n = 0;
spmd
    % Workout how many samples this lab should compute (of all samples)
    p = codistributor1d.defaultPartition(samples);
    int = zeros(1, p(labindex));
    while true
        for ii = 1:numel(int) 
            int(ii) = iMontecarloIntegral(f, N, lim);
        end
        % Test hould be std(gcat(int)) < tol but want same number of
        % iterates for timing purposes
        if n >= nParfor
            break
        else
            N = ceil(N*growN);
            n = n + 1;
        end
    end
end
t = toc;
fprintf('Time to solve using spmd   : %5.2f secs with %d iterations\n', t, n{1});
end



function o = iFunctionToItegrate(x, y)
o = sin(100*x) + sin(20*y);
end

function x = iMontecarloIntegral(f, N, lim, q)
% If we are passed a random stream to use then use it, otherwise use the
% stashed one that lives in the persistent variable here (used from parfor
% computation)
persistent q_persist
if nargin < 4
    if isempty(q_persist)
        q_persist = qrandstream(scramble(sobolset(2),'MatousekAffineOwen'));
    end
    q = q_persist;
end
% Carry-out one integration
X = qrand(q, N)*lim;
x = sum(f(X(:,1),X(:, 2)))/N*(lim*lim);
end

