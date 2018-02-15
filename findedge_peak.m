function eels_edges = findedge_peak(S, l, w)

if nargin < 3
    w = 25;
end

f = Power_law(l(1:100),S(1:100));
a = f.a;
r = -f.b;

S = exp(medfilt1(log(abs(S)),10,'truncate'));
S = exp(medfilt1(log(abs(S)),10,'truncate'));

SS = hankel(atan(gradient(S)./(a*l.^(-r))));
%SS = hankel(atan(gradient(S)*180/pi));
SS = SS(1:w,:);

Sm = nanmean(SS);
%Ss = nanstd(SS);

eels_edges = Sm;