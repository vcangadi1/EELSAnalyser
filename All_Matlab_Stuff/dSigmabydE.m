clc
%%
EELS = readEELSdata('InGaN/100kV/EELS Spectrum Image6-b.dm3');
%%
Z = 7;
e = 100;
edge_type = 'k';
E0 = 100;
beta = 45;
%l = EELS.energy_loss_axis;
l = (1:1024)'*1+250;
%%
nl = length(l);
d = mean(diff(l));
C = zeros(length(l),1);

%%
switch edge_type
    case {'L23','L','L3','L2','l23','l','l3','l2'}
        rng = d*(1:nl-e)';
        CS = [zeros(e,1); gradient(arrayfun(@(ii) Sigmal3(Z,ii,E0,beta), rng))];
        
    case {'K','k'}
        rng = d*(1:nl-e)';
        CS = [zeros(e,1); gradient(arrayfun(@(ii) Sigmak3(Z,l(e),ii,E0,beta), rng))];
    case {'M','M45'}
        temp = 0;
end
%%
disp(CS);
if length(CS)>nl
    C = CS(1:nl);
else
    C(1:length(CS)) = CS;
end

plotEELS(l,C)