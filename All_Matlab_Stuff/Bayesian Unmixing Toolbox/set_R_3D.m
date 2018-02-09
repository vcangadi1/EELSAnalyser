
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DEBUT DE LA SOUS-FONCTION plot_off%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function set_R_3D(obj,event)

% Définition de Nbi et handles comme variables globales dans chaque fonction et sous-fonction
% handles : identifiants des objets graphiques (vecteur)
global handles R

% valeur de R
R=get(handles(32),'string');
R=str2num(R);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIN DE LA SOUS-FONCTION plot_off%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%