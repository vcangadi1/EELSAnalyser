%myfunction.m

function yerr = myfunction(a,data)
x = data(:,1);
y = data(:,2);

yfit(a(1)*(1-exp(-a(2)*x)));
yerr = (y-yfit);            %the objective is to minimise the sum of the squares of this error