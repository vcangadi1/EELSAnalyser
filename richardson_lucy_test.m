clc
close all
clear
%%
load('Ge-basedSolarCell_24082015/artifact_removed_EELS Spectrum Image disp0.2offset0time0.1s.mat')

llow = EELS.energy_loss_axis';
%Z = EELS_sum_spectrum(EELS);
Z = normpdf(llow,0,3);

Zn = Z/sum(Z);

lcor = llow + 200;

E = create_ionization_edge(200,100,0.01,lcor);

pE = plural_scattering(E,Zn);

%%
%A = [5 10 15 20 50 100 200 500 1000];
%A = [1,10:10:1000,1100:100:10000];
A = [1:1:10,20:10:100,200:100:1000,2000:1000:10000];
rE = zeros(1024,length(A));
res = rE;

vidObj = VideoWriter('myPeaks_residue.avi');
vidObj.Quality = 75;
vidObj.FrameRate = 50;
open(vidObj);
locs = zeros(1000,length(A));
pks = locs;
loops = length(A);
F(loops) = struct('cdata',[],'colormap',[]);
for i = 1:loops,
    rE(:,i) = lucy_richardson([llow,Zn],[lcor,pE],A(i));
    hold on
    plotEELS(lcor,E)
    res(:,i) = E-rE(:,i);
    %plotEELS(lcor,res(:,i))
    %ylim([-50 50])
    grid on
    grid minor
    drawnow
    text(floor(mean([lcor(end) lcor(1)])),floor(mean([min(pE) max(pE)])),['Iterations = ',num2str(A(i))],'FontWeight','bold');
    F(i) = getframe(gcf);
    writeVideo(vidObj, getframe(gcf));
    hold off
    %
    close all
    %
    set(gca,'nextplot','replacechildren');
    
    [p,lcs] = findpeaks(res(201:end,i),'SortStr','descend');
    
    locs(1:length(lcs),i) = lcs;
    pks(1:length(p),i) = p;
end
close all

close(vidObj);

fig = figure;
n = [10 1:loops];
movie(fig,F,n,12)


%res = rE-repmat(E,1,loops);
%%
%{
yyaxis left
hold on
plot(A,locs(1,:))
plot(A,locs(2,:))
plot(A,locs(3,:))
plot(A,locs(4,:))
yyaxis right
hold on
p1 = plot(A,pks(1,:));
p2 = plot(A,pks(2,:));
p3 = plot(A,pks(3,:));
p4 = plot(A,pks(4,:));

legend([p1 p2 p3 p4],'1st artefact','2nd artefact','3rd artefact','4th artefact')
%}