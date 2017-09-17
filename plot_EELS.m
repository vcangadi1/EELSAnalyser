function varargout = plot_EELS(varargin)
%%
% PLT_EELS MATLAB code for plot_EELS.fig
%
%   PLT_EELS, by itself, creates a new PLT_EELS or raises the existing
%   singleton*.
%   H = PLT_EELS returns the handle to a new PLT_EELS or the handle to
%   the existing singleton*.
%
%   PLT_EELS('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in PLT_EELS.M with the given input arguments.
%
%   PLT_EELS('Property','Value',...) creates a new PLT_EELS or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before plt_EELS_OpeningFcn gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to plt_EELS_OpeningFcn via varargin.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plt_EELS

% Last Modified by GUIDE v2.5 16-Nov-2015 15:48:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plt_EELS_OpeningFcn, ...
                   'gui_OutputFcn',  @plt_EELS_OutputFcn, ...
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


%% --- Executes just before plt_EELS is made visible.
function plt_EELS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plt_EELS (see VARARGIN)

cla;

% Enter the input to handles.EELS
if(length(varargin)<1)
    handles.EELS = readEELSdata;
else
    handles.EELS = varargin{1};
end

handles.r = 1;
handles.c = 1;

% Plot the spectrum image & spectrum
handles = plt(handles); % Call plt_axes1 function

% Choose default command line output for plt_EELS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plt_EELS wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
function ImageClickCallback(hObject, eventdata, handles)
% hObject    handle to axes_SImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Read the handles data
handles = guidata(hObject);

% Read the axis data of the click
axesHandle  = get(hObject,'Parent');
coordinates = axesHandle.CurrentPoint;
handles.r = squeeze(round(coordinates(1,2)));
handles.c = squeeze(round(coordinates(1,1)));

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

% Saving zoom level
handles.xlim = get(handles.axes2, 'XLim');
handles.ylim = get(handles.axes2, 'YLim');

% Plot the spectrum image & spectrum
handles = plt(handles); % Call plt_axes1 function

% Update handles structure
guidata(handles.figure1,handles); 

%%
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
    case 'home'
        handles.c = 1;
    case 'end'
        handles.c = handles.EELS.SI_y;
    case 'pageup'
        handles.r = 1;
    case 'pagedown'
        handles.r = handles.EELS.SI_x;
    case 'escape'
        close_fig = 1;
    otherwise
        warning('Unexpected key pressed. Use only arrows, home, end, pageup & pagedown keys');
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

% Saving zoom level
handles.xlim = get(handles.axes2, 'XLim');
handles.ylim = get(handles.axes2, 'YLim');

% Plot the spectrum image & spectrum
handles = plt(handles); % Call plt_axes1 function

% Update handles structure
guidata(hObject, handles);

% Close figure if escape is pressed
if close_fig == 1
    close(hObject);
end

%% --- Plot spectrum image and spectrum
function handles = plt(handles)
% Plot axes1
axes(handles.axes1);
cla reset;

I = sum(handles.EELS.SImage,3);
%I = trapz(handles.EELS.energy_loss_axis,handles.EELS.SImage,3);
if max(I(:)) <= 1
    I = I * 1E10;
end
handles.I = imshow(uint64(I),[min(I(:)) max(I(:))]);
% label spectrum image
if((handles.EELS.SI_y*handles.EELS.step_size.y > 1000) && strcmp(handles.EELS.step_size.yunit,'nm'))
    xlabel(['Columns (',num2str(sprintf('%.2f',(handles.EELS.SI_y*handles.EELS.step_size.y)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
    plot_label_FOV(handles.axes1,(handles.EELS.SI_y*handles.EELS.step_size.y)/1000,'micro',handles.EELS.SI_x,handles.EELS.SI_y);
else
    xlabel(['Columns (',num2str(sprintf('%.2f',handles.EELS.SI_y*handles.EELS.step_size.y)),handles.EELS.step_size.yunit,')'],'FontWeight','bold','FontSize',10);
    plot_label_FOV(handles.axes1,handles.EELS.SI_y*handles.EELS.step_size.y,handles.EELS.step_size.yunit,handles.EELS.SI_x,handles.EELS.SI_y);
end
if((handles.EELS.SI_x*handles.EELS.step_size.x > 1000) && strcmp(handles.EELS.step_size.xunit,'nm'))
    ylabel(['Rows (',num2str(sprintf('%.2f',(handles.EELS.SI_x*handles.EELS.step_size.x)/1000)),'\mum)'],'FontWeight','bold','FontSize',10);
else
    ylabel(['Rows (',num2str(sprintf('%.2f',handles.EELS.SI_x*handles.EELS.step_size.x)),handles.EELS.step_size.xunit,')'],'FontWeight','bold','FontSize',10);
end
title(['Size = ',num2str(handles.EELS.SI_x),' x ',num2str(handles.EELS.SI_y),' pixel'],'FontWeight','bold','FontSize',10);
axis image

% Draw a rectagle box
rectangle('Position',[handles.c-0.5,handles.r-0.5,1,1],'LineWidth',2,'EdgeColor','r');

% Set static text boxes
set(handles.text1,'String',['Step size = ',num2str(sprintf('%.2f',handles.EELS.step_size.x)),handles.EELS.step_size.xunit]);
set(handles.text2,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);
set(handles.text3,'String',['Magnification = ',num2str(handles.EELS.mag)]);

% Plot axes2
axes(handles.axes2)

% Display spectrum
if(isfield(handles.EELS,'calibrated_energy_loss_axis'))
    plot(squeeze(handles.EELS.calibrated_energy_loss_axis(handles.r,handles.c,:)),squeeze(handles.EELS.SImage(handles.r,handles.c,:)),'LineWidth',1);
else
    plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.r,handles.c,:)),'LineWidth',1);
end

% Setting saved zoom level
if isfield(handles,'xlim')
    set(handles.axes2, 'XLim', handles.xlim);
end
if isfield(handles,'ylim')
    set(handles.axes2, 'YLim', handles.ylim);
end

% Display axis labels
xlabel('Energy-loss (eV) ','FontWeight','bold','FontSize',10);
ylabel('Count ','FontWeight','bold','FontSize',10);
title(['Pixel = (',num2str(handles.r),',',num2str(handles.c),')'],'FontWeight','bold','FontSize',10);
grid on
grid minor

% Set a callback function for keyboard key press
set(handles.output,'KeyPressFcn',@KeyPressCallback);
% Set a callback function for Click
set(handles.I,'ButtonDownFcn',@ImageClickCallback);

%% --- Outputs from this function are returned to the command line.
function varargout = plt_EELS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%%