clc
close all;

d = round(energy_loss_axis(2)-energy_loss_axis(1),2);

new_l = energy_loss_referenced*d/(energy_loss_referenced(2)-energy_loss_referenced(1));

el = energy_loss_axis*d/(energy_loss_axis(2)-energy_loss_axis(1));

el = round(el,2);
%% Generate Plasmon peaks
In = (1/290:1/290:1)';
Ep = 19.39-4.02*In;
FWHM = 6.22062+4.73727*In-5.09438*In.^2;
A = 21110.50558;

Sp = zeros(length(el),length(In));

for i=1:length(In),
    Sp(:,i) = (2*A/pi)*(FWHM(i)./(4*(el-Ep(i)).^2+FWHM(i).^2));
end

figure;
plot(el,Sp)
title('Lorentz function- Simulated plasmon peaks');

%% Generate InGaN core-loss
InGaN = zeros(length(GaN_referenced),length(In));

for i=1:length(In),
InGaN(:,i) = (1-In(i)).*GaN_referenced+In(i).*InN_referenced;
end
tbyl = 0.60762;
InGaN = InGaN*tbyl*1.35668E6;

figure;
plot(new_l,InGaN)

%new_energy_loss = el-el(1)+Ep(1);
%{
for i = 1:length(Ep),
    new_energy_loss(i) = new_l+ Ep(i)-new_l(1);
end
%}

%% Arrange energy_loss axis
new_Ep = round(Ep.*20)./20;
x = 13.05:0.05:30.05;
for i = 1:length(new_Ep),
    ind_Ep(i) = find(el==new_Ep(i))';
end
ind_Ep = ind_Ep';
for i = 1:length(new_Ep),
    temp_InGaN = [zeros(ind_Ep(i),1);InGaN(:,i);zeros(1000,1)];
    new_InGaN(:,i) = temp_InGaN(1:length(x));
end

plot(x,new_InGaN)

%f = @(a,ii,jj) a(1)*Sp(:,1)+ a(2)*Sp(:,end) +a(3)*Sp(:,ii) +a(4)*new_InGaN(:,1) +a(5)*new_InGaN(:,end) +a(6)*new_InGaN(:,jj);

%f_error = @(a) sum((S - (a(1)*Sp(:,1)+ a(2)*Sp(:,end) +a(3)*Sp(:,a(4)) +a(5)*new_InGaN(:,1) +a(6)*new_InGaN(:,end) +a(7)*new_InGaN(:,a(8)))).^2);

%a0 = ones(1,8)*100;

%a = fminsearch(f_error,a0);
pGaN = Sp(:,1);
pInN = Sp(:,end);
pInGaN = Sp(:,90);
cGaN = new_InGaN(:,1);
cInN = new_InGaN(:,end);
cInGaN = new_InGaN(:,90);
X = [pInN pInGaN pGaN cInN cInGaN cGaN];

y = S;

b = regress(y,X);
%%
figure;
plotEELS(x,X*b)
hold on
plotEELS(x,S)
%%
fprintf('cInGaN = %6.2f\n',sum(cInGaN)*b(5));
fprintf('cGaN = %6.2f\n',sum(cGaN)*b(end));
fprintf('cInN = %6.2f\n',sum(cInN)*b(4));
tsum = sum(cInN)*b(4)+sum(cGaN)*b(end)+sum(cInGaN)*b(5);
fprintf('Weighting cInGaN = %6.2f\n',(sum(cInGaN)*b(5))/tsum);
fprintf('Weighting cGaN = %6.2f\n',(sum(cGaN)*b(end))/tsum);
fprintf('Weighting cInN = %6.2f\n',(sum(cInN)*b(4))/tsum);




