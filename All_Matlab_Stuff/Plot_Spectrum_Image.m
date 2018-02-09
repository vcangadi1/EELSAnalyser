function varargout = Plot_Spectrum_Image(varargin)
% PLOT_SPECTRUM_IMAGE MATLAB code for Plot_Spectrum_Image.fig
%      PLOT_SPECTRUM_IMAGE, by itself, creates a new PLOT_SPECTRUM_IMAGE or raises the existing
%      singleton*.
%
%      H = PLOT_SPECTRUM_IMAGE returns the handle to a new PLOT_SPECTRUM_IMAGE or the handle to
%      the existing singleton*.
%
%      PLOT_SPECTRUM_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_SPECTRUM_IMAGE.M with the given input arguments.
%
%      PLOT_SPECTRUM_IMAGE('Property','Value',...) creates a new PLOT_SPECTRUM_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plot_Spectrum_Image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plot_Spectrum_Image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plot_Spectrum_Image

% Last Modified by GUIDE v2.5 23-Aug-2015 15:05:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plot_Spectrum_Image_OpeningFcn, ...
                   'gui_OutputFcn',  @Plot_Spectrum_Image_OutputFcn, ...
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


% --- Executes just before Plot_Spectrum_Image is made visible.
function Plot_Spectrum_Image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plot_Spectrum_Image (see VARARGIN)

%handles.EELS = readEELSdata('Si B P 10082015/EELS Spectrum Image 25nm.dm3');
if(length(varargin)<1)
    handles.EELS = readEELSdata;
else
    handles.EELS = varargin{1};
end
% set the slider_SImage_top range and step size
set(handles.slider_SImage_top, 'Min', 1);
set(handles.slider_SImage_top, 'Max', handles.EELS.SI_x);
set(handles.slider_SImage_top, 'Value', 1);
set(handles.slider_SImage_top, 'SliderStep', [1/(handles.EELS.SI_x-1) , 1/(handles.EELS.SI_x-1) ]);

% set the slider_SImage_side range and step size
set(handles.slider_SImage_side, 'Min', 1);
set(handles.slider_SImage_side, 'Max', handles.EELS.SI_y);
set(handles.slider_SImage_side, 'Value', handles.EELS.SI_y);
set(handles.slider_SImage_side, 'SliderStep', [1/(handles.EELS.SI_y-1) , 1/(handles.EELS.SI_y-1) ]);
disp(handles.EELS.SI_y);

SImage_top=get(handles.slider_SImage_top,'Value');
SImage_side=get(handles.slider_SImage_side,'Value');

