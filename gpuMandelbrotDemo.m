function gpuMandelbrotDemo 
% Copyright 2013 The MathWorks, Inc.
% The values below specify a highly zoomed part of the Mandelbrot Set in
% the valley between the main cardioid and the p/q bulb to its left.  
maxIterations = 500;
gridSize = 1000;
xlim = [-0.748766713922161, -0.748766707771757];
ylim = [ 0.123640844894862,  0.123640851045266];
x = gpuArray.linspace( xlim(1), xlim(2), gridSize );
y = gpuArray.linspace( ylim(1), ylim(2), gridSize ).';
d = gpuDevice;

% ---- Using gpuArray ----

t = tic();
[xGrid,yGrid] = meshgrid( x, y );
z0 = complex( xGrid, yGrid );
count = gpuArray.ones( size(z0) );
z = z0;
for n = 1:maxIterations
    z = z.*z + z0;
    inside = abs( z )<=2;
    count = count + inside;
end
countNaive = log( count );
wait(d);
naiveTime = toc( t );

% ---- Using arrayfun ----

t = tic();
countArrayfun = arrayfun( @mandelbrotElement, x, y, maxIterations );
wait(d);
arrayfunTime = toc( t );

% Plot results
imagesc( x, y, countArrayfun )
axis image
sameAnswer = isequal(countNaive,countArrayfun);
title( sprintf( 'Naive GPU : %1.3fsecs    GPU arrayfun : %1.3fsecs   Speedup = %1.1fx  Answer equal = %d', ...
    naiveTime, arrayfunTime, naiveTime/arrayfunTime, sameAnswer ) );


function count = mandelbrotElement(x0,y0,maxIterations)
z0 = complex(x0,y0);
z = z0;
count = 0;
while (count <= maxIterations) && (abs(z) <= 2)
    count = count + 1;
    z = z*z + z0;
end
count = log(count);