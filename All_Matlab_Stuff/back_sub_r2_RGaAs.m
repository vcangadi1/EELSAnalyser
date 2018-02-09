clc
clear

%%
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

S = EELS_sum_spectrum(EELS);

l = EELS.energy_loss_axis';

%% %%%%%%%%%%%%%%%%%%%Power-Law%%%%%%%%%%%%%%%%%%%%%%%%%
%% Arsenic
%% Under estimate
for jj = 100:-1:1,
    [f,gof] = Power_law(l(365+jj:472),S(365+jj:472));
    As_p_under = feval(f,l);
    
    As_under(:,jj) = S - As_p_under;
    r2_As_p_u(:,jj) = gof.rsquare;
end
disp(size(As_under));
% quantify
qAs_p_u = sum(As_under(473:673,:))./Sigmal3(33,673-473,198,15);

%% Galium
%% Under estimate

for jj = 100:-1:1,
    [f,gof] = Power_law(l(150+jj:265),S(150+jj:265));
    Ga_p_under = feval(f,l);
    
    Ga_under(:,jj) = S - Ga_p_under;
    r2_Ga_p_u(:,jj) = gof.rsquare;
end

disp(size(Ga_under));

%quantify
qGa_p_u = sum(Ga_under(265:465,:))./Sigmal3(31,465-265,198,15);

RGaAs_p_u = qGa_p_u./qAs_p_u;
%RGaAs_p_u = qAs_p_u./qGa_p_u;

%u = histogram(RGaAs_p_u.*(1:-1/100:1/100),'Normalization','pdf');

%% Arsenic
%% Over-estimate

for ii = 330:-1:1,
    [f,gof] = Power_law(l(670+ii:end),S(670+ii:end));
    As_p_over = feval(f,l);
    As_p_over = As_p_over - (As_p_over(472) - S(472));
    
    As_over(:,ii) = S - As_p_over;
    r2_As_p_o(:,ii) = gof.rsquare;
end

As_over(1:472,:) = 0;

% quantify
qAs_p_o = sum(As_over(473:673,:))./Sigmal3(33,673-473,198,15);

for ii = 1024:-1:473,
    Over_estimate(ii) = abs(As_p_over(ii)+sqrt(sum(As_over(472:ii,1))));
    Under_estimate(ii) = abs(As_p_under(ii)-sqrt(sum(As_under(472:ii,1))));
end

Opti = S;
%Opti(473:1024) = (Over_estimate(473:1024)+Under_estimate(473:1024))./2;

GS = Opti;

%% Galium
%% Over-estimate

for ii = 330:-1:1,
    [f,gof] = Power_law(l(465+ii:end),GS(465+ii:end));
    Ga_p_over = feval(f,l);
    Ga_p_over = Ga_p_over - (Ga_p_over(265) - GS(265));
    
    Ga_over(:,ii) = GS - Ga_p_over;
    r2_Ga_p_o(:,ii) = gof.rsquare;
end

Ga_over(1:265,:) = 0;

% quantify
qGa_p_o = sum(Ga_over(265:465,:))./Sigmal3(31,465-265,198,15);

RGaAs_p_o = qGa_p_o./qAs_p_o;
%RGaAs_p_o = qAs_p_o./qGa_p_o;

%hold on
%o = histogram(RGaAs_p_o.*(1:-1/330:1/330),'Normalization','pdf');

%{
mu = mean(RGaAs_p_u);
su = std(RGaAs_p_u);

mo = mean(RGaAs_p_o);
so = std(RGaAs_p_o);
%}
%%

Ro = RGaAs_p_o(RGaAs_p_o<5 & RGaAs_p_o>0);

Ru = RGaAs_p_u(RGaAs_p_u<5 & RGaAs_p_u>0);

Ruo = bsxfun(@rdivide,qGa_p_u,qAs_p_o');
Ruo = Ruo(:);
Ruo = Ruo(Ruo<5 & Ruo>0);

Rou = bsxfun(@rdivide,qGa_p_o,qAs_p_u');
Rou = Rou(:);
Rou = Rou(Rou<5 & Rou>0);


hold on
%o = histfit(RGaAs_p_o.*(1:-1/330:1/330),10);
%u = histfit(RGaAs_p_u.*(1:-1/100:1/100),10);
%{
o = histfit(Ro,10);

u = histfit(Ru,10);
%plot(-1.5:0.01:1.5,normpdf(-1.5:0.01:1.5,mu,su))
%plot(-1.5:0.01:1.5,normpdf(-1.5:0.01:1.5,mo,so))
o(2).Color = [.2 .2 .2];
o(1).FaceColor = [.8 .8 1];
%}

%As_opti = (As_under+As_over)./2;
%As_opti = bsxfun(@plus,As_under(:,

k = 1;
As_opti = zeros(1024,size(As_under,2)*size(As_over,2));
for ii = 1:size(As_under,2),
    for jj = 1:size(As_over,2),
        As_opti(:,k) = bsxfun(@plus,As_under(:,ii),As_over(:,jj))./2;
        k = k +1;
    end
end

qAs_p_opti = sum(As_opti(473:673,:))./Sigmal3(33,673-473,198,15);

%Ga_opti = (Ga_under+Ga_over)./2;
k = 1;
Ga_opti = zeros(1024,size(Ga_under,2)*size(Ga_over,2));
for ii = 1:size(Ga_under,2),
    for jj = 1:size(Ga_over,2),
        Ga_opti(:,k) = bsxfun(@plus,Ga_under(:,ii),Ga_over(:,jj))./2;
        k = k +1;
    end
end
qGa_p_opti = sum(Ga_opti(265:465,:))./Sigmal3(31,465-265,198,15);

%{
Ropti = bsxfun(@rdivide,qGa_p_opti,qAs_p_opti');
Ropti = Ropti(:);
Ropti = Ropti(Ropti<5 & Ropti>0);


Ruopti = bsxfun(@rdivide,qGa_p_u,qAs_p_opti');
Ruopti = Ruopti(:);
Ruopti = Ruopti(Ruopti<5 & Ruopti>0);

Roptiu = bsxfun(@rdivide,qGa_p_opti,qAs_p_u');
Roptiu = Roptiu(:);
Roptiu = Roptiu(Roptiu<5 & Roptiu>0);

Roopti = bsxfun(@rdivide,qGa_p_o,qAs_p_opti');
Roopti = Roopti(:);
Roopti = Roopti(Roopti<5 & Roopti>0);

Roptio = bsxfun(@rdivide,qGa_p_opti,qAs_p_o');
Roptio = Roptio(:);
Roptio = Roptio(Roptio<5 & Roptio>0);
%}


Ropti = qGa_p_opti./qAs_p_opti;
%%
hold on
plot(0:0.01:5,normpdf(0:0.01:5,mean(Ro),std(Ro)))
plot(0:0.01:5,normpdf(0:0.01:5,mean(Ru),std(Ru)))
plot(0:0.01:5,normpdf(0:0.01:5,mean(Rou),std(Rou)))
plot(0:0.01:5,normpdf(0:0.01:5,mean(Ruo),std(Ruo)))
plot(0:0.01:5,normpdf(0:0.01:5,mean(Ropti),std(Ropti)))
grid on
grid minor
legend boxoff
hold on
ho = histogram(Ro,'Normalization','pdf');
hu = histogram(Ru,'Normalization','pdf');
hou = histogram(Rou,'Normalization','pdf');
huo = histogram(Ruo,'Normalization','pdf');
hopti = histogram(Ropti,'Normalization','pdf');