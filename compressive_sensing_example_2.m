
%%
% f = signal = tone from "1" key on touch tone phone.
% b = random subsample.

%Fs = 40000;
%%
%EELS = readEELSdata;
I = EELS.Image(1:50,1:50);
[r,c] = size(I);
I = I(:);
%%
t = 1:length(I);
f = I;
n = length(f);
m = ceil(n/10);
k = randperm(n)';
k = sort(k(1:m));
b = f(k);

% Plot f and b.
% Plot idct(f) = inverse discrete cosine transform.
%%

figure(1);

subplot(2,1,1)
plot(t,f,'b-',t(k),b,'kx')
title('f = signal, b = random sample')

subplot(2,1,2)
plot(idct(f))
title('c = idct(f)')
drawnow
%%
% A = rows of DCT matrix with indices of random sample.

A = zeros(m,n);
for i = 1:m
    ek = zeros(1,n);
    ek(k(i)) = 1;
    A(i,:) = idct(ek); 
end
%%
% y = l_2 solution to A*y = b.

y = pinv(A)*b;

% x = l_1 solution to A*x = b.
% Use "L1 magic".

x = l1eq_pd(y,A,A',b,5e-3,25);

% Plot x and dct(x).
% Good comparison with f.
%%
figure(2)
subplot(2,1,1)
plot(x)
title('x = {\it l}_1 solution, A*x = b ')

subplot(2,1,2)
plot(t,dct(x))
title('dct(x)')

%%
% Plot y and dct(y).
% Lousy comparison with f.

figure(3)

subplot(2,1,1)
plot(y)
title('y = {\it l}_2 solution, A*y = b ')

subplot(2,1,2)
plot(t,dct(y))
title('dct(y)')

%%

figure(4)
subplot 131
plotEELS(reshape(I,r,c),'map')
title('45X22')

subplot 132
plotEELS(reshape(f,r,c),'map')
title('higher grid (134X65)')
X = reshape(dct(x),r,c);
subplot 133
plotEELS(X(:,1:end-5),'map')
title('interpolated')

%%
% Play three sounds.

%sound(f,Fs)
%pause(1)
%sound(dct(x),Fs);
%pause(1)
%sound(dct(y),Fs)