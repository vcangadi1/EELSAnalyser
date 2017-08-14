function d = distance_point_curve(x1,y1,energy_loss_axis,Curve)

%x1 = 1323;
%y1 = S(eV2ch(l,1323));

for ii = 1024:-1:1
    x2 = energy_loss_axis(ii);
    y2 = Curve(ii);
    d(ii) = sqrt((x1-x2).^2 + (y1-y2).^2);
end
