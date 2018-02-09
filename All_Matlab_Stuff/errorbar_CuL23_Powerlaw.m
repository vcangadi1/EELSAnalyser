
close all
% Main background fit with errorbars
[f_main, gof_main, opt_main] = Power_law(l(36:71),S(36:71));
y_main = feval(f_main,l);

Cu = squeeze(S(71:end)-y_main(71:end));
for i=length(Cu):-1:1,
    Cu_1(i) = squeeze(sum(Cu(1:i)));
end

% Corrected background fit with errorbars
[f_cor, gof_cor] = fit([l(1),l(end)]',[0,abs(y_main(end)-S(end))]','poly1');
y_cor = feval(f_cor,l);

Cu = squeeze(S(71:end)-y_main(71:end)+y_cor(71:end));
for i=length(Cu):-1:1,
    Cu_2(i) = squeeze(sum(Cu(1:i)));
end

% Fit inverse power law at edge tail and shift it down to pass through edge
% onset.
[f_later, gof_later, opt_later] = Power_law(l(295:end),S(295:end));
y_later = feval(f_later,l);
y_later_shift = y_later-(y_later(71)-S(71));
Cu = squeeze(S(71:end)-y_later_shift(71:end));
for i=length(Cu):-1:1,
    Cu_3(i) = squeeze(sum(Cu(1:i)));
end

% Fit inverse power law at edge tail and shift it down to pass through edge
% onset. If it crosses the spectrum then use linear function to move it up
% or down.
[f_cor_later, gof_cor_later] = fit([l(1),l(end)]',[0,(S(end)-y_later_shift(end))]','poly1');
y_cor_later = feval(f_cor_later,l);

Cu = squeeze(S(71:end)-(y_later_shift(71:end)+y_cor_later(71:end)));
for i=length(Cu):-1:1,
    Cu_4(i) = squeeze(sum(Cu(1:i)));
end

hold on
errorbar(l(71:50:end),y_main(71:50:end),3*sqrt(Cu_1(1:50:end)),'LineWidth',1.5)
errorbar(l(71:50:end),y_main(71:50:end)-y_cor(71:50:end),3*sqrt(Cu_2(1:50:end)),'LineWidth',1.5)
errorbar(l(71:50:end),y_later(71:50:end)-(y_later(71)-S(71)),3*sqrt(Cu_3(1:50:end)),'LineWidth',1.5)
errorbar(l(71:50:end),y_later_shift(71:50:end)+y_cor_later(71:50:end),3*sqrt(Cu_4(1:50:end)),'LineWidth',1.5)
plot(l,S)
plot(l,y_main)
plot(l,y_main-y_cor)
%plot(l,S-(y_main-y_cor))
plot(l,y_later-(y_later(71)-S(71)))
plot(l,y_later_shift+y_cor_later)
xlabel('Energy-loss axis (eV)')
ylabel('Counts')
title('errorbar = \pm3*sqrt[I(\Delta)]');
set(gca,'FontWeight','bold');
legend('pre-edge inv-PL fit (crosses spectrum)(Under estimate)',...
    'pre-edge inv-PL fit (not crossing spectrum)',...
    'tail exp inv-PL & shift to onset (crosses zero axis)',...
    'tail inv-PL fit & shift to onset (not crossing zero axis)(Over estimate)',...
    'spectrum');
grid on
box on