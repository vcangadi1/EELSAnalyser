
% Fit inverse power law to pre edge region for Ga-L3 edge (1115eV)
[f_main, gof_main, opt_main] = Power_law(l(1:265),S(1:265));
y_main = feval(f_main,l);

Ga = squeeze(S(265:476)-y_main(265:476));
for i=length(Ga):-1:1,
    Ga_1(i) = squeeze(sum(Ga(1:i)));
end

% Fit an inverse power law in tail of Ga-L3 edge and shift to pass through
% edge onset
[f_later, gof_later, opt_later] = Power_law(l(373:476),S(373:476));
y_later = feval(f_later,l);

Ga = squeeze(S(265:476)-(y_later(265:476)-y_later(265)+S(265)));
for i=length(Ga):-1:1,
    Ga_2(i) = squeeze(sum(Ga(1:i)));
end

hold on
errorbar(l(265:50:476),y_main(265:50:476),3*sqrt(Ga_1(1:50:end)),'LineWidth',1.5)
errorbar(l(265:50:476),y_later(265:50:476)-y_later(265)+S(265),3*sqrt(Ga_2(1:50:end)),'LineWidth',1.5)
plot(l,S)
plot(l,y_main)
plot(l,y_later-y_later(265)+S(265))
xlabel('Energy-loss axis (eV)')
ylabel('Counts')
title('errorbar = \pm3*sqrt[I(\Delta)]');
set(gca,'FontWeight','bold');
legend('pre-edge inv-PL (Under estimate)','tail inv-PL & shift (Over estimate)','spectrun');
grid on
box on