
%figure(1)
%plot(S)
%S = [S1_950,S2_950,S3_950,S4_950,S5_950,S6_950,S7_950,S8_950];
I = zeros(8,4);
sse = I;
rsquare = sse;
rmse = sse;
for i = 1:8,

figure;
title(str2double(i))
[f1,gof1] = Power_law(EELS.energy_loss_axis(16:73)',S(16:73,i));
%[f1,gof1] = Exponential_fit(EELS.energy_loss_axis(16:73)',S(16:73,i));
ICuL3 = (sum(S(81:281,i)-f1(EELS.energy_loss_axis(81:281)))*EELS.dispersion)/(Sigmal3(29,200,198,15)*2);
subplot 141
plot(f1,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('Cu-L3');
title(['Region ', num2str(i)]);

[f2,gof2] = Power_law(EELS.energy_loss_axis(150:260)',S(150:260,i));
%[f2,gof2] = Exponential_fit(EELS.energy_loss_axis(150:260)',S(150:260,i));
IGaL3 = (sum(S(265:465,i)-f2(EELS.energy_loss_axis(265:465)))*EELS.dispersion)/(Sigmal3(31,200,198,15)*2);
subplot 142
plot(f2,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('Ga-L3');
title(['Region ', num2str(i)]);

[f3,gof3] = Power_law(EELS.energy_loss_axis(393:463)',S(393:463,i));
%[f3,gof3] = Exponential_fit(EELS.energy_loss_axis(393:463)',S(393:463,i));
IAsL3 = (sum(S(473:673,i)-f3(EELS.energy_loss_axis(473:673)))*EELS.dispersion)/(Sigmal3(33,200,198,15)*2);
subplot 143
plot(f3,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('As-L3');
title(['Region ', num2str(i)]);

[f4,gof4] = Power_law(EELS.energy_loss_axis(550:700)',S(550:700,i));
%[f4,gof4] = Exponential_fit(EELS.energy_loss_axis(550:700)',S(550:700,i));
IAlK = (sum(S(710:810,i)-f4(EELS.energy_loss_axis(710:810)))*EELS.dispersion)/(Sigmak3(13,1560,100,198,15)*2);
subplot 144
plot(f4,EELS.energy_loss_axis,S(:,i))
xlabel('eV');
ylabel('Al-K');
title(['Region ', num2str(i)]);

I(i,:) = [ICuL3 IGaL3 IAsL3 IAlK];
sse(i,:) = [gof1.sse gof2.sse gof3.sse gof4.sse];
rsquare(i,:) = [gof1.rsquare gof2.rsquare gof3.rsquare gof4.rsquare];
rmse(i,:) = [gof1.rmse gof2.rmse gof3.rmse gof4.rmse];
end
close all
