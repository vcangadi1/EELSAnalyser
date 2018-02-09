function X = dtrandn_MH(X,Mu,Sigma,Mum,Mup)

Mu_new = Mu - Mum;
Mup_new = Mup -Mum;

if Mu<Mup
    Z= randnt(Mu_new,Sigma,1);
else
    
    delta = Mu_new - Mup_new;
    Mu_new = -delta;
    Z= randnt(Mu_new,Sigma,1);
    Z = -(Z-Mup_new );

end
    Z = Z+Mum;
    cond = (Z<=Mup) &&  (Z>=Mum);
    X = (Z.*cond + X.*(~cond));