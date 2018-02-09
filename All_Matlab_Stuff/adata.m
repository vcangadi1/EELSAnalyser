clc

E = (1:1:1024);

D = 0.5;

t = E.*D;

     u = heaviside((t));
     
     subplot(211), plot(t,u);
     t(t==100)=101;
     h = (t).^-2 .* u;
     subplot(212), plot(t,h);