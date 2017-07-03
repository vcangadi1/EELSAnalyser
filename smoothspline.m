function [fitresult, gof] = smoothspline(x, y)
%CREATEFIT1(x,Y)
%  Create a fit.
%
%  Data for 'Smoothing Spline' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 10-Sep-2014 14:06:32


%% Fit: 'Smoothing Spline'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( ft );
opts.SmoothingParam = 0.95;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );