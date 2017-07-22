function rEELS = change_dispersion(EELS, new_dispersion)

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%         EELS        - EELS structure
%         byfactor    - expected dispersion / original dispersion
% Output:
%         rEELS       - resample EELS structure

%%

rEELS = EELS;

byfactor = round(new_dispersion/EELS.dispersion,1);

rEELS.SI_z = uint32(round(EELS.SI_z./byfactor));
rEELS.SImage = zeros(EELS.SI_x, EELS.SI_y, rEELS.SI_z);

if byfactor > 1
    %[q,p] = numden(sym(byfactor));
    [q,fs] = numden(sym(byfactor));
    
    for ii = EELS.SI_x:-1:1
        for jj = EELS.SI_y:-1:1
            %rEELS.SImage(ii,jj,:) = resample(squeeze(EELS.SImage(ii,jj,:)),double(p),double(q));
            [rEELS.SImage(ii,jj,:),rEELS.energy_loss_axis] = resample(squeeze(EELS.SImage(ii,jj,:)),EELS.energy_loss_axis,double(fs),1,double(q),'spline');
        end
    end
    
    rEELS.dispersion = EELS.dispersion*byfactor;
else
    [q,p] = numden(sym(byfactor));
    
    for ii = EELS.SI_x:-1:1
        for jj = EELS.SI_y:-1:1
            rEELS.SImage(ii,jj,:) = resample(squeeze(EELS.SImage(ii,jj,:)),double(p),double(q));
        end
    end
    
    rEELS.dispersion = EELS.dispersion*byfactor;
    rEELS.energy_loss_axis = resample(EELS.energy_loss_axis,double(p),double(q));
end

clc;
fprintf('dispersion is changed to %f eV/channel\n', rEELS.dispersion);
strucdisp(rEELS)