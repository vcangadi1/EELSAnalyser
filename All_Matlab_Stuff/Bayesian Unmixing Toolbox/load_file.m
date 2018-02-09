function load_file( hObject,event) 
%Callback function associated to a menu
%Loads a .mat or .txt file in the workspace


global data handles FileName

[FileName,PathName] = uigetfile({'*.mat';'*.txt'},'Select a file'); % Choisir un fichier, format filtré par la commande

if (FileName == 0)
    return;
else
    if FileName(end-2:end)=='mat'
    structfile = load([PathName FileName]);
    structfield = fieldnames(structfile);
    data = structfile.(structfield{1});
        disp([FileName ' loaded'])
    elseif FileName(end-2:end)=='txt'
        data=load([PathName FileName]);
        disp([FileName ' loaded'])
    end
set(handles(24),'string',[FileName ' loaded'])

end
end