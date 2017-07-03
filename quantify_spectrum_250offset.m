
%figure(1)
%plot(S)
%S = [S1_250,S2_250,S3_250,S4_250,S5_250,S6_250,S7_250,S8_250];
I = zeros(8,3);
sse = I;
rsquare = sse;
rmse = sse;
for i = 1:8,
    
figure;
title(str2double(i))
[f1,gof1] = Power_law(EELS.energy_loss_axis(112:160)',S(112:160,i));
%[f1,gof1] = Exponential_fit(EELS.energy_loss_axis(112:160)',S(112:160,i));
ICK = (sum(S(168:268,i)-f1(EELS.energy_loss_axis(168:268)))*EELS.dispersion)/(Sigmak3(6,284,50,198,15)*0.5);
subplot 131
plot(f1,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('C-K');
title(['Region ', num2str(i)]);

[f2,gof2] = Power_law(EELS.energy_loss_axis(410:484)',S(410:484,i));
%[f2,gof2] = Exponential_fit(EELS.energy_loss_axis(410:484)',S(410:484,i));
IInM45 = (sum(S(486:664,i)-f2(EELS.energy_loss_axis(486:664)))*EELS.dispersion)/((Sigpar(49,89,'M45',198,15)/10^-24)*0.5);
subplot 132
plot(f2,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('In-M45');
title(['Region ', num2str(i)]);

[f3,gof3] = Power_law(EELS.energy_loss_axis(574:652)',S(574:652,i));
%[f3,gof3] = Exponential_fit(EELS.energy_loss_axis(574:652)',S(574:652,i));
IOK = (sum(S(664:764,i)-f3(EELS.energy_loss_axis(664:764)))*EELS.dispersion)/(Sigmak3(8,532,50,198,15)*0.5);
subplot 133
plot(f3,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('O-K');
title(['Region ', num2str(i)]);

I(i,:) = [ICK IInM45 IOK];
sse(i,:) = [gof1.sse gof2.sse gof3.sse];
rsquare(i,:) = [gof1.rsquare gof2.rsquare gof3.rsquare ];
rmse(i,:) = [gof1.rmse gof2.rmse gof3.rmse ];
end
close all