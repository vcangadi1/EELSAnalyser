function estimate_2D(obj,event)


global Y geo_method est_method booleen bool_plot plot_state handles Nmc Nbi data FileName R R_save current_plot wave plot_color M_est T_MMSE A_MMSE A_est T_est endm matP matU Y_bar endm_proj y_proj Tsigma2r L_red Tab_A Tab_T Tab_sigma2 P L



clc

%% Error test




        [i j]=size(data);

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
%% BAYESIAN LINEAR UNMIXING
Y=data;

[P L] = size(Y);        % Y:data to analyze
wave=1:L;
bool_plot = booleen;

% initialization method

Tsigma2r = ones(R,1)*1e1;

Y = Y'; % !!!

% dimension of space of interest
L_red = (R-1);

% (crude) geometrical estimation
disp('GEOMETRICAL ENDMEMBER EXTRACTION')
[endm matP matU Y_bar endm_proj y_proj] = find_endm(Y,R,geo_method);
endm = abs(endm);
save('endm','endm');

% projected endmembers
endm_proj = matP*(endm -Y_bar*ones(1,R));

% MC initialization
M_est = endm;
T_est = matP*(M_est-Y_bar*ones(1,R));

[A_est]=hyperFcls( Y,endm);

A_est = abs(pinv(M_est)*Y); %% !!
A_est = A_est./(sum(A_est,1)'*ones(1,R))';

% MC chains
Tab_A = zeros(Nmc,R,P);
Tab_T = zeros(Nmc,L_red,R);
Tab_sigma2 = zeros(Nmc,1);


%% plot
est_method=geo_method;
current_plot=0;
default_color=[1 0 0;0 0.5 0;0 0 1;1 0.33 0;1 0 1;0 1 1;0 0 0];
plot_color=[0 0 0];

for i=1:(floor(R/7)+1)
    plot_color=[plot_color;default_color];
end

plot_color=plot_color(2:end,1:end);



if bool_plot

set(handles(996),'visible','on')

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
        
end

R_save=R;

set(handles(6),'visible','on')


