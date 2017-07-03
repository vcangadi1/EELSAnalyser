function rE = lucy_richardson(low_loss_data, core_loss_data, iterations, IntegralOption)

%%
llow = low_loss_data(:,1);

if nargin<3
    iterations = 10;
end

if nargin<4
    Z = low_loss_data(:,2)/sum(low_loss_data(:,2));
elseif strcmpi(IntegralOption,'a0')
    Z = low_loss_data(:,2)/zero_loss_integral(low_loss_data(:,2));
elseif strcmpi(IntegralOption,'at')
    Z = low_loss_data(:,2)/sum(low_loss_data(:,2));
end

Zn = ifftshift(shift_zlp(Z,llow));

%%
lcor = core_loss_data(:,1);
pE = core_loss_data(:,2);

%% Taper the edge
%taperSigma = 10*fwhm(llow,Z)/(2*sqrt(log(4)));
%pE = edgetaper(pE,normpdf(-length(pE)/4+1:length(pE)/4-1,0,taperSigma)');

%%
if size(Zn)~=size(pE)
    Zn = ifftshift(circshift(Z,length(Z)-find(Z==max(Z))));
end

%%
rE = deconvlucy(pE, Zn, iterations);

%% Plot
%{
%figure;
hold on
plotEELS(lcor,pE)
plotEELS(lcor,rE)
hold off
legend({'Plural scattering','lucy-richardson deconv'},'FontWeight','bold');
legend boxoff
text(floor(mean([lcor(end) lcor(1)])),floor(mean([min(pE) max(pE)])),['Iterations = ',num2str(iterations)],'FontWeight','bold');
box on
%}