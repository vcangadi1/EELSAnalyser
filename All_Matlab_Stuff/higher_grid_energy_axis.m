function E = higher_grid_energy_axis(energy_loss_axis,start_pixel,end_pixel)


if isrow(energy_loss_axis)
    l = energy_loss_axis';
else
    l = energy_loss_axis;
end

if start_pixel > end_pixel
    error('start_pixel must be smaller than end_pixel');
end

%% extrapolate
x = (1:length(l))';
y = l;

E = feval(fit(x,y,'poly1'),(start_pixel+1:end_pixel)');
