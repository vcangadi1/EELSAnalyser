function set_plot_2D(obj,event)

global plot_state booleen handles test

% valeur de geo_method
test=get(handles(27),'value');

switch test
    case 1
        plot_state='plot on';
        booleen=1;
    case 2
        plot_state='plot off';
        booleen=0;
end

% Actualisation de la propriété String de l'objet Uicontrol Text method
%set(handles(8),'string',num2str(plot_state));