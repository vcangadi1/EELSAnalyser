
figure(1)
plot(S)

f1 = Power_law(EELS.energy_loss_axis(158:298),S(158:298));
IC = sum(S(300:450)-f1(EELS.energy_loss_axis(300:450)))/19400;

f2 = Power_law(EELS.energy_loss_axis(498:648),S(498:648));
IIn = sum(S(650:end)-f1(EELS.energy_loss_axis(650:end)))/28200;

f3 = Power_law(EELS.energy_loss_axis(498:648),S(498:648));
IO = sum(S(650:end)-f1(EELS.energy_loss_axis(650:end)))/28200;
