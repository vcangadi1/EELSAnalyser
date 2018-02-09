function S = dtrandnmult(S,Mu,Re)

% Missing data sampling
S = S(:); Mu = Mu(:);
%
R = length(S);
if R==1,
    S = trandn(Mu,sqrt(Re));
else
    %
    for r=1:R
        Rm = Re;     Rm(r,:) = [];
        Rv = Rm(:,r);     Rm(:,r) = [];
        Sigma_mat{r}  = inv(Rm);
        Sigma_vect{r} = Rv;
    end
    %
    for iter=1:5
        for k=randperm(R)
            Sk = S; 
            Sk(k) = [];
            Muk = Mu; Muk(k) = [];
            Moy_Sv(k)  = Mu(k) + Sigma_vect{k}'*Sigma_mat{k}*(Sk-Muk);
            Var_Sv(k)   = Re(k,k) - Sigma_vect{k}'*Sigma_mat{k}*Sigma_vect{k};
            Std_Sv(k)   = sqrt(abs(Var_Sv(k)));
            S(k) = dtrandn_MH(S(k),Moy_Sv(k),Std_Sv(k),0,[1-sum(S)+S(k)]);
    end
    end
end

