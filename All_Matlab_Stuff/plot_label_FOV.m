function plot_label_FOV(axes_handle,FOV,FOV_units,rows,columns)
%%
%   Input : 
%           axes_handle = Axes handle of the image
%           FOV         = Field of view
%           FOV_units   = Units of field of view 
%                         eg: 'milli' -- Millimeter,
%                             'micro' -- Micrometer,
%                             'nano'  -- Nanometer,
%                             'ang'   -- Angstrom,
%                             'pico'  -- Picometer
%           rows        = Number of rows
%           columns     = Number of columns

%% FOV units to LaTeX interpreter

switch(FOV_units)
    case {'milli','Milli'}
        units = 'mm';
    case {'micro','$\mu$m','\mu','\mum','\Micro','µm','µ'}
        units = '$\mu$m';
    case 'nano'
        units = 'nn';
    case {'ang','Ang'}
        units = '$\AA$';
    case {'pico','Pico'}
        units = 'pm';
    otherwise
        units = FOV_units;
end

%% Calucate the width of calibration bar

ref = [1:5:10 50 100 200 500 1000];
[~,ind] = min(abs(ref./FOV-0.25));

if ref(ind)/FOV > 0.45 || ref(ind)/FOV < 0.2
    ref = [0.1:0.1:1 2:10 15:5:100 110:10:200 250:50:1000];
    [~,ind] = min(abs(ref./FOV-0.25));
end


%% Insert bar

x = (0.05*columns);
y = (0.95*rows);
%w = (0.25*columns);
w = (ref(ind)/FOV)*columns;
h = (0.02*rows);

pos = [x, y, w, h];
rectangle(axes_handle,'Position',pos,'FaceColor','w','EdgeColor','white');

%% Insert text

x = x + w/2;
%y = y - h - 0.01*rows; 
y = y - h - 0.01*columns;
%str = [num2str(sprintf('%.2f',w*FOV/columns)),units];
if ref(ind) < 1
    str = [num2str(sprintf('%.1f',ref(ind))),units];
else
    str = [num2str(ref(ind)),units];
end

text(axes_handle,x,y,str,'Color','white',...
    'FontWeight','bold','FontName','helvetica',...
    'HorizontalAlignment','center','Interpreter','latex',...
    'FontUnits','normalized','FontSize',(0.07/rows)*columns);
