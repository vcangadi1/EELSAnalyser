
function [eels_edges, EELS_snr] = findedge_cluster(EELS, w)

[Z,elname,eledge,edge_shape] = edge_database('edges_database_1.xlsx',1,1,20);

%poolobj = gcp('nocreate');
%if(poolobj.NumWorkers<=0)
%    parpool('local');
%end

%EELS = readEELSdata('EELS Spectrum Image 16x16 1s 0.5eV 78offset.dm3');
%EELS.energy_loss_axis = EELS.energy_loss_axis-5;

%load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image small disp0.1offset80time0.5s.mat')
%load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp0.5offset250time0.5s.mat')
%load('C:\Users\elp13va.VIE\Dropbox\MATLAB\Ge-basedSolarCell_24082015\artifact_removed_EELS Spectrum Image disp1offset950time2s.mat')

%I = squeeze(EELS.SImage(:,:,1));
%I(I(:)<2000) = 0;
%I(I(:)>=2000) = 1;
%EELS.SImage = EELS.SImage .* repmat(I,1,1,EELS.SI_z);

%plotEELS(EELS);
if nargin < 2
    w = 25;
end

EELS_snr = zeros(EELS.SI_x,EELS.SI_y);
for m = EELS.SI_x:-1:1
    for n = EELS.SI_y:-1:1
        S = squeeze(EELS.SImage(m,n,:));
        %S = medfilt1(S,10,'truncate');
        %S = exp(medfilt1(log(abs(S)),10,'truncate'));
        %S = exp(medfilt1(log(abs(S)),10,'truncate'));
        
        %S = hampel(S,17);
        
        %cA = dwt(S,'sym4');
        %ccA = dwt(cA,'sym4');
        %rrcA = idwt(ccA,[],'sym4');
        %S = idwt(rrcA,[],'sym4');
        %S = S(1:end-2);
        
        EELS_snr(m,n) = snr(S,squeeze(EELS.SImage(m,n,:))-S);
        
        %plot(EELS.energy_loss_axis,squeeze(EELS.SImage(m,n,:)));
        %hold on
        %plot(EELS.energy_loss_axis,S);
        %hold off

        g = gradient(S);

        ang = atan(g)*180/pi;

        ang(ang<0) = NaN;

        for i = 1:length(S)-w
            edge(i) = edgedetect(i,i+w,ang);
        end
        
        edge = edge(edge>0);

        if ~isempty(edge)
            %k = 1;
            E = [];
            minE = S(edge(1));
            for i=1:length(edge)
                if(S(edge(i))<=minE)
                    %E(k) = edge(i);
                    E = [E edge(i)];
                    minE = S(edge(i));
                    %k = k+1;
                end
            end
            
            for i = 1:length(E)
                [~,idx(i)] = min(abs(eledge-EELS.energy_loss_axis(E(i))));
            end
            
            eels_edges(m,n,1:length(eledge(unique(idx),:))) = eledge(unique(idx),:);
        else
            eels_edges(m,n,:)=NaN;
        end
    end
end

nbins = 100;
eels_edges(eels_edges(:)<EELS.energy_loss_axis(1)) = NaN;
e = EELSmatrix(eels_edges);
figure1 = figure;
axes1 = axes('Parent',figure1);
histogram(reshape(e,1,size(e,1)*size(e,2)),nbins);
xlabel('Energy-loss (eV)','FontWeight','bold');
ylabel('pixels','FontWeight','bold');
box(axes1,'on');
set(axes1,'FontSize',12,'FontWeight','bold');

%disp(elname(unique(idx),:))
%disp(eledge(unique(idx),:))
%t = table(Z,elname,eledge,edge_shape);
%disp(t)