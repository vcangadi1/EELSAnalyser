function Bayesian_unmixing_2D(obj,event)

global Y geo_method est_method est_method_save booleen bool_plot plot_state handles Nmc Nbi data FileName R R_save current_plot wave plot_color M_est T_MMSE A_MMSE A_est T_est endm matP matU Y_bar endm_proj y_proj Tsigma2r L_red Tab_A Tab_T Tab_sigma2 P L


    
%% Error test

if strcmp(est_method,'MMSE')
    est_method=est_method_save;
else
    est_method_save=est_method;
end

R=R_save;
set(handles(28),'string',int2str(R))

set(handles(996),'visible','off')
set(handles(997),'visible','off')
set(handles(998),'visible','off')


clear i j

        subplot(1,7,2:7)
        set(gca,'color',[0.75 0.75 0.75])
        set(gca,'Xcolor',[0.75 0.75 0.75])
        set(gca,'Ycolor',[0.75 0.75 0.75])


current_plot=0;
bool_plot=booleen;

%% MCMC algorithm
waitbar_flag = waitbar(0,'Push cancel button to stop Monte Carlo iterations','Name','Bayesian linear unmixing','CreateCancelBtn','waitbar_stop');
global run_simulation, run_simulation = 1;
m_compt = 1;
disp('MONTE CARLO ITERATIONS')
while m_compt<Nmc && run_simulation
    waitbar(m_compt/Nmc,waitbar_flag);

    set(handles(10),'string',int2str(m_compt));
    % sampling noise variance
    sigma2_est = sample_sigma2(A_est,M_est,Y);
    
    % sampling abundance vectors
    A_est = sample_A(Y',M_est',A_est',R,P,sigma2_est)';


    % sampling endmember projections
    [T_est M_est] = sample_T_const(A_est,M_est,T_est,sigma2_est,Tsigma2r,matU,Y_bar,Y,endm_proj,bool_plot,y_proj);  
    
    % saving the MC chains 
    Tab_A(m_compt,:,:) = A_est;
    Tab_T(m_compt,:,:) = T_est;
    Tab_sigma2(m_compt,:) = sigma2_est;  
      
    % plot   
    if bool_plot
        % estimated endmembers
        figure(1)
        subplot(1,7,2:4)      
        for i=1:R
            plot(M_est(1:end,i),'color',plot_color(i,1:3));
            hold on
        end
        hold off
        title('Estimated endmembers')
        drawnow
        
        % estimated projected endmembers   
        subplot(1,7,5:7) 
        scatter(y_proj(1,:),y_proj(2,:),'k.')
        hold on
        for r=1:R
            scatter(endm_proj(1,r),endm_proj(2,r),'bo');
            scatter(T_est(1,r),T_est(2,r),'g*');           
        end
        hold off
        

switch est_method
    case 'from file'
        legend('Pixels','Select. Endm. (geo)','Current Est. Endm.')
        title('Scatter plot in 2 spectral bands')
        drawnow
    case 'vca'
        legend('Pixels','Est. Endm. (geo)','Current Est. Endm.')
        title('Scatter plot in 2 spectral bands')
        drawnow
    case 'nfindr'
        legend('Pixels','Est. Endm. (geo)','Current Est. Endm.')
        title('Scatter plot in 2 spectral bands')
        drawnow
end

                                
    end
    
    m_compt = m_compt + 1;
    
end
%close;

if run_simulation; delete(waitbar_flag); end
Nmc = m_compt;
disp('END')


%% COMPUTATION of MMSE ESTIMATES
%Nbi = floor(Nmc/3);     %temps de chauffe
A_est = reshape(mean(Tab_A((Nbi+1):Nmc-1,:,:),1),R,P);
T_MMSE = reshape(mean(Tab_T((Nbi+1):Nmc-1,:,:),1),R-1,R);
M_est = matU*T_MMSE+Y_bar*ones(1,R);

set(handles(10),'string',int2str(Nmc));     %on actualise Nmc si on a arrêté prématurément



%% Plot
set(handles(996),'visible','on')
est_method='MMSE';

        if R>=3
            subplot(2,7,2:3)
            plot(wave,M_est(1:end,3*current_plot+1),'color',plot_color(3*current_plot+1,1:3))
            title([(est_method) ' estimates of the endmembers'])
            subplot(2,7,4:5)
            plot(wave,M_est(1:end,3*current_plot+2),'color',plot_color(3*current_plot+2,1:3))
            title([(est_method) ' estimates of the endmembers'])
            subplot(2,7,6:7)
            plot(wave,M_est(1:end,3*current_plot+3),'color',plot_color(3*current_plot+3,1:3))
            title([(est_method) ' estimates of the endmembers'])

            subplot(2,7,9:10)
            plot(A_est(3*current_plot+1,1:end)','color',plot_color(3*current_plot+1,1:3))
            title([(est_method) ' estimates of the abundance'])
            subplot(2,7,11:12)
            plot(A_est(3*current_plot+2,1:end)','color',plot_color(3*current_plot+2,1:3))
            title([(est_method) ' estimates of the abundance'])
            subplot(2,7,13:14)
            plot(A_est(3*current_plot+3,1:end)','color',plot_color(3*current_plot+3,1:3))
            title([(est_method) ' estimates of the abundance'])
            hold off
            drawnow
        end

        if R>3
            disp('More spectra to display')
            set(handles(996),'string',[int2str(current_plot+1) '/' int2str(floor((R-0.1)/3)+1)])
            set(handles(997),'visible','on')
            set(handles(998),'visible','on')
        
        end