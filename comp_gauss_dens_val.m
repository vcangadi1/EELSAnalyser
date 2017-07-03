function z=comp_gauss_dens_val(m,S,x)

[l,q]=size(m); %l=dimentionality

z = (1/((2*pi)^(1/2)*det(S)^0.5))...
    *exp(-0.5*(x-m)'*inv(S)*(x-m));