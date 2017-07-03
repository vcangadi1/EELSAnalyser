function varargout = plt_EELS(varargin)
% PLOT_EELS MATLAB code for plt_EELS.fig
%
%   PLOT_EELS, by itself, creates a new PLOT_EELS or raises the existing
%   singleton*.
%   H = PLOT_EELS returns the handle to a new PLOT_EELS or the handle to
%   the existing singleton*.
%
%   PLOT_EELS('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in PLOT_EELS.M with the given input arguments.
%
%   PLOT_EELS('Property','Value',...) creates a new PLOT_EELS or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before plot_EELS_OpeningFcn gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to plot_EELS_OpeningFcn via varargin.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plot_EELS

% Last Modified by GUIDE v2.5 24-Sep-2015 14:36:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plot_EELS_OpeningFcn, ...
                   'gui_OutputFcn',  @plot_EELS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before plot_EELS is made visible.
function plot_EELS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_EELS (see VARARGIN)

% Enter the input to handles.EELS
if(length(varargin)<1)
    handles.EELS = readEELSdata;
else
    handles.EELS = varargin{1};
end

handles.r = 1;
handles.c = 1;

% Plot the spectrum image
axes(handles.axes1)
I = sum(handles.EELS.SImage,3);
handles.I = imshow(uint64(I),[min(I(:)) max(I(:))]);
if((handles.EELS.SI_y*handles.EELS.step_size.y > 1000) && strcmp(handles.EELS.step_size.yunit,'nm'))
    xlabel(['Columns (',num2str(sprintf('%.2f',(handles.EELS.SI_y*handles.EELS.step_size.y)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    xlabel(['Columns (',num2str(sprintf('%.2f',handles.EELS.SI_y*handles.EELS.step_size.y)),handles.EELS.step_size.yunit,')'],'FontWeight','bold','FontSize',10);
end
if((handles.EELS.SI_x*handles.EELS.step_size.x > 1000) && strcmp(handles.EELS.step_size.xunit,'nm'))
    ylabel(['Rows (',num2str(sprintf('%.2f',(handles.EELS.SI_x*handles.EELS.step_size.x)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    ylabel(['Rows (',num2str(sprintf('%.2f',handles.EELS.SI_x*handles.EELS.step_size.x)),handles.EELS.step_size.xunit,')'],'FontWeight','bold','FontSize',10);
end
title(['Size = ',num2str(handles.EELS.SI_x),' x ',num2str(handles.EELS.SI_y),' pixel'],'FontWeight','bold','FontSize',10);
axis equal tight

% Set a callback function for Click
set(handles.I,'ButtonDownFcn',@ImageClickCallback);

% Draw a rectagle box
handles.R = rectangle('Position',[handles.c-0.5,handles.r-0.5,1,1],...
          'LineWidth',2,...
          'EdgeColor','r');

% Set static text boxes
set(handles.text1,'String',['Step size = ',num2str(sprintf('%.2f',handles.EELS.step_size.x)),handles.EELS.step_size.xunit]);
set(handles.text2,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);
set(handles.text3,'String',['Magnification = ',num2str(handles.EELS.mag)]);

% Plot the EELS spectrum
axes(handles.axes2)
handles.P = plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.r,handles.c,:)),'LineWidth',1);
xlabel('Energy-loss (eV) ','FontWeight','bold','FontSize',10);
ylabel('Count ','FontWeight','bold','FontSize',10);
title(['Pixel = (',num2str(handles.r),',',num2str(handles.c),')'],'FontWeight','bold','FontSize',10);
grid on


% Choose default command line output for plot_EELS
handles.output = hObject;

% Set a callback function for Click
set(handles.output,'KeyPressFcn',@KeyPressCallback);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plot_EELS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function ImageClickCallback(hObject, eventdata, handles)
% hObject    handle to axes_SImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Read the handles data
handles = guidata(hObject);

% Read the axis data of the click
axesHandle  = get(hObject,'Parent');
coordinates = fliplr(get(axesHandle,'CurrentPoint'));
handles.r = squeeze(round(coordinates(1,2)));
handles.c = squeeze(round(coordinates(1,3)));

% Limit the click axis
if(handles.r > handles.EELS.SI_x)
    handles.r = handles.EELS.SI_x;
elseif(handles.r < 1)
    handles.r = 1;
end
if(handles.c > handles.EELS.SI_y)
    handles.c = handles.EELS.SI_y;
elseif(handles.c < 1)
    handles.c = 1;
end

% Plot the spectrum image
axes(handles.axes1);
I = sum(handles.EELS.SImage,3);
handles.I = imshow(uint64(I),[min(I(:)) max(I(:))]);
if((handles.EELS.SI_y*handles.EELS.step_size.y > 1000) && strcmp(handles.EELS.step_size.yunit,'nm'))
    xlabel(['Columns (',num2str(sprintf('%.2f',(handles.EELS.SI_y*handles.EELS.step_size.y)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    xlabel(['Columns (',num2str(sprintf('%.2f',handles.EELS.SI_y*handles.EELS.step_size.y)),handles.EELS.step_size.yunit,')'],'FontWeight','bold','FontSize',10);
end
if((handles.EELS.SI_x*handles.EELS.step_size.x > 1000) && strcmp(handles.EELS.step_size.xunit,'nm'))
    ylabel(['Rows (',num2str(sprintf('%.2f',(handles.EELS.SI_x*handles.EELS.step_size.x)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    ylabel(['Rows (',num2str(sprintf('%.2f',handles.EELS.SI_x*handles.EELS.step_size.x)),handles.EELS.step_size.xunit,')'],'FontWeight','bold','FontSize',10);
end
title(['Size = ',num2str(handles.EELS.SI_x),' x ',num2str(handles.EELS.SI_y),' pixel'],'FontWeight','bold','FontSize',10);
axis equal tight


% Draw a rectagle box
handles.R = rectangle('Position',[handles.c-0.5,handles.r-0.5,1,1],...
          'LineWidth',2,...
          'EdgeColor','r');

% Set static text boxes
set(handles.text1,'String',['Step size = ',num2str(sprintf('%.2f',handles.EELS.step_size.x)),handles.EELS.step_size.xunit]);
set(handles.text2,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);
set(handles.text3,'String',['Magnification = ',num2str(handles.EELS.mag)]);

% Plot the EELS spectrum
axes(handles.axes2)
handles.P = plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.r,handles.c,:)),'LineWidth',1);
xlabel('Energy-loss (eV) ','FontWeight','bold','FontSize',10);
ylabel('Count ','FontWeight','bold','FontSize',10);
title(['Pixel = (',num2str(handles.r),',',num2str(handles.c),')'],'FontWeight','bold','FontSize',10);
grid on
% Set a callback function for Click
set(handles.output,'KeyPressFcn',@KeyPressCallback);
% Set a callback function for Click
set(handles.I,'ButtonDownFcn',@ImageClickCallback);

% Update handles structure
guidata(handles.figure1,handles); 


function KeyPressCallback(hObject, eventdata, handles)

% Read the handles data
handles = guidata(hObject);

% Check which key is pressed and update row and column values
switch get(handles.output,'CurrentKey')
    case 'uparrow'
        handles.r = handles.r - 1;        
    case 'downarrow'
        handles.r = handles.r + 1;
    case 'leftarrow'
        handles.c = handles.c - 1;
    case 'rightarrow'
        handles.c = handles.c + 1;
    otherwise
        warning('Unexpected key pressed. Use only arrow keys');
end

% Limit the click axis
if(handles.r > handles.EELS.SI_x)
    handles.r = handles.EELS.SI_x;
elseif(handles.r < 1)
    handles.r = 1;
end
if(handles.c > handles.EELS.SI_y)
    handles.c = handles.EELS.SI_y;
elseif(handles.c < 1)
    handles.c = 1;
end

% Plot the spectrum image
axes(handles.axes1);
I = sum(handles.EELS.SImage,3);
handles.I = imshow(uint64(I),[min(I(:)) max(I(:))]);
if((handles.EELS.SI_y*handles.EELS.step_size.y > 1000) && strcmp(handles.EELS.step_size.yunit,'nm'))
    xlabel(['Columns (',num2str(sprintf('%.2f',(handles.EELS.SI_y*handles.EELS.step_size.y)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    xlabel(['Columns (',num2str(sprintf('%.2f',handles.EELS.SI_y*handles.EELS.step_size.y)),handles.EELS.step_size.yunit,')'],'FontWeight','bold','FontSize',10);
end
if((handles.EELS.SI_x*handles.EELS.step_size.x > 1000) && strcmp(handles.EELS.step_size.xunit,'nm'))
    ylabel(['Rows (',num2str(sprintf('%.2f',(handles.EELS.SI_x*handles.EELS.step_size.x)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    ylabel(['Rows (',num2str(sprintf('%.2f',handles.EELS.SI_x*handles.EELS.step_size.x)),handles.EELS.step_size.xunit,')'],'FontWeight','bold','FontSize',10);
end
title(['Size = ',num2str(handles.EELS.SI_x),' x ',num2str(handles.EELS.SI_y),' pixel'],'FontWeight','bold','FontSize',10);
axis equal tight

% Draw a rectagle box
handles.R = rectangle('Position',[handles.c-0.5,handles.r-0.5,1,1],...
          'LineWidth',2,...
          'EdgeColor','r');

% Set static text boxes
set(handles.text1,'String',['Step size = ',num2str(sprintf('%.2f',handles.EELS.step_size.x)),handles.EELS.step_size.xunit]);
set(handles.text2,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);
set(handles.text3,'String',['Magnification = ',num2str(handles.EELS.mag)]);

% Plot the EELS spectrum
axes(handles.axes2)
handles.P = plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.r,handles.c,:)),'LineWidth',1);
xlabel('Energy-loss (eV) ','FontWeight','bold','FontSize',10);
ylabel('Count ','FontWeight','bold','FontSize',10);
title(['Pixel = (',num2str(handles.r),',',num2str(handles.c),')'],'FontWeight','bold','FontSize',10);
grid on

% Set a callback function for Click
set(handles.output,'KeyPressFcn',@KeyPressCallback);
% Set a callback function for Click
set(handles.I,'ButtonDownFcn',@ImageClickCallback);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = plot_EELS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
