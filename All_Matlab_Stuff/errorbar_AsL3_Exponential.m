
% Fit an inverse power law in the pre-edge region of As-L3 edge (1326eV)
[f_main, gof_main, opt_main] = Exponential_fit(l(373:476),S(373:476));
y_main = feval(f_main,l);

As = squeeze(S(476:end)-y_main(476:end));
for i=length(As):-1:1,
    As_1(i) = squeeze(sum(As(1:i)));
end

% Fit an inverse power law in tail of As-L3 edge and shift to pass through
% edge onset
[f_later, gof_later, opt_later] = Exponential_fit(l(655:end),S(655:end));
y_later = feval(f_later,l);

As = squeeze(S(476:end)-(y_later(476:end)-y_later(476)+S(476)));
for i=length(As):-1:1,
    As_2(i) = squeeze(sum(As(1:i)));
end

hold on
errorbar(l(476:50:end),y_main(476:50:end),3*sqrt(As_1(1:50:end)),'LineWidth',1.5)
errorbar(l(476:50:end),y_later(476:50:end)-y_later(476)+S(476),3*sqrt(As_2(1:50:end)),'LineWidth',1.5)
plot(l,S)
plot(l,y_main)
plot(l,y_later-y_later(476)+S(476))
xlabel('Energy-loss axis (eV)')
ylabel('Counts')
title('errorbar = \pm3*sqrt[I(\Delta)]');
set(gca,'FontWeight','bold');
legend('pre-edge exp fit (Under estimate)','tail exp fit & shift (Over estimate)','spectrun');
grid on
box on