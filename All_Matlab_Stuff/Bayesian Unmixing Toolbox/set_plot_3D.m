function set_plot_3D(obj,event)

global plot_state bool_plot handles test %est-il nécessaire d'avoir test en variable globale ??

% valeur de geo_method
test=get(handles(35),'value');

switch test
    case 1
        plot_state='plot on';
        bool_plot=1;
    case 2
        plot_state='plot off';
        bool_plot=0;
end
