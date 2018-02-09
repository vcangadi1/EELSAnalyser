function Tsigma2p = sample_sigma2(A_est,M_est,Y)


[L P] = size(Y);

% coeff1 = ones(P,1)*L/2;
tmp = Y - M_est*A_est;
% coeff2 = (sum(tmp.^2,1)/2)';

coeff1 = P*L/2;
coeff2 = sum((sum(tmp.^2,1)/2))';
%  = (sum(tmp.^2,1)/2)';


Tsigma2p = 1/gamrnd(coeff1,1./coeff2);