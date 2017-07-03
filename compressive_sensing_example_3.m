clc
clear all

%%

%EELS = readEELSdata;
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')
I = spectrum_image(EELS);
r = 1:ceil(size(I,1)/2);
c = 1:ceil(size(I,2)/2);

%% Put it on higher grid

f(3*r-1,3*c-1) = I(r,c);    % Assign pixels to center of the higher grid.
%f(end+1,end+1) = 0;
f = f(:);

%%

t = 1:length(f);
n = length(f);
m = length(r)*length(c);
k = find(f~=0);
b = f(k(:));

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

x = l1eq_pd(y,A,A',b,5e-3,20);

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
plotEELS(reshape(I(1:45,1:22),45,22),'map')
title('45X22')

subplot 132
plotEELS(reshape(f,134,65),'map')
title('higher grid (134X65)')

subplot 133
plotEELS(reshape(dct(x),134,65),'map')
title('interpolated')


%% Play three sounds.

%sound(f,Fs)
%pause(1)
%sound(dct(x),Fs);
%pause(1)
%sound(dct(y),Fs)