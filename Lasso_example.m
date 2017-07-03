%% Lasso regularization example
% Copyright (c) 2011, The MathWorks, Inc.

%% Introduction to using LASSO 
% This demo explains how to start using the lasso functionality introduced
% in R2011b. It is motivated by an example in Tibshirani’s original paper
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

% Create eight X variables 
% The mean of each variable will be equal to zero
mu = [0 0 0 0 0 0 0 0];

% The variable are correlated with one another
% The covariance matrix is specified as
i = 1:8;
matrix = abs(bsxfun(@minus,i',i));
covariance = repmat(.5,8,8).^matrix;

% Use these parameters to generate a set of multivariate normal random numbers
X = mvnrnd(mu, covariance, 20);

% Create a hyperplane that describes Y = f(X)
Beta = [3; 1.5; 0; 0; 2; 0; 0; 0];
ds = dataset(Beta);

% Add in a noise vector
Y = X * Beta + 3 * randn(20,1);

%% Use linear regression to fit the model 

b = regress(Y,X);
ds.Linear = b;

%% Use a lasso to fit the model

[B Stats] = lasso(X,Y, 'CV', 5);

disp(B)
disp(Stats)

%% Create a plot showing MSE versus lamba

lassoPlot(B, Stats, 'PlotType', 'CV')

%% Identify a reasonable set of lasso coefficients

% View the regression coefficients associated with Index1SE

ds.Lasso = B(:,Stats.Index1SE);
disp(ds)

%%  Create a plot showing coefficient values versus L1 norm

lassoPlot(B, Stats)

%%  Run a Simulation

% Preallocate some variables
MSE = zeros(100,1);
mse = zeros(100,1);
Coeff_Num = zeros(100,1);
Betas = zeros(8,100);
cv_Reg_MSE = zeros(1,100);

for i = 1 : 100
    
    X = mvnrnd(mu, covariance, 20);
    Y = X * Beta + randn(20,1);
    
    [B Stats] = lasso(X,Y, 'CV', 5);
    Shrink = Stats.Index1SE -  ceil((Stats.Index1SE - Stats.IndexMinMSE)/2);
    Betas(:,i) = B(:,Shrink) > 0;
    Coeff_Num(i) = sum(B(:,Shrink) > 0);
    MSE(i) = Stats.MSE(:, Shrink);
    
    regf = @(XTRAIN, ytrain, XTEST)(XTEST*regress(ytrain,XTRAIN));
    cv_Reg_MSE(i) = crossval('mse',X,Y,'predfun',regf, 'kfold', 5);
        
end

Number_Lasso_Coefficients = mean(Coeff_Num);
disp(Number_Lasso_Coefficients)

MSE_Ratio = median(cv_Reg_MSE)/median(MSE);
disp(MSE_Ratio)





