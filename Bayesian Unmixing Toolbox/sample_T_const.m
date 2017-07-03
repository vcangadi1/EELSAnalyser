function [T_out M_out] = sample_T_const(A,M,T,sigma2p,Tsigma2r,matU,Y_bar,Y,E_prior,bool_plot,y_proj)

T_out = T;
K = size(T_out, 1);
M_out = M;

R = size(A,1);
[L P] = size(Y);



for r=randperm(R)%1:R    
    comp_r = setdiff(1:R,r);
    
    alpha_r = A(comp_r,:);
    alphar(1:P) = A(r,:);
    invSigma_r = sum((A(r,:).^2)'./sigma2p)*matU'*matU + 1/Tsigma2r(r)*eye(R-1);
    Sigma_r = inv(invSigma_r);
    
    
    er = E_prior(:,r);
    
    for k=randperm(K);
        tr = T_out(:,r);
        
        comp_k = setdiff([1:K],k);
        M_r = M_out(:,comp_r);
        Delta_r = (Y-M_r*alpha_r-Y_bar*alphar);
    
        mu = Sigma_r*(matU'*(sum(Delta_r.*(ones(L,1)*alphar)./sigma2p,2)) + er/Tsigma2r(r));
        
        skr = Sigma_r(comp_k,k);
        Sigma_r_k = Sigma_r(comp_k,comp_k);
        
        inv_Sigma_r_k = inv(Sigma_r_k);
        

        muk = mu(k) + skr'*inv_Sigma_r_k*(tr(comp_k,1)-er(comp_k,1));
        s2k = Sigma_r(k,k) - skr'*inv_Sigma_r_k*skr;
        
        % troncature
        
        vect_e = (-Y_bar-matU(:,comp_k)*tr(comp_k,1))./matU(:,k);
        setUp = (matU(:,k)>0);
        setUm = (matU(:,k)<0);
        mup = min([ 1/eps min(vect_e(setUm))]);
        mum = max([-1/eps max(vect_e(setUp))]);

        T_out(k,r) = dtrandn_MH(T_out(k,r),muk,sqrt(s2k),mum,mup);
        M_out(:,r) = matU*T_out(:,r)+Y_bar; 

        
    end
          
end




