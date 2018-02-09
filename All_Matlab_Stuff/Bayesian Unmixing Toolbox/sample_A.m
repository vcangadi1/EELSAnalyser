function A = sample_A(X,S,A,R,P,sigma2e)

% ------------------------------------------------------------------
% This function allows to sample the abundances 
%       according to its posterior f(A|...)
% USAGE
%       A = sample_abundances(X,S,A,R,P,L,sigma2e,mu0,rhoa,psia)
% 
% INPUT
%       X,S,A : matrices of mixture, sources and mixing coefficients 
%       R,P,L  : number of sources, observations and samples
%       sigma2e : the current state of the sigma2 parameter
%       rho,psi  : hyperprior parameters 
% 
% OUTPUT
%       A     : the new state of the A parameter
% 
% ------------------------------------------------------------------

y = X;

ord = randperm(R); 
jr = ord(R);
comp_jr = ord(1:(R-1));
alpha    = A(:,comp_jr);

% useful quantities
u = ones(R-1,1);
M_R = S(jr,:)';
M_Ru = M_R*u';
M = S(comp_jr,:)';
T = (M-M_Ru)'*(M-M_Ru);
%
for p=1:P
    Sigma = inv(T/sigma2e);
    Mu    = Sigma*((1/sigma2e)*(M-M_Ru)'*(y(p,:)'-M_R));
    %
    alpha(p,:) = dtrandnmult(alpha(p,:),Mu,Sigma);
end
A(:,ord(1:(R-1))) = alpha;
A(:,ord(R)) = max(1-sum(alpha,2),0);