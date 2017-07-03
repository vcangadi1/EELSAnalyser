function hS = higher_grid_middle_smooth(S)

if isrow(S)
    S = S';
end

ex = length(S)/2;

hS = [zeros(1,ex)';S;zeros(1,ex)'];


%% Extend left tail using exponential

x = (ex+1:ex+1+30)';
y = flipud(hS(ex+1:ex+1+30));
f = flipud(feval(fit(x,y,'exp1'),(1:2*ex+30)'));


hS = [f(1:ex);S;zeros(1,ex)'];

%% Extend roght tail with Gaussian

%x = (3*ex-50:3*ex+50)';
%y = hS(3*ex-50:3*ex+50);

%f = flipud(feval(fit(x,y,'gauss1'),(1:2048-(1024+512-50))'));


%hS = [hS(1:1024+512-50);f];


%% Taper the edge

w = 200;

taperSigma = 40;
f = conv(hS,normpdf(-w/2:w/2,0,taperSigma)','same');

hS = [hS(1:3*ex-w/2);f(3*ex-(w/2-1):end)];

