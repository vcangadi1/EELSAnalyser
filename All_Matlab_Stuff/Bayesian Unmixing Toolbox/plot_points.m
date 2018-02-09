function plot_points
%-------------------------------------------------------------------------%
% Pixels selected as sources are marked on the image.

% Remark : length(x_pixel) = length(y_pixel)
%-------------------------------------------------------------------------%
global x_pixel y_pixel
%-------------------------------------------------------------------------%

if ~isempty(x_pixel)
    for k = 1:length(x_pixel)
        %rectangle('Position',[x_pixel(k)-0.5,y_pixel(k)-0.5,1,1], 'EdgeColor', [1, 0, 0]); %affichage d'un rectangle à l'endroit du pixel
                            %sélectionné
        hold on;
        plot(x_pixel(k),y_pixel(k), 'red', 'Marker', '*');
        %plot('+','position',[x_pixel(k),y_pixel(k),1,1], 'Color', [1, 0, 0]);
    end
end
end

