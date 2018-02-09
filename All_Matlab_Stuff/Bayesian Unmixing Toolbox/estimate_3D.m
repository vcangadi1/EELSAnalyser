function estimate_3D(obj,event)


global Y geo_method est_method bool_plot handles Nmc Nbi data R R_save current_plot plot_color M_est A_est T_est endm matP matU Y_bar endm_proj y_proj Tsigma2r L_red Tab_A Tab_T Tab_sigma2 P L
global Nlines Nsamples Nbands wavelength handles_subplot sources


clc

%% Error test




        [i,j]=size(data);

        if i==0
            if j==0
            disp('Error : No file to analyze')
            return
            end
        end

            if R<=2
            disp('Error : Number of sources must be greater than 3')
            return
            end
            
            if Nbi>Nmc
                disp('Nmc must be greater than Nbi')
                return
            end

        subplot(2,7,2:7)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])
        subplot(2,7,9:14)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])
        subplot(1,7,2:7)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])


test=get(handles(997),'visible');
[i,j]=size(test);
if j==2
    set(handles(996),'visible','off')
    set(handles(997),'visible','off')
    set(handles(998),'visible','off')
end

test=get(handles(996),'visible');
[i,j]=size(test);
if j==2
    set(handles(996),'visible','off')
end

clear i j
%% BAYESIAN LINEAR UNMIXING

Y = squeeze(reshape(data,Nlines*Nsamples,Nbands)); %il suffit d'appliquer main bayesian_2D au signal mis sous le bon format
[P,L] = size(Y); % Y:data to analyze


%wave=1:L; %remplacer wave par wavelength
% bool_plot = booleen;

% initialization method

Tsigma2r = ones(R,1)*1e1;

Y = Y'; % !!!

% dimension of space of interest
L_red = (R-1);

% (crude) geometrical estimation
disp('GEOMETRICAL ENDMEMBER EXTRACTION')
[endm, matP, matU, Y_bar, endm_proj, y_proj] = find_endm(Y,R,geo_method);
endm = abs(endm);
save('endm','endm');

% projected endmembers
endm_proj = matP*(endm -Y_bar*ones(1,R));

% MC initialization
M_est = endm;
T_est = matP*(M_est-Y_bar*ones(1,R));
% A_est = abs(A_est);
% A_est = A_est./(sum(A_est,1)'*ones(1,R))';

% MC chains
Tab_A = zeros(Nmc,R,P);
Tab_T = zeros(Nmc,L_red,R);
Tab_sigma2 = zeros(Nmc,1);

[A_est]=hyperFcls( Y,endm);

A_est = abs(A_est);
A_est = A_est./(sum(A_est,1)'*ones(1,R))';
  
%% plot
est_method=geo_method;
current_plot=0;
default_color=[1, 0, 0;0, 0.5, 0;0, 0, 1;1, 0.33, 0;1, 0, 1;0, 1, 1;0, 0, 0];
plot_color=[0, 0, 0];


for i=1:(floor(R/7)+1)
    plot_color=[plot_color;default_color];
end

plot_color=plot_color(2:end,1:end);

%% Tracé des abondances dans l'interface

if bool_plot

    % Creation de l'objet text plot_position
    set(handles(996),'visible','on'); %affichage de la page en cours

        if R>=3
            handles_subplot(1) = subplot(2,7,2:3);
            plot(wavelength,M_est(1:end,3*current_plot+1),'color',plot_color(3*current_plot+1,1:3))
            title([(est_method) ' estimates of the endmembers'])
            handles_subplot(2) = subplot(2,7,4:5);
            plot(wavelength,M_est(1:end,3*current_plot+2),'color',plot_color(3*current_plot+2,1:3))
            title([(est_method) ' estimates of the endmembers'])
            handles_subplot(3) = subplot(2,7,6:7);
            plot(wavelength,M_est(1:end,3*current_plot+3),'color',plot_color(3*current_plot+3,1:3))
            title([(est_method) ' estimates of the endmembers'])
            
            colormap(gray);
            handles_subplot(4) = subplot(2,7,9:10);
            imagesc(reshape(A_est(3*current_plot+1,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
            caxis([0, 1]);
            axis image;
            title([(est_method) ' estimates of the abundance'])
            handles_subplot(5) = subplot(2,7,11:12);
            imagesc(reshape(A_est(3*current_plot+2,:),Nlines,Nsamples));
            caxis([0, 1]);
            axis image;
            title([(est_method) ' estimates of the abundance'])
            handles_subplot(6) = subplot(2,7,13:14);
            imagesc(reshape(A_est(3*current_plot+3,:),Nlines,Nsamples));
            caxis([0, 1]);
            axis image;
            title([(est_method) ' estimates of the abundance'])
            hold off
            drawnow
        end

        if R==2
            colormap(gray);
            handles_subplot(1) = subplot(2,7,2:4);
            plot(wavelength,M_est(1:end,1),'b')
            title([(est_method) ' estimates of the endmembers'])
            handles_subplot(2) = subplot(2,7,5:7);
            plot(wavelength,M_est(1:end,2),'r')
            title([(est_method) ' estimates of the endmembers'])

            handles_subplot(3) = subplot(2,7,9:11);
            imagesc(reshape(A_est(1,:),Nlines,Nsamples));
            caxis([0, 1]);
            title([(est_method) ' estimates of the abundance'])
            handles_subplot(4) = subplot(2,7,12:14);
            imagesc(reshape(A_est(1,:),Nlines,Nsamples));
            caxis([0, 1]);
            title([(est_method) ' estimates of the abundance'])
            drawnow
        end

        if R>3

        set(handles(998),'visible','on'); %affichage défilement "next"
        set(handles(997),'visible','on'); %affichage défilement "previous"

        end
        
end

R_save=R;
set(handles(996),'string',[int2str(current_plot+1) '/' int2str(floor((R-0.1)/3)+1)]); %affichage de la page courante
set(handles(49),'visible','on'); %affichage du bouton Launch Bayesian unmixing





