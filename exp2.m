function [fitresult, gof] = exp2(X, S)
%CREATEFIT1(X,S)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : X
%      Y Output: S
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 05-Aug-2014 20:32:17


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( X, S );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf -Inf];
opts.Robust = 'Bisquare';
opts.StartPoint = [15148.4876424463 -0.825701539135411 50632.3256654597 -0.0756406996795714];
opts.Upper = [Inf Inf Inf Inf];
opts.Normalize = 'on';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );