clc
close all
%%
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

S = EELS_sum_spectrum(EELS);

l = EELS.energy_loss_axis';

%% Arsenic - Power-law
% Over-estimate
As_p_over = feval(Power_law(l(670:end),S(670:end)),l);
ov = As_p_over;
As_p_over = As_p_over - (As_p_over(472) - S(472));

% Under-estimate
As_p_under = feval(Power_law(l(370:470),S(370:470)),l);

%%
 
Over_estimate = zeros(1024,1);
Under_estimate = zeros(1024,1);

As_over = S - As_p_over;
%quantify overestimate
qAs_p_o = sum(As_over(473:673))/Sigmal3(33,673-473,198,15);

As_under = S - As_p_under;
%quantify underestimate
qAs_p_u = sum(As_under(473:673))/Sigmal3(33,673-473,198,15);


for ii = 472:1024,
    Over_estimate(ii) = As_p_over(ii)+sqrt(sum(As_over(472:ii)));
    Under_estimate(ii) = As_p_under(ii)-sqrt(sum(As_under(472:ii)));
end

As_p_Opti = (Over_estimate+Under_estimate)./2;

%%
figure (1)
p1 = plotEELS(l,S);
%legend(p1,'GaAs spectrum')
hold on
p2 = plotEELS(l,As_p_over);
%legend(p2,'As over-estimate')

for ii = 472:50:1024,
    errorbar(l(ii),As_p_over(ii),sqrt(sum(As_over(472:ii))),'k')
end
p3 = plotEELS(l,As_p_under);
%legend(p3,'As under-estimate');


for ii = 472:50:1024,
    errorbar(l(ii),As_p_under(ii),sqrt(sum(As_under(472:ii))),'k')
end

p4 = plotEELS(l(472:end),As_p_Opti(472:end));
legend([p1 p2 p3 p4],{'GaAs spectrum','As over-estimate','As under-estimate','Optimal background with minimum error bars'})

title('As Power-law fit');

%% Subtract As edge from the spectrum
As = (S - As_p_Opti);
As(1:471) = 0;
SS = S;
S = S-As;

%% Galium - Power-law
% Over-estimate
Ga_p_over = feval(Power_law(l(465:end),S(465:end)),l);

Ga_p_over = Ga_p_over - (Ga_p_over(265) - S(265));

% Under-estimate
Ga_p_under = feval(Power_law(l(200:265),S(200:265)),l);

%%
Over_estimate = zeros(1024,1);
Under_estimate = zeros(1024,1);

Ga_over = S - Ga_p_over;
%quantify overestimate
qGa_p_o = sum(Ga_over(265:465))/Sigmal3(31,465-265,198,15);

Ga_under = S - Ga_p_under;
%quantify underestimate
qGa_p_u = sum(Ga_under(265:465))/Sigmal3(31,465-265,198,15);

fprintf('Over estimate - Power-law = %6.4f\n',abs(qGa_p_o/qAs_p_o));
fprintf('Under estimate - Power-law = %6.4f\n',abs(qGa_p_u/qAs_p_u));

for ii = 265:1024,
    Over_estimate(ii) = Ga_p_over(ii)+sqrt(sum(Ga_over(265:ii)));
    Under_estimate(ii) = Ga_p_under(ii)-sqrt(sum(Ga_under(265:ii)));
end

Ga_p_Opti = (Over_estimate+Under_estimate)./2;

%%
figure (2)
plotEELS(l,S)
hold on
plotEELS(l,Ga_p_over)


for ii = 265:50:1024,
    errorbar(l(ii),Ga_p_over(ii),sqrt(sum(Ga_over(265:ii))),'k')
end
plotEELS(l,Ga_p_under)


for ii = 265:50:1024,
    errorbar(l(ii),Ga_p_under(ii),sqrt(sum(Ga_under(265:ii))),'k')
end

plotEELS(l(265:end),Ga_p_Opti(265:end))

title('Ga Power-law fit');

