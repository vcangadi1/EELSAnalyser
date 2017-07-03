function [fitresult, gof] = Spline(l, S, SmoothingParam)
%CREATEFIT1(L,S)
%  Create a fit.
%
%  Data for 'Spline' fit:
%      X Input : l
%      Y Output: S
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 30-Sep-2015 18:22:19


%% Fit: 'Spline'.
[xData, yData] = prepareCurveData( l, S );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
%opts.SmoothingParam = 0.507632035372709;
if nargin<3
    opts.SmoothingParam = 2.0342550835036688E-5;
elseif SmoothingParam<=1 && SmoothingParam>=0
    opts.SmoothingParam = SmoothingParam;
else
    error('Smoothing parameter (p) should be between 0 to 1');
end

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
%figure( 'Name', 'Spline' );
%h = plot( fitresult, xData, yData );
%legend( h, 'S vs. l', 'Spline', 'Location', 'NorthEast' );
% Label axes
%xlabel l
%ylabel S
%grid on


