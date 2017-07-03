function ll = low_loss(energy_loss_axis, Ep, Wp, TOL, W0)
%l = EELS.energy_loss_axis;
%Ep = 21;
%TOL = tbylambda(l,Z);

l = energy_loss_axis;

ll = zeros(size(l));

N = floor(l(end)/Ep);
%N = 5;


%%
if W0 == 0 && Wp == 0
    ii = (0:N)';
    nEp = ii*Ep;
    
    [~,pos] = arrayfun(@(nEp) min(abs(l-nEp)),nEp);
    
    ll(pos) = (TOL.^ii).*(1./factorial(ii)).*exp(-TOL);
else
    for ii = 0:N
        temp_ll = zeros(size(l));
        [~,pos] = min(abs(l-ii*Ep));
        Pn = (TOL.^ii).*(1./factorial(ii)).*exp(-TOL);
        d = mean(diff(l));
        temp_ll(pos+1) = Pn/d;
        %figure(1)
        %plotEELS(l,temp_ll)
        %hold on
        if ii == 0
            if W0 > 0
                ll = plural_scattering(temp_ll,normpdf(l,0,W0/(2*sqrt(2*log(2)))));
            elseif W0 == 0
                ll = temp_ll;
            elseif W0 < 0
                error('FWHM of zero loss peak should be >= 0eV');
            end
            %figure(2)
            %plotEELS(l,ll)
            %hold on
        else
            lpEp = plural_scattering(temp_ll,lorentz(l,Ep,Wp));
            %figure(2)
            %plotEELS(l,lpEp)
            %hold on
            ll = ll + lpEp;
        end
    end
end