% Create the Spectrum image and rectangle
axes(handles.axes_SImage)
%handles.im = imagesc(sum(handles.EELS.SImage,3)');
%I = sum(handles.EELS.SImage,3);
I = reshape(sum(handles.EELS.SImage,3),handles.EELS.SI_x,handles.EELS.SI_y)';
handles.im = imshow(uint64(I),[min(I(:)) max(I(:))]);
%title(['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
xlabel(['x-axis in ', num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
ylabel(['y-axis in ', num2str(handles.EELS.step_size.yunit)],'FontWeight','bold');
colormap(gray);
set(handles.im,'ButtonDownFcn',@ImageClickCallback);
hold on
rectangle('Position',[SImage_top-0.5, handles.EELS.SI_y-SImage_side-0.5+1, 1, 1],...
          'LineWidth',2,...
          'EdgeColor','r');
hold off

% Plot EELS_spectrum of current slider position
axes(handles.axes_EELS_spectrum)
plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.EELS.SI_y-SImage_side+1,SImage_top,:)));
title(['Pixel = (',num2str(SImage_top),',',num2str(handles.EELS.SI_y-SImage_side+1),')'],'FontWeight','bold');
xlabel('Energy-loss axis (eV)','FontWeight','bold');
ylabel('Counts','FontWeight','bold');
grid on

% Set static text values
set(handles.text_Static_text1,'String',['Magnification = ',num2str(handles.EELS.mag)]);
set(handles.text_Static_text2,'String',['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)]);
set(handles.text_Static_text3,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);

% Choose default command line output for Plot_Spectrum_Image
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plot_Spectrum_Image wait for user response (see UIRESUME)
% uiwait(handles.figure_plot_Spectrum_Image);


% --- Outputs from this function are returned to the command line.
function varargout = Plot_Spectrum_Image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_SImage_side_Callback(hObject, eventdata, handles)
% hObject    handle to slider_SImage_side (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

SImage_side=get(handles.slider_SImage_side,'Value');
%a=(1:1:handles.EELS.SI_y);
%SImage_side=round(SImage_side);
%[~,I]=min(abs(SImage_side-a));
%SImage_side=a(I);
set(handles.slider_SImage_side,'Value',round(SImage_side));

SImage_top=get(handles.slider_SImage_top,'Value');
SImage_side=get(handles.slider_SImage_side,'Value');

% Create the Spectrum image and rectangle
axes(handles.axes_SImage)
%handles.im = imagesc(sum(handles.EELS.SImage,3)');
%I = sum(handles.EELS.SImage,3);
I = reshape(sum(handles.EELS.SImage,3),handles.EELS.SI_x,handles.EELS.SI_y)';
handles.im = imshow(uint64(I),[min(I(:)) max(I(:))]);
%title(['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
xlabel(['units in ', num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
ylabel(['units in ', num2str(handles.EELS.step_size.yunit)],'FontWeight','bold');
colormap(gray);
set(handles.im,'ButtonDownFcn',@ImageClickCallback);
hold on
rectangle('Position',[SImage_top-0.5, handles.EELS.SI_y-SImage_side-0.5+1, 1, 1],...
          'LineWidth',2,...
          'EdgeColor','r');
hold off

% Plot EELS_spectrum of current slider position
axes(handles.axes_EELS_spectrum)
plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.EELS.SI_y-SImage_side+1,SImage_top,:)));
title(['Pixel = (',num2str(SImage_top),',',num2str(handles.EELS.SI_y-SImage_side+1),')'],'FontWeight','bold');
xlabel('Energy-loss axis (eV)','FontWeight','bold');
ylabel('Counts','FontWeight','bold');
grid on

% Set static text values
set(handles.text_Static_text1,'String',['Magnification = ',num2str(handles.EELS.mag)]);
set(handles.text_Static_text2,'String',['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)]);
set(handles.text_Static_text3,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_SImage_side_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_SImage_side (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_SImage_top_Callback(hObject, eventdata, handles)
% hObject    handle to slider_SImage_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

SImage_top=get(handles.slider_SImage_top,'Value');
a=(1:1:handles.EELS.SI_x);
SImage_top=round(SImage_top);
[~,J]=min(abs(SImage_top-a));
SImage_top=a(J);
set(handles.slider_SImage_top,'Value',SImage_top);

SImage_top = get(handles.slider_SImage_top,'Value');
SImage_side=get(handles.slider_SImage_side,'Value');

% Create the Spectrum image and rectangle
axes(handles.axes_SImage)
%handles.im = imagesc(sum(handles.EELS.SImage,3)');
%I = sum(handles.EELS.SImage,3);
I = reshape(sum(handles.EELS.SImage,3),handles.EELS.SI_x,handles.EELS.SI_y)';
handles.im = imshow(uint64(I),[min(I(:)) max(I(:))]);
%title(['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
xlabel(['units in ', num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
ylabel(['units in ', num2str(handles.EELS.step_size.yunit)],'FontWeight','bold');
colormap(gray);
set(handles.im,'ButtonDownFcn',@ImageClickCallback);
hold on
rectangle('Position',[SImage_top-0.5, handles.EELS.SI_y-SImage_side-0.5+1, 1, 1],...
          'LineWidth',2,...
          'EdgeColor','r');
hold off

% Plot EELS_spectrum of current slider position
axes(handles.axes_EELS_spectrum)
plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(handles.EELS.SI_y-SImage_side+1,SImage_top,:)));
title(['Pixel = (',num2str(SImage_top),',',num2str(handles.EELS.SI_y-SImage_side+1),')'],'FontWeight','bold');
xlabel('Energy-loss axis (eV)','FontWeight','bold');
ylabel('Counts','FontWeight','bold');
grid on

% Set static text values
set(handles.text_Static_text1,'String',['Magnification = ',num2str(handles.EELS.mag)]);
set(handles.text_Static_text2,'String',['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)]);
set(handles.text_Static_text3,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_SImage_top_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_SImage_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_EELS_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to slider_EELS_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_EELS_spectrum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_EELS_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function axes_SImage_CreateFcn(hObject, eventdata, handles)

% --- Executes on mouse press over axes background.
function ImageClickCallback(hObject, eventdata, handles)
% hObject    handle to axes_SImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   axesHandle  = get(hObject,'Parent');
   coordinates = get(axesHandle,'CurrentPoint'); 
   coordinates = coordinates(1,1:2);
   disp(round(coordinates));
   save('abcd.mat','coordinates');
   %// then here you can use coordinates as you want ...
handles = guidata(hObject);

% Create the Spectrum image and rectangle
axes(handles.axes_SImage)
%handles.im = imagesc(sum(handles.EELS.SImage,3)');
%I = sum(handles.EELS.SImage,3);
I = reshape(sum(handles.EELS.SImage,3),handles.EELS.SI_x,handles.EELS.SI_y)';
handles.im = imshow(uint64(I),[min(I(:)) max(I(:))]);
%title(['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
xlabel(['units in ', num2str(handles.EELS.step_size.xunit)],'FontWeight','bold');
ylabel(['units in ', num2str(handles.EELS.step_size.yunit)],'FontWeight','bold');
colormap(gray);
set(handles.im,'ButtonDownFcn',@ImageClickCallback);
hold on
rectangle('Position',[round(coordinates(1))-0.5, round(coordinates(2))-0.5, 1, 1],...
          'LineWidth',2,...
          'EdgeColor','r');
hold off

% Plot EELS_spectrum of current slider position
axes(handles.axes_EELS_spectrum)
plot(handles.EELS.energy_loss_axis,squeeze(handles.EELS.SImage(round(coordinates(2)),round(coordinates(1)),:)));
title(['Pixel = (',num2str(round(coordinates(1))),',',num2str(round(coordinates(2))),')'],'FontWeight','bold');
xlabel('Energy-loss axis (eV)','FontWeight','bold');
ylabel('Counts','FontWeight','bold');
grid on

% Set static text values
set(handles.text_Static_text1,'String',['Magnification = ',num2str(handles.EELS.mag)]);
set(handles.text_Static_text2,'String',['Step size = ',num2str(handles.EELS.step_size.x),num2str(handles.EELS.step_size.xunit)]);
set(handles.text_Static_text3,'String',['Dispersion = ',num2str(handles.EELS.dispersion),'eV/channel']);

set(handles.slider_SImage_top,'Value',round(coordinates(1)));
set(handles.slider_SImage_side,'Value',handles.EELS.SI_y-round(coordinates(2))+1);