%%
%figure;
Ga = S - Ga_p_Opti;
Ga(1:264) = 0;
%plotEELS(l,Ga)
%hold on
%plotEELS(l,As)
%% Quantification 
qGa = sum(Ga(265:465))/Sigmal3(31,465-265,198,15);
qAs = sum(As(473:673))/Sigmal3(33,673-473,198,15);
GaAsp = abs(qGa/qAs);
fprintf('GaAs - Power-law = %6.4f\n',GaAsp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Arsenic - Exponential
% Over-estimate
As_e_over = feval(Exponential_fit(l(670:end),SS(670:end)),l);

As_e_over = As_e_over - (As_e_over(472) - SS(472));

% Under-estimate
As_e_under = feval(Exponential_fit(l(370:470),SS(370:470)),l);

%%

Over_estimate = zeros(1024,1);
Under_estimate = zeros(1024,1);

As_over = SS - As_e_over;
%quantify overestimate
qAs_e_o = sum(As_over(473:673))/Sigmal3(33,673-473,198,15);

As_under = SS - As_e_under;
%quantify underestimate
qAs_e_u = sum(As_under(473:673))/Sigmal3(33,673-473,198,15);

for ii = 472:1024,
    Over_estimate(ii) = As_e_over(ii)+sqrt(sum(As_over(472:ii)));
    Under_estimate(ii) = As_e_under(ii)-sqrt(sum(As_under(472:ii)));
end

As_e_Opti = (Over_estimate+Under_estimate)./2;
%%
figure (3);
plotEELS(l,SS)
hold on
plotEELS(l,As_e_over)


for ii = 472:50:1024,
    errorbar(l(ii),As_e_over(ii),sqrt(sum(As_over(472:ii))),'k')
end
plotEELS(l,As_p_under)


for ii = 472:50:1024,
    errorbar(l(ii),As_e_under(ii),sqrt(sum(As_under(472:ii))),'k')
end

plotEELS(l(472:end),As_e_Opti(472:end))

title('As exponential fit');

%% Subtract As from spectrum
Ase = (SS - As_e_Opti);
Ase(1:471) = 0;
S = SS-As;

%% Galium - Exponential
% Over-estimate
Ga_e_over = feval(Exponential_fit(l(465:end),S(465:end)),l);

Ga_e_over = Ga_e_over - (Ga_e_over(265) - S(265));

% Under-estimate
Ga_e_under = feval(Exponential_fit(l(200:265),S(200:265)),l);

%%
Over_estimate = zeros(1024,1);
Under_estimate = zeros(1024,1);

Ga_over = S - Ga_e_over;
%quantify overestimate
qGa_e_o = sum(Ga_over(265:465))/Sigmal3(31,465-265,198,15);

Ga_under = S - Ga_e_under;
%quantify underestimate
qGa_e_u = sum(Ga_under(265:465))/Sigmal3(31,465-265,198,15);

fprintf('Over estimate - Exponential = %6.4f\n',abs(qGa_e_o/qAs_e_o));
fprintf('Under estimate - Exponential = %6.4f\n',abs(qGa_e_u/qAs_e_u));

for kk = 265:1024,
    Over_estimate(kk) = Ga_e_over(kk)+sqrt(sum(Ga_over(265:kk)));
    Under_estimate(kk) = Ga_e_under(kk)-sqrt(sum(Ga_under(265:kk)));
end

Ga_e_Opti = (Over_estimate+Under_estimate)./2;

%%
figure (4);
plotEELS(l,S)
hold on
plotEELS(l,Ga_e_over)


for ii = 265:50:1024,
    errorbar(l(ii),Ga_e_over(ii),sqrt(sum(Ga_over(265:ii))),'k')
end
plotEELS(l,Ga_e_under)


for ii = 265:50:1024,
    errorbar(l(ii),Ga_e_under(ii),sqrt(sum(Ga_under(265:ii))),'k')
end

plotEELS(l(265:end),Ga_e_Opti(265:end))

title('Ga exponential fit');
%% Quantification
Gae = S - Ga_e_Opti;
Gae(1:264) = 0;

qGae = sum(Gae(265:465))/Sigmal3(31,465-265,198,15);
qAse = sum(Ase(473:673))/Sigmal3(33,673-473,198,15);
GaAse = abs(qGae/qAse);
fprintf('GaAs - Exponential = %6.4f\n',GaAse);