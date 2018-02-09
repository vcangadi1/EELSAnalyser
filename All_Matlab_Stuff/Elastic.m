%% Elastic Net / Ridge Regression example
% Copyright (c) 2011, The MathWorks, Inc.

%% Introduction to using Ridge Regression 
% This demo explains how to start using the lasso function introduced
% in R2011b. It is motivated by example 4 in Tibshirani’s original paper
% on the lasso. 

% Tibshirani, R. (1996). Regression shrinkage and selection via the lasso. 
% J. Royal. Statist. Soc B., Vol. 58, No. 1, pages 267-288).

% The data set that we’re working with in this demo is a wide
% dataset with correlated variables. This data set includes 8 different
% variables and only 20 observations. 5 out of the 8 variables have
% coefficients of zero. These variables have zero impact on the model. The
% other three variables have non negative values and impact the model

%% Clean up workspace and set random seed

clear all
clc

% Set the random number stream
rng(1981);

%% Creating data set with specific characteristics

Z12 = randn(100,40);
Z1 = randn(100,1);
X = Z12 + repmat(Z1, 1,40);

B0 = zeros(10,1);
B1 = ones(10,1);

Beta = 2 * vertcat(B0,B1,B0,B1);
ds = dataset(Beta);

Y = X * Beta + 15*randn(100,1);

%% Use linear regression to fit the model 

b = regress(Y,X);
ds.Linear = b;
disp(ds);

%% Use a lasso to fit the model

[B Stats] = lasso(X,Y, 'Alpha', .5, 'CV', 5);


%% Create a plot showing MSE versus lamba

lassoPlot(B, Stats, 'PlotType', 'CV')

%%  Create a plot showing coefficient values versus L1 norm

lassoPlot(B, Stats)

%% Identify a reasonable set of lasso coefficients

% View the regression coefficients associated with Index1SE

ds.Lasso = B(:,Stats.Index1SE);
disp(ds)

 %%  Run a Simulation

% Preallocate some variables
MSE = zeros(100,1);
mse = zeros(100,1);
Coeff_Num = zeros(100,1);
Betas = zeros(40,100);
cv_Reg_MSE = zeros(1,100);

matlabpool open

parfor i = 1  : 100
    
    Z12 = randn(100,40);
    Z1 = randn(100,1);
    X = Z12 + repmat(Z1, 1,40);
    Y = X * Beta + 15*randn(100,1);
    
    [B Stats] = lasso(X,Y, 'Alpha', .5, 'CV',  5);
    Shrink = Stats.Index1SE -  ceil((Stats.Index1SE - Stats.IndexMinMSE)/2);
    Betas(:,i) = B(:,Shrink) > 0;
    Coeff_Num(i) = sum(B(:,Shrink) > 0);
    MSE(i) = Stats.MSE(:, Shrink);
    
    regf = @(XTRAIN, ytrain, XTEST)(XTEST*regress(ytrain,XTRAIN));
    cv_Reg_MSE(i) = crossval('mse',X,Y,'predfun',regf, 'kfold', 5);
        
end

matlabpool close

Number_Lasso_Coefficients = mean(Coeff_Num);
disp(Number_Lasso_Coefficients)

MSE_Ratio = median(cv_Reg_MSE)/median(MSE);
disp(MSE_Ratio)





