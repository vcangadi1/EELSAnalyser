% I/(tl*sigma*t)
%figure(1)
%plot(S)
S = [S1_80,S2_80,S3_80,S4_80,S5_80,S6_80,S7_80,S8_80];
I = zeros(8,3);
sse = I;
rsquare = sse;
rmse = sse;
for i = 1:8,
    
figure;
title(str2double(i))
[f1,gof1] = Power_law(EELS.energy_loss_axis(210:290)',S(210:290,i));
%[f1,gof1] = Exponential_fit(EELS.energy_loss_axis(210:290)',S(210:290,i));
ISiL3 = (sum(S(300:450,i)-f1(EELS.energy_loss_axis(300:450)))*EELS.dispersion)/(Sigmal3(14,15,198,15)*0.5);
subplot 131
plot(f1,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('Si-L3');
title(['Region ', num2str(i)]);

[f2,gof2] = Power_law(EELS.energy_loss_axis(400:478)',S(400:478,i));
%[f2,gof2] = Exponential_fit(EELS.energy_loss_axis(400:478)',S(400:478,i));
IAlL1 = (sum(S(480:630,i)-f2(EELS.energy_loss_axis(480:630)))*EELS.dispersion)/(Sigmal3(13,15,198,15)*0.5);
subplot 132
plot(f2,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('Al-L1');
title(['Region ', num2str(i)]);

[f3,gof3] = Power_law(EELS.energy_loss_axis(580:626)',S(580:626,i));
%[f3,gof3] = Exponential_fit(EELS.energy_loss_axis(580:626)',S(580:626,i));
%IPL3 = sum(S(650:end,i)-f3(EELS.energy_loss_axis(650:end)))/(14119.86*0.5);
IPL3 = (sum(S(650:end,i)-f3(EELS.energy_loss_axis(650:end)))*EELS.dispersion)/(Sigmal3(15,37.4,198,15)*0.5);
subplot 133
plot(f3,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('P-L3');
title(['Region ', num2str(i)]);

I(i,:) = [ISiL3 IAlL1 IPL3];
sse(i,:) = [gof1.sse gof2.sse gof3.sse];
rsquare(i,:) = [gof1.rsquare gof2.rsquare gof3.rsquare ];
rmse(i,:) = [gof1.rmse gof2.rmse gof3.rmse ];
end