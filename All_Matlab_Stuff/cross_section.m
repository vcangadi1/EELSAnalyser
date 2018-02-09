function CS = cross_section(Z, edge_onset_channel, edge_type, E0_keV, beta, energy_loss_axis)
%{
Z = 65;
edge_onset_channel = 323;
edge_type = 'M45';
E0_keV = 60;
beta = 45;
energy_loss_axis = l;
%}
%%
e = round(edge_onset_channel);
l = energy_loss_axis;
d = mean(diff(l));
nl = length(energy_loss_axis);

%%

switch edge_type
    case {'L23','L','L3','L2','l23','l','l3','l2'}
        rng = (1:(nl-e))'*d;
        CS = [zeros(e+1,1); diff(arrayfun(@(ii) Sigmal3(Z,ii,E0_keV,beta), rng))];
        if e+50<nl-50
            eCS = feval(Power_law(l(e+50:e+100),CS(e+50:e+100)),l(e+50:end));
            CS(e+50:end) = eCS;
        end
    case {'K','k'}               % Works perfectly as per 11/07/2016 with disp = 2.8eV/channel
        rng = (0:nl-e)'*d;
        CS = [zeros(e,1); diff(arrayfun(@(ii) Sigmak3(Z,l(e),ii,E0_keV,beta), rng))];
        if e+50<nl-50
            eCS = feval(Power_law(l(e+50:e+100),CS(e+50:e+100)),l(e+50:end));
            CS(e+50:end) = eCS;
        end
    case {'M','M45','M4','M5'}
        rng = (0:floor(249/d))'*d;
        CS = [zeros(e,1); diff(arrayfun(@(ii) Sigpar(Z,ii,'M45',E0_keV,beta)/10^-24, rng))];
        
        if length(CS)<nl
            bg = e+floor(110/d);
            ed = e+floor(249/d);
            eCS = feval(Power_law(l(bg:ed),CS(bg:ed)),l(1:end));
            CS = [CS(1:ed); eCS(ed+1:end)];
        else
            CS = squeeze(CS(1:nl));
        end
end