function X = trandn(Mu,Sigma)

Mu    = Mu(:);
Sigma = Sigma(:);
%
T = length(Mu);
%
U = rand(T,1);
V = erf(- Mu./(sqrt(2)*max(Sigma,eps)));
X = Mu + sqrt(2*Sigma.^2) .* erfinv(-(((1-V).*U + V)==1)*eps+(1-V).*U + V);
X = max(X,eps);
