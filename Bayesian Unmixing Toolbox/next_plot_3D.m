function next_plot(obj,event)
global geo_method booleen plot_state handles Nmc Nbi data FileName R current_plot wavelength plot_color Nlines Nsamples Nbands

global M_est T_MMSE A_MMSE A_est est_method            % Variables à sauvegarder


% for k=1:p
%     figure;
%     colormap(gray);
%     imagesc(reshape(A_est(k,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
%     caxis([0 1]);
% end

if 3*current_plot+3>=R
    current_plot=current_plot;
else
    current_plot=current_plot+1;
end

set(handles(996),'string',[int2str(current_plot+1) '/' int2str(floor((R-0.1)/3)+1)])


if (3*current_plot+1)==R
    
    
        subplot(2,7,2:7)        
        subplot(2,7,9:14)
    
        subplot(2,7,2:3)
        plot(wavelength,M_est(1:end,3*current_plot+1),'color',plot_color(3*current_plot+1,1:3))
        title([(est_method) ' estimates of the endmembers'])
        
        colormap(gray);
        subplot(2,7,9:10)
        imagesc(reshape(A_est(3*current_plot+1,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
        caxis([0 1]);
        axis image;
        title([(est_method) ' estimates of the abundance'])
        
              

elseif (3*current_plot+2)==R
    
    
        subplot(2,7,2:7)        
        subplot(2,7,9:14)    
    
        subplot(2,7,2:3)
        plot(wavelength,M_est(1:end,3*current_plot+1),'color',plot_color(3*current_plot+1,1:3))
        title([(est_method) ' estimates of the endmembers'])
        subplot(2,7,4:5)
        plot(wavelength,M_est(1:end,3*current_plot+2),'color',plot_color(3*current_plot+2,1:3))
        title([(est_method) ' estimates of the endmembers'])
        
        colormap(gray);
        subplot(2,7,9:10)
        imagesc(reshape(A_est(3*current_plot+1,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
        caxis([0 1]);
        axis image;
        title([(est_method) ' estimates of the abundance'])
        subplot(2,7,11:12)
        imagesc(reshape(A_est(3*current_plot+2,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
        caxis([0 1]);
        axis image;
        title([(est_method) ' estimates of the abundance'])  
        

    
else
    

        
        subplot(2,7,2:3)
        plot(wavelength,M_est(1:end,3*current_plot+1),'color',plot_color(3*current_plot+1,1:3))
        title([(est_method) ' estimates of the endmembers'])
        subplot(2,7,4:5)
        plot(wavelength,M_est(1:end,3*current_plot+2),'color',plot_color(3*current_plot+2,1:3))
        title([(est_method) ' estimates of the endmembers'])
        subplot(2,7,6:7)
        plot(wavelength,M_est(1:end,3*current_plot+3),'color',plot_color(3*current_plot+3,1:3))
        title([(est_method) ' estimates of the endmembers'])

        colormap(gray);
        subplot(2,7,9:10)
        imagesc(reshape(A_est(3*current_plot+1,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
        caxis([0 1]);
        axis image;
        title([(est_method) ' estimates of the abundance'])
        subplot(2,7,11:12)
        imagesc(reshape(A_est(3*current_plot+2,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
        caxis([0 1]);
        axis image;
        title([(est_method) ' estimates of the abundance'])
        subplot(2,7,13:14)
        imagesc(reshape(A_est(3*current_plot+3,:),Nlines,Nsamples)); % à intégrer dans la fenêtre principale.
        caxis([0 1]);
        axis image;
        title([(est_method) ' estimates of the abundance'])
        hold off
        drawnow
        
end
