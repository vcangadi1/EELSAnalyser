%% All possible subset feature selection example
% Copyright (c) 2011, The MathWorks, Inc.

%% Introduction to All possible subset feature selection 
% This demo is motivated by example 1 in Tibshirani’s original paper
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
rng(1998);

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

%% Fit a traditional linear regression model

b = regress(Y,X);
ds.Linear = b;
disp(ds)

%%  Create an index for the regression subsets

index = dec2bin(1:255);
index = index == '1'

results = double(index);
results(:,9) = zeros(length(results),1);

%%  Generate the regression models

for i = 1:length(index)
    
    foo = index(i,:);
    rng(1981);
    
    regf = @(XTRAIN, YTRAIN, XTEST)(XTEST*regress(YTRAIN,XTRAIN));
    results(i,9) = crossval('mse', X(:,foo), Y,'kfold', 5, 'predfun',regf);
    
end

% Sort the outputs by MSE
index = sortrows(results, 9)

%%  Compare the results

beta = regress(Y, X(:,logical(index(1,1:8))));
Subset = zeros(8,1);
ds.Subset = Subset;
ds.Subset(logical(index(1,1:8))) = beta;
disp(ds)

%% Perform a see to see how general these results are

matlabpool open

sumin = zeros(1,8);

parfor j=1:100
    
    disp(j)
    %% Creating data set with specific characteristics
    
    mu = [0 0 0 0 0 0 0 0];
    Beta = [3; 1.5; 0; 0; 2; 0; 0; 0];
    i = 1:8;
    matrix = abs(bsxfun(@minus,i',i));
    covariance = repmat(.5,8,8).^matrix;
    X = mvnrnd(mu, covariance, 20);    
    Y = X * Beta + 3 * randn(size(X,1),1);
    
    index = dec2bin(1:255);
    index = index == '1';
    results = double(index);
    results(:,9) = zeros(length(results),1);
    
    for k = 1:length(index)
        
        foo = index(k,:);
        regf = @(XTRAIN, YTRAIN, XTEST)(XTEST*regress(YTRAIN,XTRAIN));
        results(k,9) = crossval('mse', X(:,foo), Y,'kfold', 5, 'predfun',regf);
        
    end
    
% Sort the outputs by MSE
index = sortrows(results, 9)
    
sumin = sumin + index(1,1:8);
    
end

bar(sumin)

matlabpool close

