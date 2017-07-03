function [fitresult, gof] = gauss_three_peak(x, y)
%CREATEFIT1(X,Y)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 25-Apr-2016 23:57:06


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'a1*exp(-((x-b1)/c1)^2) + a2*exp(-((x-b2)/c2)^2) + a3*exp(-((x-b3)/c3)^2)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [1 1 1 x(1) x(1) 19.3 0.1 0.1 0.1];
opts.StartPoint = [0.795199901137063 0.186872604554379 0.489764395788231 0.445586200710899 0.646313010111265 0.709364830858073 0.754686681982361 0.276025076998578 0.679702676853675];
opts.Upper = [max(y) max(y) max(y) 19.3 x(end) x(end) inf inf inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

%{
% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel x
ylabel y
grid on
%}

