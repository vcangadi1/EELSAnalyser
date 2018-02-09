function Y = multrandn(m,Sigma,N);

%------------------------------------------------------------------
% This function allows to sample according to a multivariate
% gaussian distribution
% 
% INPUT
%       m     : mean vector
%       Sigma : covariance matrix
%       N     : number of vectors to be generated
%
% OUTPUT
%       Y : the generated samples
%
%------------------------------------------------------------------


% size of the vectors to be generated
n = length(m);

% mean vector
B = m;

% Cholesky vector
A = chol(Sigma);
A = A';

% generation
X = randn(n,N);
Y = A*X+kron(B,ones(1,N));
