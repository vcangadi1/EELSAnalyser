function varargout = gui_exp_curve_fit(varargin)
% GUI_EXP_CURVE_FIT MATLAB code for gui_exp_curve_fit.fig
%      GUI_EXP_CURVE_FIT, by itself, creates a new GUI_EXP_CURVE_FIT or raises the existing
%      singleton*.
%
%      H = GUI_EXP_CURVE_FIT returns the handle to a new GUI_EXP_CURVE_FIT or the handle to
%      the existing singleton*.
%
%      GUI_EXP_CURVE_FIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_EXP_CURVE_FIT.M with the given input arguments.
%
%      GUI_EXP_CURVE_FIT('Property','Value',...) creates a new GUI_EXP_CURVE_FIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_exp_curve_fit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_exp_curve_fit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_exp_curve_fit

% Last Modified by GUIDE v2.5 19-Aug-2014 19:24:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_exp_curve_fit_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_exp_curve_fit_OutputFcn, ...
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


% --- Executes just before gui_exp_curve_fit is made visible.
function gui_exp_curve_fit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_exp_curve_fit (see VARARGIN)

% Choose default command line output for gui_exp_curve_fit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_exp_curve_fit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_exp_curve_fit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_Data_Button.
function Load_Data_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Plot_Data_Button.
function Plot_Data_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Data_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Load_Button.
function Load_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fullpathname = handles.fullpathname;
si_struct = DM3Import( fullpathname );
% Load handles
handles.meta_data = si_struct;
set(handles.Status_bar,'String','File has been Loaded');
% Update Handles
guidata(hObject, handles);


% --- Executes on button press in Close_Button.
function Close_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Close_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
clf;
close gui_exp_curve_fit;


function Configuration_1_1_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Configuration_1_1_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Configuration_1_1_Box as text
%        str2double(get(hObject,'String')) returns contents of Configuration_1_1_Box as a double


% --- Executes during object creation, after setting all properties.
function Configuration_1_1_Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Configuration_1_1_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Configuration_1_2_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Configuration_1_2_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Configuration_1_2_Box as text
%        str2double(get(hObject,'String')) returns contents of Configuration_1_2_Box as a double


% --- Executes during object creation, after setting all properties.
function Configuration_1_2_Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Configuration_1_2_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Fit_Button.
function Fit_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Fit_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Plot_Button.
function Plot_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
si_struct = handles.meta_data;
EELS_spectrum = si_struct.image_data(16,16,:);
EELS_spectrum = (reshape(EELS_spectrum,1024,1));
axes(handles.axes1);
plot(EELS_spectrum,'LineWidth',3);
set(handles.Status_bar,'String','EELS Spectrum Plot');
guidata(hObject, handles);


% --- Executes on button press in New_Data_Button.
function New_Data_Button_Callback(hObject, eventdata, handles)
% hObject    handle to New_Data_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'.dm3'},'File Selector');
fullpathname = strcat(pathname,filename);
% Load handles
set(handles.File_Name,'String',filename);       % Display file name in the static text box
set(handles.Status_bar,'String','New file is read');
handles.filename = filename;
handles.pathname = pathname;
handles.fullpathname = fullpathname;
% Update Handles
guidata(hObject, handles);


% --- Executes on button press in Calibrate_Button.
function Calibrate_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Calibrate_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
si_struct = handles.meta_data;
D = si_struct.zaxis.scale;
EELS_spectrum = si_struct.image_data(16,16,:);
EELS_spectrum = (reshape(EELS_spectrum,1024,1));
axes(handles.axes1);
plot((1:1024).*D -56 + 78,EELS_spectrum,'LineWidth',3);
set(handles.Status_bar,'String','EELS Calibated Plot');
guidata(hObject, handles);



function Custom_plot_1_Callback(hObject, eventdata, handles)
% hObject    handle to Custom_plot_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Custom_plot_1 as text
%        str2double(get(hObject,'String')) returns contents of Custom_plot_1 as a double


% --- Executes during object creation, after setting all properties.
function Custom_plot_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Custom_plot_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Custom_plot_2_Callback(hObject, eventdata, handles)
% hObject    handle to Custom_plot_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Custom_plot_2 as text
%        str2double(get(hObject,'String')) returns contents of Custom_plot_2 as a double


% --- Executes during object creation, after setting all properties.
function Custom_plot_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Custom_plot_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Custom_plot_Button.
function Custom_plot_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Custom_plot_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = str2num(get(handles.Custom_plot_1,'String'));
b = str2num(get(handles.Custom_plot_2,'String'));
si_struct = handles.meta_data;
D = si_struct.zaxis.scale;
EELS_spectrum = si_struct.image_data(16,16,:);
EELS_spectrum = (reshape(EELS_spectrum,1024,1));
axes(handles.axes1);
a = a./D +56-78;
b = b./D +56-78;
plot((a:b).*D -56 + 78,EELS_spectrum(a:b),'LineWidth',3);
set(handles.Status_bar,'String','EELS Calibated Plot');
guidata(hObject, handles);
