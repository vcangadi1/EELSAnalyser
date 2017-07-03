function constantDemo

D = rand(1e7, 1); %#ok<*PFBNS>
tic
for i = 1:20
    a = 0;
    parfor j = 1:60
        a = a + sum(D);
    end
end
toc


tic
D = parallel.pool.Constant(D);
for i = 1:20
    b = 0;
    parfor j = 1:60
        b = b + sum(D.Value);
    end
end
toc

assert(a-b < eps(1e4));