clc
close all
%%
EELS = readEELSdata('InGaN/100kV/EELS Spectrum Image6-b.dm3');

l = EELS.energy_loss_axis;

S = EELS.S;
N_map = zeros(EELS.SI_x,EELS.SI_y);

%%
id = zeros(EELS.SI_x, 1);
s = id;
f = id;

fun = @(Sp) sum(Sp(110:180) - feval(Power_law(l(1:110),Sp(1:110)),l(110:180)))*EELS.dispersion;
tic;
c = parallel.pool.Constant((1:EELS.SI_y)');
parfor ii = 1:EELS.SI_x,
    s(ii) = now; % plotIntervals data
    N_map(ii,:) = arrayfun(@(jj) fun(S(ii,jj)), c.Value);
    f(ii) = now; % plotIntervals data
    id(ii) = getMyTaskID; % plotIntervals data % getMyTaskID.m required
end
toc;
plotIntervals(s, f, id, min(s)); % plotIntervals

%%
N = N_map./Sigmal3(31,ii,198,15);