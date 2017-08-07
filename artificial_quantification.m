clc;

%%
load('Yin_yang.mat')
l = (1:1024)'*1+500;
E1(1,1,1:1024) = create_ionization_edge(eV2ch(l,700),10,0.1,l);
E2(1,1,1:1024) = create_ionization_edge(eV2ch(l,1000),10,0.2,l);

A = repmat(E1,466,466,1).*repmat(BW,1,1,1024).*75;
B = repmat(E2,466,466,1).*repmat(BW,1,1,1024).*25;