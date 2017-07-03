clc
close all
%%

%EELS = readEELSdata('InGaN/100kV/EELS Spectrum Image6-b.dm3');

%S = EELS_sum_spectrum(EELS);
l = EELS.energy_loss_axis;

%%

for ii = EELS.SI_x:-1:1,
    for jj = EELS.SI_y:-1:1,
        
        S = EELS.S(ii,jj);
        
        b = feval(Exponential_fit(l(300:825),S(300:825)),l);
        b = [b(30:end);zeros(29,1)];
        
        Ox(ii,jj,:) = S - b;
        Ox(ii,jj,1:242) = 0;
    end
end

%%

OMap = sum(Ox(:,:,242:442),3);

qOMap = OMap./Sigmak3(8,532,200,100,45);

