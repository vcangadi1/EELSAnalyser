function gpuPagefunDemo
% Copyright 2013 The MathWorks, Inc.
% Define the sizes of the matricies we are going to multiply
M = 25; N = 26; K = 27;
% And how many there will be
T = 2500;
%% Make the arrays
A = gpuArray.rand(M, N, T);
B = gpuArray.rand(N, K);
d = gpuDevice;
%% Do the computation on the GPU using pagefun - don't forget to wait
tic
gC = pagefun(@mtimes, A, B);
wait(d);
tGPU = toc;

A = gather(A);B = gather(B);
C = zeros(M, K, T);
%% Bring the data back to the CPU and do the same computation
tic
for ii = 1:T
    C(:, :, ii) = A(:, :, ii) * B;
end
tCPU = toc;
%% Workout what the biggest discrepancy between CPU and GPU is (in terms of
% eps)
maxError = gather(max(abs(C(:) - gC(:)))) / eps;
% Print the results
fprintf('Difference between CPU and GPU: %4.1f eps\n', maxError);
fprintf('Time on the CPU: %5.2f ms\n', tCPU*1000);
fprintf('Time on the GPU: %5.2f ms\n', tGPU*1000);
fprintf('Speedup: %4.1f\n', tCPU/tGPU);
