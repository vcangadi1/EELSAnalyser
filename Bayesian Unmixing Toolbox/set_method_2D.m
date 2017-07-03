function set_method_2D(obj,event)

global geo_method handles sources

% valeur de geo_method
geo_method=get(handles(13),'value');

switch geo_method
    case 1
        geo_method='nfindr';
    case 2
        geo_method='vca';
    case 3
        geo_method='from file';

end
