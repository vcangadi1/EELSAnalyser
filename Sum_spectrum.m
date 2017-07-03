function varargout = Sum_spectrum(varargin)
%SUM_SPECTRUM M-file for Sum_spectrum.fig
%      SUM_SPECTRUM, by itself, creates a new SUM_SPECTRUM or raises the existing
%      singleton*.
%
%      H = SUM_SPECTRUM returns the handle to a new SUM_SPECTRUM or the handle to
%      the existing singleton*.
%
%      SUM_SPECTRUM('Property','Value',...) creates a new SUM_SPECTRUM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Sum_spectrum_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SUM_SPECTRUM('CALLBACK') and SUM_SPECTRUM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SUM_SPECTRUM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sum_spectrum

% Last Modified by GUIDE v2.5 11-Nov-2015 19:25:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sum_spectrum_OpeningFcn, ...
                   'gui_OutputFcn',  @Sum_spectrum_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Sum_spectrum is made visible.
function Sum_spectrum_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Enter the input to handles.EELS
if(length(varargin)<1)
    handles.EELS = readEELSdata;
else
    handles.EELS = varargin{1};
end


% Plot the spectrum image
axes(handles.axes1)
I = sum(handles.EELS.SImage,3);
handles.I = imagesc(I,[min(I(:)) max(I(:))]);
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
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
axis image

% Choose default command line output for Sum_spectrum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sum_spectrum wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sum_spectrum_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Read the handles data
handles = guidata(hObject);

% Get default command line output from handles structure
varargout{1} = handles.spectrum;

% The figure can be deleted now
%delete(handles.figure1);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% Read the handles data
handles = guidata(hObject);

cb = findobj('Style','checkbox');
delete(cb);

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
handles.NumOfReg = str2double(str{val});

% Create check boxes related to each regions
for i = 1:length(str)-1,
    cb = uicontrol(handles.uipanel1,'Style','checkbox',...
            'String',['Region ', num2str(i), ' spectrum'],...
            'Value',0,'Position',[25 300-i*20 130 20],...
            'Callback',@checkbox_Callback,...
            'Tag',num2str(i));
    if i > handles.NumOfReg
        cb.Visible = 'off';
    end
    handles.cb(i) = cb;
end

% Initialize spectrum
handles.spectrum = zeros(handles.EELS.SI_z, handles.NumOfReg);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in checkbox.
function checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

% Read the handles data
handles = guidata(hObject);

if (get(hObject,'Value') == get(hObject,'Max'))
	BW = roipoly;
    handles.spectrum(:,str2double(get(hObject,'Tag'))) = squeeze(sum(sum(handles.EELS.SImage .* repmat(BW,1,1,handles.EELS.SI_z),1),2));
    disp(str2double(get(hObject,'Tag')));
else
	handles.spectrum(:,str2double(get(hObject,'Tag'))) = 0;
    disp(str2double(get(hObject,'Tag')));
end

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
