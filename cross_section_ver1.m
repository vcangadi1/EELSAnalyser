function CS = cross_section_ver1(Z, edge_onset_channel, edge_type, E0, beta, delta, energy_loss_axis)

%%

e = round(edge_onset_channel);
l = energy_loss_axis;
d = mean(diff(l));
nl = length(energy_loss_axis);

%if nl-e>200
%    rng = (1:d:200)';
%else
    rng = (1:d:nl-e)';
%end
CS = zeros(1024,1);
%%
switch edge_type
    case {'L23','L','L3','L2','l23','l','l3','l2'}
        CS = [zeros(e,1); gradient(arrayfun(@(ii) Sigmal3(Z,ii,E0,beta), rng))];
        CS = CS(1:e+round(delta));
        temp = 1;
    case {'K','k'}
        CS = [zeros(e,1); gradient(arrayfun(@(ii) Sigmak3(Z,l(e),ii,E0,beta), rng))];
        CS = CS(1:e+round(delta));
        temp =1;
    case {'M','M45','M4','M5'}
        rng = (1:d:delta)';
        tCS = [zeros(e,1); gradient(arrayfun(@(ii) Sigpar(Z,ii,'M45',E0,beta)/10^-24, rng))];
        if length(rng)>100
            eCS = feval(Power_law(l(e+100:e+150),tCS(e+100:e+150)),l(e+110:end));
            CS(1:end) = [tCS(1:e+109);eCS];
        end
        temp = 0;
end

%%
if temp == 1 && length(rng)>100
    eCS = feval(Power_law(l(e+50:e+100),CS(e+50:e+100)),l(e+50:end));
    CS(e+50:end) = eCS;
end
%%
%{
jj = 10;
while e+jj > nl
    jj = jj - 1;
end

CS(e+jj:end) = medfilt1(CS(e+jj:end),10,'omitnan','truncate');
    
%}
%%
%plotEELS(energy_loss_axis(1:length(CS)),CS)