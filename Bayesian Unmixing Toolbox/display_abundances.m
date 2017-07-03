function display_abundances

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global data sources Nlines Nsamples Nbands handles bool_plot wavelength M_est A_est est_method R current_plot
global handles_subplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = (squeeze((reshape(data,Nlines*Nsamples,Nbands).'))); %informations en colonne
M_est = sources; %données rangées en colonne
A_est = hyperFcls(M,M_est);

        subplot(1,7,2:7)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])


test=get(handles(997),'visible');
[i j]=size(test);
if j==2
    set(handles(996),'visible','off')
    set(handles(997),'visible','off')
    set(handles(998),'visible','off')
end

test=get(handles(996),'visible');
[i j]=size(test);
if j==2
    set(handles(996),'visible','off')
end

clear i j



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tracé des abondances dans l'interface

%est_method=geo_method;
current_plot=0;
default_color=[1 0 0;0 0.5 0;0 0 1;1 0.33 0;1 0 1;0 1 1;0 0 0];
plot_color=[0 0 0];


for i=1:(floor(R/7)+1)
    plot_color=[plot_color;default_color];
end

plot_color=plot_color(2:end,1:end);
if bool_plot
    
    % Creation de l'objet text plot_position
    
        if R>=3
            handles_subplot(1) = subplot(2,7,2:3);
            plot(wavelength,M_est(:,3*current_plot+1),'color',plot_color(3*current_plot+1,1:3))
            %title([(est_method) ' estimates of the endmembers'])
            handles_subplot(2) = subplot(2,7,4:5);
            plot(wavelength,M_est(:,3*current_plot+2),'color',plot_color(3*current_plot+2,1:3))
            %title([(est_method) ' estimates of the endmembers'])
            handles_subplot(3) = subplot(2,7,6:7);
            plot(wavelength,M_est(:,3*current_plot+3),'color',plot_color(3*current_plot+3,1:3))
            %title([(est_method) ' estimates of the endmembers'])
            
            colormap(gray);
            handles_subplot(4) = subplot(2,7,9:10);
            imagesc(reshape(A_est(3*current_plot+1,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
            caxis([0 1]);
            %title([(est_method) ' estimates of the abundance'])
            handles_subplot(5) = subplot(2,7,11:12);
            imagesc(reshape(A_est(3*current_plot+2,:),Nlines,Nsamples));
            caxis([0 1]);
            %title([(est_method) ' estimates of the abundance'])
            handles_subplot(6) = subplot(2,7,13:14);
            imagesc(reshape(A_est(3*current_plot+3,:),Nlines,Nsamples));
            caxis([0 1]);
            %title([(est_method) ' estimates of the abundance'])
            hold off
            drawnow
        end

        if R==2
            colormap(gray);
            handles_subplot(1) = subplot(2,7,2:4);
            plot(wavelength,M_est(:,1),'b')
            %title([(est_method) ' estimates of the endmembers'])
            handles_subplot(2) = subplot(2,7,5:7);
            plot(wavelength,M_est(:,2),'r')
            %title([(est_method) ' estimates of the endmembers'])

            handles_subplot(3) = subplot(2,7,9:11);
            imagesc(reshape(A_est(1,:),Nlines,Nsamples));
            caxis([0 1]);
            %title([(est_method) ' estimates of the abundance'])
            handles_subplot(4) = subplot(2,7,12:14);
            imagesc(reshape(A_est(1,:),Nlines,Nsamples));
            caxis([0 1]);
            %title([(est_method) ' estimates of the abundance'])
            drawnow
        end

        if R>3

        set(handles(998),'visible','on'); %affichage défilement "next"
        set(handles(997),'visible','on'); %affichage défilement "previous"

        end   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles(996),'visible','on'); %affichage de la page en cours    
set(handles(996),'string',[int2str(current_plot+1) '/' int2str(floor((R-0.1)/3)+1)]); %affichage de la page courante
set(handles(49),'visible','on'); %affichage du bouton Launch Bayesian unmixing
set(handles(21),'visible','off'); %si des sources ont été chargées, on ne peux que lancer l'estimation bayésienne

end

