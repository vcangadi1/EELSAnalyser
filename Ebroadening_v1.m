function varargout = Ebroadening_v1(varargin)

% Copyright 2016 H. Yun 
% Author: Hwanhui Yun (yunxx133@umn.edu)
% Mkhoyan Lab, Department of Chemical Engineering and Materials Science,
% University of Minnesota, Twin Cities

% This program is distributed in the hope that it will be useful
% without any warranty. You can redistribute it and/or modify it.

% When using this code, please cite as: 1611.09284 [cond-mat.mtrl-sci]
% This code is distributed via [http://mkhoyan.cems.umn.edu/]
% Modified: Dec 2016        
% Revision: 12/12/2016

% This code implements energy broadening of the initial and final states of
% electronic transition to EELS simulation based on 'R.F. Egerton, Micron
% 34, 127 (2003).'




% Ebroadening_v1 MATLAB code for Ebroadening_v1.fig
%      Ebroadening_v1, by itself, creates a new Ebroadening_v1 or raises the existing
%      singleton*.
%
%      H = Ebroadening_v1 returns the handle to a new Ebroadening_v1 or the handle to
%      the existing singleton*.
%
%      Ebroadening_v1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Ebroadening_v1.M with the given input arguments.
%
%      Ebroadening_v1('Property','Value',...) creates a new Ebroadening_v1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ebroadening_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ebroadening_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Ebroadening_v1

% Last Modified by GUIDE v2.5 27-Dec-2016 18:10:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ebroadening_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @Ebroadening_v1_OutputFcn, ...
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
end


% --- Executes just before Ebroadening_v1 is made visible.
function Ebroadening_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ebroadening_v1 (see VARARGIN)
I=imread('Logo.jpg'); 
axes(handles.Logo);
imshow(I, 'Parent', handles.Logo);
set(handles.Logo, 'visible','off');

% Choose default command line output for Ebroadening_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Ebroadening_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = Ebroadening_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\n Author: Hwanhui Yun (yunxx133@umn.edu). Updated: Dec 2016');
fprintf('\n This code implements energy broadening of the initial and final states of electronic transition to EELS simulation. \n  Please cite as: arXiv:1611.09284 [cond-mat.mtrl-sci], when using this code.')
fprintf('\n \n Initial state E broadening works only for Z= 1~14 for K-shell and Z=13~35 for L-shell. \n In other cases, only final state E broadening is calculated.')
fprintf('\n \n Please make sure that your EELS simulation data, in excel (.xlsx) file, is in the same folder with this code \n The file should have two rows of energy and EELS intensity. \n The energy is E-Ec in eV, where Ec is the onset Energy of the edge.\n  i.e.   0     ## \n         0.05  ## \n         0.1   ## \n')


% Get default command line output from handles structure
varargout{1} = handles.output;

end




% --- Executes on selection change in shell.
function shell_Callback(hObject, eventdata, handles)
% hObject    handle to shell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


end

% --- Executes during object creation, after setting all properties.
function shell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function excel_Callback(hObject, eventdata, handles)
% hObject    handle to excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of excel as text
%        str2double(get(hObject,'String')) returns contents of excel as a double
end

% --- Executes during object creation, after setting all properties.
function excel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function zvalue_Callback(hObject, eventdata, handles)
% hObject    handle to zvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zvalue as text
%        str2double(get(hObject,'String')) returns contents of zvalue as a double

end
% --- Executes during object creation, after setting all properties.
function zvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



set(Ebroadening_v1, 'HandleVisibility', 'off');
close all;
set(Ebroadening_v1, 'HandleVisibility', 'on');

z=get(handles.zvalue,'String');z=str2num(cell2mat(z));
raw=get(handles.excel, 'String'); raw=char(raw);
Sim_00=xlsread(sprintf('%s',raw)); Sim_01=Sim_00(:,2); N=size(Sim_00); N=N(1);E=Sim_00(:,1);dispE=E(2)-E(1);

contents=get(handles.shell,'String');
shellv=get(handles.shell,'Value');


Elemc = ['H '; 'He'; 'Li'; 'Be'; 'B '; 'C '; 'N '; 'O '; 'F '; 'Ne'; 'Na'; 'Mg'; 'Al';'Si'; 'P '; 'S ';'Cl'; 'Ar'; 'K '; 'Ca'; 'Sc'; 'Ti'; 'V '; 'Cr'; 'Mn'; 'Fe'; 'Co'; 'Ni'; 'Cu'; 'Zn'; 'Ga'; 'Ge'; 'As'; 'Se'; 'Br';'Kr';'Rb';'Sr';'Y ';'Zr';'Nb';'Mo';'Tc';'Ru';'Rh';'Pd';'Ag';'Cd';'In';'Sn';'Sb';'Te';'I ';'Xe';'Cs';'Ba';'La';'Ce';'Pr';'Nd';'Pm';'Sm';'Eu';'Gd';'Tb';'Dy';'Ho';'Er';'Tm';'Yb';'Lu';'Hf';'Ta';'W ';'Re';'Os';'Ir';'Pt';'Au';'Hg';'Tl';'Pb';'Bi';'Po';'At';'Rn'];
Elem=cellstr(Elemc);

K_E= [13.6 21.2 54.7 111 118 283.8 401.6 532 685 867 1072 1305 1560 1839];
K=[0.003472895 0.005437027 0.014159278 0.029037153 0.030904672 0.076058456 0.108900479 0.145591648 0.188626752 0.239128835 0.29426328 0.35368781 0.413837585 0.473171049];
L_E=[73.1 99.2 132.2 164.8 200 245.2 293.6 346.4 402.2 455.5 513 574 640 708 779 854 931 1020 1115 1217 1323 1436 1550];
L=[0.014256302 0.025915531 0.042880693 0.061161003 0.081734468 0.108400029 0.136390791 0.165796845 0.195731783 0.223850697 0.254674231 0.28920673 0.330109778 0.377224225 0.432247558 0.496219266 0.566223907 0.648676965 0.733030077 0.814770605 0.892746169 0.990534095 1.163994237];


K_E=K_E';K=K';L_E=L_E';L=L';
El=char(Elem(z));
if shellv==1
    Sh='K';
else
    Sh='L';
end

%Energy broadening (Initial state)
%Zero-padding
Res_01=zeros(1,N);
Sim_02=zeros(1,11*N);
for i=5*N+1:6*N
    Sim_02(i)=Sim_01(i-5*N);    
end

%Energy broadening FWHM for the initial state

if shellv==1 
    if z<15
    delE_i=K(z);
    else
    delE_i=0.000000000000000001;
    warn=msgbox({'Initial state E broadening value for';sprintf('%s %s-edge is not included in this code.',El,Sh);'Only final state E broadening will be applied.'},'Warning', 'warn');
    waitfor(warn);
    end
else
        if z<36 && z>12
        delE_i=L(z-12);
        elseif z<13
        delE_i=0.000000000000000001;  
      warn=msgbox({sprintf('%s %s-edge does not exist.',El,Sh)},'Warning', 'warn');
       waitfor(warn);return;
        elseif z>35
        delE_i=0.000000000000000001;  
         warn=msgbox({'Initial state E broadening value for';sprintf('%s %s-edge is not included in this code.',El,Sh);'Only final state E broadening will be applied.'},'Warning', 'warn');
         waitfor(warn);
        end
end

if delE_i==0.000000000000000001
    for i=1:N
        Res_01(i)=Sim_01(i);
    end
else
    for i=1:N
    x=(-N:N); sigma=delE_i/dispE;
    Lo=sigma/2./pi./((x.^2+(sigma/2.)^2));
    Res_02=conv(Sim_02,Lo,'same');
    Res_01(i)=Res_02(5*N+i);
    end
end

%Energy broadening (Final state)
Res_03=zeros(1,N);
%Zero-padding
for i=5*N+1:6*N
    Sim_02(i)=Res_01(i-5*N);    
end

%Generating FWHM of the energy broadening of the final state

Dis=zeros(1,N);
for i=1:N
    if E(i)<=9
        Dis(i)=-0.03905*(1-exp(0.30259*E(i)));        
    elseif E(i)<=60
        Dis(i)=(0.80793-0.32385*E(i)+0.04582*E(i)^2-0.00171*E(i)^3+0.0000269949*E(i)^4-0.000000155119*E(i)^5)*0.43+(5.28512-1.48778*E(i)+0.16075*E(i)^2-0.00731*E(i)^3+0.000171486*E(i)^4-0.00000209055*E(i)^5+0.0000000115893*E(i)^6-0.0000000000170513*E(i)^7)*0.57;       
    elseif E(i)<=100
        Dis(i)=31.08524-1.6958*E(i)+0.04318*E(i)^2-0.000526259*E(i)^3+0.00000310963*E(i)^4-0.00000000715605*E(i)^5;        
    else
    warn=msgbox({'The energy range exceeds the available ' 'energy range for final state E broadening.' 'Final state E broadening works in E-Ec<100eV.'},'Warning', 'warn');
    waitfor(warn); return;
    end
end


for i=1:N
x=[-11*N:11*N]; sigma=Dis(i)/dispE;
if sigma<1
    sigma=1;
    Lo=sigma/2./pi./((x.^2+(sigma/2.)^2));
    Res_04=conv(Sim_02,Lo,'same');
    Res_03(i)=Res_04(5*N+i);
else
Lo=sigma/2./pi./((x.^2+(sigma/2.)^2));
Res_04=conv(Sim_02,Lo,'same');
Res_03(i)=Res_04(5*N+i);
end
end

Fin=[E Res_03'];

plot(handles.axes3, E, Sim_01); axes(handles.axes3); axis('tight');leg=legend('before E broadening'); set(leg, 'FontSize',10);ylabel ('Intensity');set(gca,'ytick',[]);set(gca,'xtick',[]);
plot(handles.axes4, E, Res_03); axes(handles.axes4); axis('tight');leg=legend('after E broadening'); set(leg, 'FontSize',10);xlabel ('E-Ec (eV)');ylabel ('Intensity');set(gca,'ytick',[]);
plot(handles.axes2, E, Dis,'r');axes(handles.axes2);axis('tight');title ('Final state E broadening');xlabel ('E-Ec (eV)');ylabel ('\Delta E_f (eV)'); text(23, 1, 'R.F. Egerton, Micron');text (28, 0.5, '34, 127 (2003)');


if shellv ==1&& z<15
    plot(handles.axes1, K_E, K);  axes(handles.axes1);  title ('Initial state E broadening'); xlabel ('Energy (eV)');ylabel ('\Delta E_i (eV)');xlabh = get(gca,'XLabel'); 
    hold on;     scatter(handles.axes1,K_E(z), K(z), 'r', '*');  hold off;  kz=round(K(z)*100)/100;
    text(100, 0.4,'\Delta E_i' );text(280, 0.408, sprintf(' ( %s %s-edge ) = %.2f eV',El,Sh,kz)); axis tight; 
    text(800, 0.09, 'R.F. Egerton, Micron');text(950,0.05,'34, 127 (2003)');
elseif shellv ==2 && z<36 && z>12
    plot(handles.axes1, L_E, L);axes(handles.axes1); title ('Initial state E broadening');xlabel ('Energy (eV)');ylabel ('\Delta E_i (eV)');xlabh = get(gca,'XLabel'); 
   hold on;     scatter(handles.axes1,L_E(z-12), L(z-12), 'r', '*');     hold off;lz=round(L(z-12)*100)/100;
    text(200, 0.9,'\Delta E_i' );text(350, 0.915, sprintf(' ( %s %s-edge ) = %.2f eV',El,Sh,lz));  axis tight;
    text(700, 0.22, 'R.F. Egerton, Micron');text(820,0.12,'34, 127 (2003)');
else
    scatter(handles.axes1, [], []);
    axes(handles.axes1); text(0.1, 0.5 ,'Initial state E broadening ');text(0.1, 0.35 ,'                  was not applied ');
end
end


% --- Executes on button press in runandexport.
function runandexport_Callback(hObject, eventdata, handles)
% hObject    handle to runandexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




set(Ebroadening_v1, 'HandleVisibility', 'off');
close all;
set(Ebroadening_v1, 'HandleVisibility', 'on');

z=get(handles.zvalue,'String');z=str2num(cell2mat(z));
raw=get(handles.excel, 'String'); raw=char(raw);
Sim_00=xlsread(sprintf('%s',raw)); Sim_01=Sim_00(:,2); N=size(Sim_00); N=N(1);E=Sim_00(:,1);dispE=E(2)-E(1);

contents=get(handles.shell,'String');
shellv=get(handles.shell,'Value');


Elemc = ['H '; 'He'; 'Li'; 'Be'; 'B '; 'C '; 'N '; 'O '; 'F '; 'Ne'; 'Na'; 'Mg'; 'Al';'Si'; 'P '; 'S ';'Cl'; 'Ar'; 'K '; 'Ca'; 'Sc'; 'Ti'; 'V '; 'Cr'; 'Mn'; 'Fe'; 'Co'; 'Ni'; 'Cu'; 'Zn'; 'Ga'; 'Ge'; 'As'; 'Se'; 'Br';'Kr';'Rb';'Sr';'Y ';'Zr';'Nb';'Mo';'Tc';'Ru';'Rh';'Pd';'Ag';'Cd';'In';'Sn';'Sb';'Te';'I ';'Xe';'Cs';'Ba';'La';'Ce';'Pr';'Nd';'Pm';'Sm';'Eu';'Gd';'Tb';'Dy';'Ho';'Er';'Tm';'Yb';'Lu';'Hf';'Ta';'W ';'Re';'Os';'Ir';'Pt';'Au';'Hg';'Tl';'Pb';'Bi';'Po';'At';'Rn'];
Elem=cellstr(Elemc);

K_E= [13.6 21.2 54.7 111 118 283.8 401.6 532 685 867 1072 1305 1560 1839];
K=[0.003472895 0.005437027 0.014159278 0.029037153 0.030904672 0.076058456 0.108900479 0.145591648 0.188626752 0.239128835 0.29426328 0.35368781 0.413837585 0.473171049];
L_E=[73.1 99.2 132.2 164.8 200 245.2 293.6 346.4 402.2 455.5 513 574 640 708 779 854 931 1020 1115 1217 1323 1436 1550];
L=[0.014256302 0.025915531 0.042880693 0.061161003 0.081734468 0.108400029 0.136390791 0.165796845 0.195731783 0.223850697 0.254674231 0.28920673 0.330109778 0.377224225 0.432247558 0.496219266 0.566223907 0.648676965 0.733030077 0.814770605 0.892746169 0.990534095 1.163994237];


K_E=K_E';K=K';L_E=L_E';L=L';
El=char(Elem(z));
if shellv==1
    Sh='K';
else
    Sh='L';
end

%Energy broadening (Initial state)
%Zero-padding
Res_01=zeros(1,N);
Sim_02=zeros(1,11*N);
for i=5*N+1:6*N
    Sim_02(i)=Sim_01(i-5*N);    
end

%Energy broadening FWHM for the initial state
if shellv==1 
    if z<15
    delE_i=K(z);
    else
    delE_i=0.000000000000000001;
    uiwait(msgbox({'Initial state E broadening value for';sprintf('%s %s-edge is not included in this code.',El,Sh);'Only final state E broadening will be applied.'},'Warning', 'warn'));
    end
else
        if z<36 && z>12
        delE_i=L(z-12);
        elseif z<13
        delE_i=0.000000000000000001;  
      warn=msgbox({sprintf('%s %s-edge does not exist.',El,Sh)},'Warning', 'warn');
       waitfor(warn);return;
        elseif z>35
        delE_i=0.000000000000000001;  
        uiwait(msgbox({'Initial state E broadening value for';sprintf('%s %s-edge is not included in this code.',El,Sh);'Only final state E broadening will be applied.'},'Warning', 'warn'));
        end   
end

if delE_i==0.000000000000000001
    for i=1:N
        Res_01(i)=Sim_01(i);
    end
else
    for i=1:N
    x=(-N:N); sigma=delE_i/dispE;
    Lo=sigma/2./pi./((x.^2+(sigma/2.)^2));
    Res_02=conv(Sim_02,Lo,'same');
    Res_01(i)=Res_02(5*N+i);
    end
end

%Energy broadening (Final state)
Res_03=zeros(1,N);
%Zero-padding
for i=5*N+1:6*N
    Sim_02(i)=Res_01(i-5*N);    
end

%Generating FWHM of the energy broadening of the final state

Dis=zeros(1,N);
for i=1:N
    if E(i)<=9
        Dis(i)=-0.03905*(1-exp(0.30259*E(i)));        
    elseif E(i)<=60
        Dis(i)=(0.80793-0.32385*E(i)+0.04582*E(i)^2-0.00171*E(i)^3+0.0000269949*E(i)^4-0.000000155119*E(i)^5)*0.43+(5.28512-1.48778*E(i)+0.16075*E(i)^2-0.00731*E(i)^3+0.000171486*E(i)^4-0.00000209055*E(i)^5+0.0000000115893*E(i)^6-0.0000000000170513*E(i)^7)*0.57;       
    elseif E(i)<=100
        Dis(i)=31.08524-1.6958*E(i)+0.04318*E(i)^2-0.000526259*E(i)^3+0.00000310963*E(i)^4-0.00000000715605*E(i)^5;        
    else
    warn=msgbox({'The energy range exceeds the available ' 'energy range for final state E broadening.' 'Final state E broadening works in E-Ec<100eV.'},'Warning', 'warn');
    waitfor(warn); return;
    end
end


for i=1:N
x=[-11*N:11*N]; sigma=Dis(i)/dispE;
if sigma<1
    sigma=1;
    Lo=sigma/2./pi./((x.^2+(sigma/2.)^2));
    Res_04=conv(Sim_02,Lo,'same');
    Res_03(i)=Res_04(5*N+i);
else
Lo=sigma/2./pi./((x.^2+(sigma/2.)^2));
Res_04=conv(Sim_02,Lo,'same');
Res_03(i)=Res_04(5*N+i);
end
end

Fin=[E Res_03'];

plot(handles.axes3, E, Sim_01); axes(handles.axes3); axis('tight');leg=legend('before E broadening'); set(leg, 'FontSize',10);ylabel ('Intensity');set(gca,'ytick',[]);set(gca,'xtick',[]);
plot(handles.axes4, E, Res_03); axes(handles.axes4); axis('tight');leg=legend('after E broadening'); set(leg, 'FontSize',10);xlabel ('E-Ec (eV)');ylabel ('Intensity');set(gca,'ytick',[]);
plot(handles.axes2, E, Dis,'r');axes(handles.axes2);axis('tight');title ('Final state E broadening');xlabel ('E-Ec (eV)');ylabel ('\Delta E_f (eV)'); text(23, 1, 'R.F. Egerton, Micron');text (28, 0.5, '34, 127 (2003)');

if shellv ==1&& z<15
    plot(handles.axes1, K_E, K);  axes(handles.axes1);  title ('Initial state E broadening'); xlabel ('Energy (eV)');ylabel ('\Delta E_i (eV)');xlabh = get(gca,'XLabel'); 
    hold on;     scatter(handles.axes1,K_E(z), K(z), 'r','*');  hold off;  kz=round(K(z)*100)/100;spr=sprintf(' ( %s %s-edge ) = %.2f eV',El,Sh,kz);
    text(100, 0.4,'\Delta E_i' );text(280, 0.408,cellstr(spr) ); axis tight;
    text(800, 0.09, 'R.F. Egerton, Micron');text(950,0.05,'34, 127 (2003)');
elseif shellv ==2 && z<36 && z>12
    plot(handles.axes1, L_E, L);axes(handles.axes1); title ('Initial state E broadening');xlabel ('Energy (eV)');ylabel ('\Delta E_i (eV)');xlabh = get(gca,'XLabel'); 
   hold on;     scatter(handles.axes1,L_E(z-12), L(z-12), 'r','*');     hold off;lz=round(L(z-12)*100)/100;spr=sprintf(' ( %s %s-edge ) = %.2f eV',El,Sh,lz);
    text(200, 0.9,'\Delta E_i' );text(350, 0.915, cellstr(spr));  axis tight;spr=sprintf(' Initial state E broadening of( %s %s-edge ) is %.2f eV',El,Sh,lz);
     text(700, 0.22, 'R.F. Egerton, Micron');text(820,0.12,'34, 127 (2003)');
else
    scatter(handles.axes1, [], []);
    axes(handles.axes1); text(0.1, 0.5 ,'Initial state E broadening ');text(0.1, 0.35 ,'                  was not applied. ');
end


value=get(handles.checkbox1,'Value');
if value==0
    
name=sprintf('EELS %s %s-edge result', El, Sh); 
firstline=sprintf('EELS %s %s-edge',El,Sh); secondline=sprintf(' - "%s" file was used',raw); 
fourthline=sprintf(' - Final state E broadening was applied from %.2f to %.2f eV Energy range',E(1), E(N));xlswrite(name, cellstr(fourthline),1,'A4');
fifthline={'Energy (eV)','Intensity'};
xlswrite(name, Fin, 1, 'A6'); xlswrite(name, cellstr(firstline), 1, 'A1');xlswrite(name, cellstr(secondline), 1, 'A2'); xlswrite(name, fifthline, 1, 'A5:B5');
if shellv ==1 && z<15
    spr=sprintf(' - Initial state E broadening = %.2f eV',kz);
    xlswrite(name, cellstr(spr), 1, 'A3');
elseif shellv==2 && z<36 && z>12
    spr=sprintf(' - Initial state E broadening = %.2f eV',lz);
    xlswrite(name, cellstr(spr), 1, 'A3');
else
     xlswrite(name, cellstr(' - Initial state E broadening was not applied'), 1, 'A3');
end
fileID=fopen(sprintf('EELS %s %s-edge result.txt',El, Sh),'w');
fprintf(fileID,'EELS %s %s-edge\r\n',El,Sh);
fprintf(fileID,' - "%s"file was used\r\n',raw);
if shellv ==1 && z<15
    fprintf(fileID, ' - Initial state E broadening = %.2f eV\r\n',kz);
elseif shellv==2 && z<36 && z>12
     fprintf(fileID, ' - Initial state E broadening = %.2f eV\r\n',lz);
else
    fprintf(fileID, ' - Initial state E broadening was not applied\r\n');
end
fprintf(fileID,' - Final state E broadening was applied from %.2f to %.2f eV Energy range\r\n',E(1),E(N));
fprintf(fileID,'%6s %12s\r\n','Energy(eV)','Intensity');
Fin=Fin' ;fprintf(fileID,'%6.4f %12.8f\r\n',Fin);
fclose(fileID);
fprintf(sprintf('\n\nEnergy broadening on %s %s-edge was performed.', El, Sh)); fprintf('\n The result is exported as .txt and .xlsx files \n');
else
   
fileID=fopen(sprintf('EELS %s %s-edge result.csv',El, Sh),'w');
fprintf(fileID,'EELS %s %s-edge\r\n',El,Sh);
fprintf(fileID,' - "%s"file was used\r\n',raw);
if shellv ==1 && z<15
    fprintf(fileID, ' - Initial state E broadening = %.2f eV\r\n',kz);
elseif shellv==2 && z<36 && z>12
     fprintf(fileID, ' - Initial state E broadening = %.2f eV\r\n',lz);
else
    fprintf(fileID, ' - Initial state E broadening was not applied\r\n');
end
fprintf(fileID,' - Final state E broadening was applied from %.2f to %.2f eV Energy range\r\n',E(1),E(N));
fprintf(fileID,'%6s %12s\r\n','Energy(eV)','Intensity');
fclose(fileID); 
dlmwrite(sprintf('EELS %s %s-edge result.csv',El, Sh),Fin,'-append');

fileID=fopen(sprintf('EELS %s %s-edge result.txt',El, Sh),'w');
fprintf(fileID,'EELS %s %s-edge\r\n',El,Sh);
fprintf(fileID,' - "%s"file was used\r\n',raw);
if shellv ==1 && z<15
    fprintf(fileID, ' - Initial state E broadening = %.2f eV\r\n',kz);
elseif shellv==2 && z<36 && z>12
     fprintf(fileID, ' - Initial state E broadening = %.2f eV\r\n',lz);
else
    fprintf(fileID, ' - Initial state E broadening was not applied\r\n');
end
fprintf(fileID,' - Final state E broadening was applied from %.2f to %.2f eV Energy range\r\n',E(1),E(N));
fprintf(fileID,'%6s %12s\r\n','Energy(eV)','Intensity');
Fin=Fin' ;fprintf(fileID,'%6.4f %12.8f\r\n',Fin);
fclose(fileID);  
    
fprintf(sprintf('\n\n Energy broadening on %s %s-edge was performed.', El, Sh)); fprintf('\n The result is exported as .txt and .csv files for Mac users \n');    
end
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over run.
function run_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
end
