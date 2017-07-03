function [o1, o2] = singletonExpansionDemo()
% Copyright 2013 The MathWorks, Inc.
% Make a 3x1 and a 1x4 array
a = gpuArray.rand(3, 1);
b = gpuArray.rand(1, 4);
% Call arrayfun with singleton expansion to make a 3x4 array
o1 = arrayfun(@iSum2, a, b);

c = gpuArray.rand(1, 1, 5);
% Call arrayfun with singleton expansion to make a 3x4x5 array
o2 = arrayfun(@iSum3, a, b, c);
end

function o = iSum2(a, b)
o = a + b;
end

function o = iSum3(a, b, c)
o = a + b + c;
end