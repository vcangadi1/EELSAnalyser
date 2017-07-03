% ICA using tanh nonlinearity and batch covariant algorithm
% (c) Zoubin Ghahramani
%
% function [W, Mu, LL]=ica(X,cyc,eta,Winit);
%
% X - data matrix (each row is a data point), cyc - cycles of learning (default = 200)
% eta - learning rate (default = 0.2), Winit - initial weight
%
% W - unmixing matrix, Mu - data mean, LL - log likelihoods during learning
function [W, Mu, LL]=ica(X,cyc,eta,Winit)
if nargin<2
    cyc=200;
end
if nargin<3
    eta=0.2;
end
[N,D]=size(X); % size of data
Mu=mean(X); X=X-ones(N,1)*Mu; % subtract mean
if nargin>3
    W=Winit; % initialize matrix
else
    W=rand(D,D);
end
LL=zeros(cyc,1); % initialize log likelihoods
for i=1:cyc,
    U=X*W;
    logP=N*log(abs(det(W)))-sum(sum(log(cosh(U))))-N*D*log(pi);
    %W=W+eta*(W-tanh(U)*U*W/N); % covariant algorithm
    W=W+eta*(inv(W)-X'*tanh(U)/N)'; % standard algorithm
    LL(i)=logP; fprintf('cycle %g log P= %g\n',i,logP);
end;