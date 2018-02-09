function plotIntervals(s, f, id, t)
% Copyright 2013 The MathWorks, Inc.
N = numel(s);
k = iFindIntervals(s, id, N);

sn = (s-t) * 24 *3600;
fn = (f-t) * 24 *3600;
mn = (sn + fn)/2;
clf
axis([0 max(fn)*1.1, 0 max(id) + 1]);
colormap cool
colorbar
hold('on')
W = 0.18;
for i = 1:numel(k) - 1
    range = k(i)+1:k(i+1);
    minR = min(range);
    maxR = max(range);
    minX = min(sn(range));
    maxX = max(fn(range));
    Y = min(id(range));
    patch([minX minX maxX maxX], [Y-W Y+W Y+W Y-W], [minR minR maxR maxR]);
    plot(mn(range), id(range), '.');
    text( minX, Y+2.5*W, sprintf('%d + %d', minR, maxR-minR) );
end
set(gca, 'YTick', 1:max(id));
ylabel('Worker Number');
xlabel('Time/s');
title(sprintf('Mean work time: %d ms', ceil(mean(f-s)*24*3600*1000)));
figure(gcf)

function k = iFindIntervals(a, b, N)
N = 1:N;
ub = unique(b);
k = [];
for i = 1:numel(ub)
    ta = a(b == ub(i));
    tN = N(b == ub(i));
    k = [k tN(1)-1 tN(diff(ta) > 0) tN(end)]; %#ok<AGROW>
end
k = unique(k);

