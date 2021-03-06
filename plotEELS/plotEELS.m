function varargout = plotEELS(varargin)
% Input : If only one input is present then it is EELS data structure
%         If two inout present then they are e_loss and spectrum
% Output : h - Figure handle

%% Check for number of
if(nargin<2)
    EELS = varargin{1};
    % Check if EELS is an Image
    if(isfield(EELS,'Image'))
        h = imshow(EELS.Image,[min(EELS.Image(:)) max(EELS.Image(:))]);
        ax = get(h,'Parent');
        if isfield(EELS,'mag')
            if EELS.mag > 1000
                title(['Image size = ',num2str(EELS.Image_x),' x ',num2str(EELS.Image_y),' pixel, ',...
                    'Step size = ',num2str(sprintf('%.2f',EELS.scale.x)),EELS.scale.xunit,', ',...
                    'Mag = ',num2str(EELS.mag/1000),'k'],...
                    'FontWeight','bold',...
                    'FontSize',14);
            else
                title(['Image size = ',num2str(EELS.Image_x),' x ',num2str(EELS.Image_y),' pixel, ',...
                    'Step size = ',num2str(sprintf('%.2f',EELS.scale.x)),EELS.scale.xunit,', ',...
                    'Mag = ',num2str(EELS.mag)],...
                    'FontWeight','bold',...
                    'FontSize',14);
            end
        else
            title(['Image size = ',num2str(EELS.Image_x),' x ',num2str(EELS.Image_y),' pixel, ',...
                'Step size = ',num2str(sprintf('%.2f',EELS.scale.x)),EELS.scale.xunit,', '],...
                'FontWeight','bold',...
                'FontSize',14);
        end
        if((EELS.Image_y*EELS.scale.y > 1000) && strcmp(EELS.scale.yunit,'nm'))
            xlabel(['x-axis (',num2str(sprintf('%.2f',(EELS.Image_y*EELS.scale.y)/1000)),'\mum', ')'],...
                'FontWeight','bold',...
                'FontSize',14);
            plot_label_FOV(ax,(EELS.Image_y*EELS.scale.y)/1000,'micro',EELS.Image_x,EELS.Image_y);
        else
            xlabel(['x-axis (',num2str(sprintf('%.2f',EELS.Image_y*EELS.scale.y)),EELS.scale.yunit, ')'],...
                'FontWeight','bold',...
                'FontSize',14);
            plot_label_FOV(ax,EELS.Image_y*EELS.scale.y,EELS.scale.yunit,EELS.Image_x,EELS.Image_y);
        end
        if((EELS.Image_x*EELS.scale.x > 1000) && strcmp(EELS.scale.xunit,'nm'))
            ylabel(['y-axis (',num2str(sprintf('%.2f',(EELS.Image_x*EELS.scale.x)/1000)),'\mum', ')'],...
                'FontWeight','bold',...
                'FontSize',14);
        else
            ylabel(['y-axis (',num2str(sprintf('%.2f',EELS.Image_x*EELS.scale.x)),EELS.scale.xunit, ')'],...
                'FontWeight','bold',...
                'FontSize',14);
        end
        c = colorbar('FontWeight','bold',...
            'FontSize',14);
        c.Label.String = 'Intensity';
        axis image
        
        % Check if EELS is an SImage
    elseif(isfield(EELS,'SImage'))
        h = plot_EELS(EELS); % Call GUI (plot_EELS.m)
        
        % Finally check if it is a single spectrum
    elseif(isfield(EELS,'spectrum'))
        h = plot(EELS.energy_loss_axis,EELS.spectrum,...
            'LineWidth',2);
        title(['Dispersion = ',num2str(EELS.dispersion),'eV/channel'],...
            'FontWeight','bold',...
            'FontSize',14);
        xlabel('Energy-loss (eV)',...
            'FontWeight','bold',...
            'FontSize',14);
        ylabel('Count',...
            'FontWeight','bold',...
            'FontSize',14);
        ax = gca;
        ax.FontWeight = 'bold';
        ax.FontSize = 14;
        grid on
        grid minor
        hold on
    else
        warning('No spectrum input is passed');
    end
elseif nargin<3
    if strcmpi(varargin{2},'map')
        if ~islogical(varargin{1})
            I = varargin{1};
        else
            I = varargin{1}*100;
        end
        h = imagesc(I,[min(I(:)) max(I(:))]);
        colormap gray
        axis image
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        if ~islogical(varargin{1})
            c = colorbar('FontWeight','bold',...
                'FontSize',14);
            c.Label.String = 'Intensity';
            title(['Map (',num2str(size(I,1)),'X',num2str(size(I,2)),')'],...
                'FontWeight','bold',...
                'FontSize',14);
        else
            title(['Binary Image (',num2str(size(I,1)),'X',num2str(size(I,2)),')'],...
                'FontWeight','bold',...
                'FontSize',14);
        end
    elseif strcmpi(varargin{2},'STEM')
        EELS = varargin{1};
        I = sum(EELS.SImage, 3);
        h = imagesc(I,[min(I(:)) max(I(:))]);
        ax = get(h,'Parent');
        colormap gray
        % label spectrum image
        if((EELS.SI_y*EELS.step_size.y > 1000) && strcmp(EELS.step_size.yunit,'nm'))
            xlabel(['Columns (',num2str(sprintf('%.2f',(EELS.SI_y*EELS.step_size.y)/1000)),'\mum)'],...
                'FontWeight','bold',...
                'FontSize',14);
            plot_label_FOV(ax,(EELS.SI_y*EELS.step_size.y)/1000,'micro',EELS.SI_x,EELS.SI_y);
        else
            xlabel(['Columns (',num2str(sprintf('%.2f',EELS.SI_y*EELS.step_size.y)),EELS.step_size.yunit,')'],...
                'FontWeight','bold',...
                'FontSize',14);
            plot_label_FOV(ax,EELS.SI_y*EELS.step_size.y,EELS.step_size.yunit,EELS.SI_x,EELS.SI_y);
        end
        if((EELS.SI_x*EELS.step_size.x > 1000) && strcmp(EELS.step_size.xunit,'nm'))
            ylabel(['Rows (',num2str(sprintf('%.2f',(EELS.SI_x*EELS.step_size.x)/1000)),'\mum)'],...
                'FontWeight','bold',...
                'FontSize',14);
        else
            ylabel(['Rows (',num2str(sprintf('%.2f',EELS.SI_x*EELS.step_size.x)),EELS.step_size.xunit,')'],...
                'FontWeight','bold',...
                'FontSize',14);
        end
        title(['Size = ',num2str(EELS.SI_x),' x ',num2str(EELS.SI_y),' pixel'],...
            'FontWeight','bold',...
            'FontSize',14);
        c = colorbar('FontWeight','bold',...
            'FontSize',14);
        c.Label.String = 'Intensity';
        axis image
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
    else
        e_loss = varargin{1};
        spectrum = varargin{2};
        h = plot(e_loss,spectrum,...
            'LineWidth',2);
        ax = gca;
        ax.FontWeight = 'bold';
        ax.FontSize = 14;
        title(['Dispersion = ',num2str((e_loss(5)-e_loss(1))/4),'eV/channel']);
        xlabel('Energy-loss (eV)');
        ylabel('Count');
        hline(0);
        grid on
        grid minor
        hold on
    end
end
%% If output argument is present then assign figure variable to h
if(nargout ~= 0)
    varargout = {h};
end
