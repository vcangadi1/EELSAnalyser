function [Eg, Ag, Power, Const, Sqrtfun, gofg] = sqrt_fit(energy_loss_axis, low_loss_spectrum, fit_type)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input :
%        energy_loss_axis - low loss energy-loss axis
%       low_loss_spectrum - Zero-loss and plasmon peaks (low loss spectrum)
%
% Output:
%                      Eg - Bandgap value in $eV$.
%                      Ag - Amplitude (scaling) of Lorentzian fitting
%                   Power - Exponent of $(E-Eg)$
%                 Sqrtfun - $Sqrtfun(E,Eg)$ Sqare-root function,
%                           where E = energy loss axis
%                    gofg - Goodness of fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Copy input variables to local variables

if nargin < 3
    fit_type = '2';
end

x = energy_loss_axis;
y = low_loss_spectrum;

%% Fit a Square-root function

Opt{1,1} = 'Lower';
Opt{1,2} = 'Upper';
Opt{1,3} = 'StartPoint';

switch fit_type
    
    case '2'
        fit_type = 'a*(x-b).^0.5';
        Opt{2,1} = [1,0];
        Opt{2,2} = [1E10,6];
        Opt{2,3} = [3000,3.4];
        [f,gofg] = fit(x,y,fit_type,'Lower',[1,0],'Upper',[1E10,6],'StartPoint',[3000,3.4]);
        Power = 0.5;
        Const = 0;
    case '2c'
        fit_type = 'a*(x-b).^0.5+d';
        Opt{2,1} = [1,0,0];
        Opt{2,2} = [1E10,6,1E10];
        Opt{2,3} = [3000,3.4,1];        
        Power = 0.5;
        Const = NaN;
    case '3'
        fit_type = 'a*(x-b).^c';
        Opt{2,1} = [1,0,0.1];
        Opt{2,2} = [1E10,6,0.8];
        Opt{2,3} = [3000,3.4,0.5];
        Power = NaN;
        Const = 0;
    case '3c'
        fit_type = 'a*(x-b).^c+d';
        Opt{2,1} = [1,0,0,0];
        Opt{2,2} = [1E10,6,1,1E10];
        Opt{2,3} = [3000,3.4,0.5,1];
        Power = NaN;
        Const = NaN;
    otherwise
        error('fit_type must be one of these values ''2'',''2c'',''3'',''3c''');
end


%[f,gofg] = fit(x,y,fit_type,Opt);

Eg = f.b;
Ag = f.a;
if isnan(Power)
    Power = f.c;
end
if isnan(Const)
    Const = f.d;
end
Sqrtfun = @(E,Eg,Power,Const) (E-Eg).^Power+Const;
