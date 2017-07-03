function [endm, matP, matU, Y_bar, endm_proj, y_proj] = find_endm(Y,R,method)

global sources handles RGB

L_red = R-1;
P = size(Y,2);
       
% PCA
disp('--> Begin - Principal Component analysis')
% [vect_prop y_red val_prop] = princomp(y);
Rmat = Y-(mean(Y,2)*ones(1,P));
Rmat = Rmat*Rmat';

OPTIONS.disp = 0; % diagnostic information display level
OPTIONS.maxit = 600; % maximum number of iterations
[vect_prop D] = eigs(Rmat,L_red,'LM',OPTIONS) ;
clear D
D = eye(L_red);
vect_prop = vect_prop';
disp('--> End - Principal Component analysis')

% first L_red eigenvectors
V = vect_prop(1:L_red,:);

% first L_red  eigenvalues
V_inv = pinv(V);
Y_bar = mean(Y,2);

% projector
matP =  D^(-1/2)*V;

% inverse projector
matU = V_inv*D^(1/2);

% projecting
y_proj = matP*(Y -Y_bar*ones(1,P));

switch method
    case 'nfindr'
%            keyboard
        % NFINDR
        disp('--> Begin - N-FINDR')
        [endm_proj critere_opt] = nfindr(y_proj');
        disp('--> End - N-FINDR')
          
        % in hyperspectral space
        endm = matU*endm_proj+Y_bar*ones(1,R);
        

    case 'vca'
        
        % VCA
        disp('--> Begin - VCA')
        [endm] = vca(Y,'Endmembers',R,'verbose','off');
        disp('--> End - VCA')
        % in projected space
        endm_proj = matP*(endm -Y_bar*ones(1,R));
        
        
    case 'from file'        
       
        global handles

        [FileName,PathName] = uigetfile({'*.mat';'*.txt'},'Select a file for endmembers'); % Choisir un fichier, format filtré par la commande

        if (FileName == 0) %annulation de la commande

            return;

        else

            if FileName(1,(end-2):end)=='mat'
                load([PathName FileName],'endm');
                endm_loaded=endm;
            end

            if FileName(1,(end-2):end)=='txt'
                endm_loaded=load([PathName FileName]);
            end

        disp([FileName ' loaded'])


        end
        
        endm=endm_loaded(:,1:R);
        endm_proj = matP*(endm -Y_bar*ones(1,R));
        
        
    case 'Sources selection'  
        
        endm=sources;
        endm_proj = matP*(endm -Y_bar*ones(1,R));
        
end