function [fitresult, gof] = Polynomial_8_fit(EELS_spectrum)
%CREATEFIT1(EELS_SPECTRUM)
%  Create a fit.
%
%  Data for 'Polynomial_8_fit' fit:
%      Y Output: EELS_spectrum
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 16-Jul-2014 16:49:27


%% Fit: 'Polynomial_8_fit'.
max_eels = max(EELS_spectrum);
[xData, yData] = prepareCurveData( [], EELS_spectrum./max_eels);

% Set up fittype and options.
ft = fittype( 'poly8' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf];
opts.Robust = 'LAR';
opts.Upper = [Inf Inf Inf Inf Inf Inf Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Create a figure for the plots.
figure( 'Name', 'Polynomial_8_fit' );

% Plot fit with data.
subplot( 2, 1, 1 );
h = plot( fitresult, xData, yData );
legend( h, 'EELS_spectrum', 'Polynomial_8_fit', 'Location', 'NorthEast' );
% Label axes
ylabel( 'EELS_spectrum' );
grid on

% Plot residuals.
subplot( 2, 1, 2 );
h = plot( fitresult, xData, yData, 'residuals' );
legend( h, 'Residuals', 'Zero Line', 'Location', 'NorthEast' );
% Label axes
ylabel( 'EELS_spectrum' );
grid on