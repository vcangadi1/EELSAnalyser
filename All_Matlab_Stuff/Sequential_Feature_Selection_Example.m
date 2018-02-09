%% Sequential Feature Selection example
% Copyright (c) 2011, The MathWorks, Inc.

%% Introduction to Sequential Feature Selection 
% This demo explains how to start using sequential feature selection. 
% It is motivated by example 4 in Tibshirani’s original paper on the lasso. 

% Tibshirani, R. (1996). Regression shrinkage and selection via the lasso. 
% J. Royal. Statist. Soc B., Vol. 58, No. 1, pages 267-288).

% The data set that we’re working with in this demo is a wide
% dataset with correlated variables. This data set includes 40 different
% variables with 100 observations. 20 of the 40 variables have
% coefficients of zero. These variables have zero impact on the model. The
% other 20 variables have non negative values and impact the model


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
disp(ds)

%%  Use sequential feature selection to fit the model

opts = statset('display','iter');

fun = @(x0,y0,x1,y1) norm(y1-x1*(x0\y0))^2;  % residual sum of squares
[in,history] = sequentialfs(fun,X,Y,'cv',5, 'options',opts);

%% Generate a linear regression using the optimal set of features

beta = regress(Y,X(:,in));

ds.Sequential = zeros(length(ds),1);
ds.Sequential(in) = beta

%% Run a simulation

matlabpool open 4

sumin = 0;

parfor j=1:100
    
    disp(j)
    %% Creating data set with specific characteristics
    
    Z12 = randn(100,40);
    Z1 = randn(100,1);
    X = Z12 + repmat(Z1, 1,40);
    B0 = zeros(10,1);
    B1 = ones(10,1);
    Beta = 2 * vertcat(B0,B1,B0,B1);
    Y = X * Beta + 15*randn(100,1);
    
    fun = @(x0,y0,x1,y1) norm(y1-x1*(x0\y0))^2;  % residual sum of squares
    [in,history] = sequentialfs(fun,X,Y,'cv',5);
    
    sumin = in + sumin;
end

bar(sumin)

matlabpool close

