function parfevalNeedleDemo
% Copyright 2013 The MathWorks, Inc.
% How many searchs to create in one go 
N = 30;
% The target of the search we are carrying out
T = 0.9999997;
% Initial N searchs for the pool to work on
f = nMakeSearchs;
for ii = 1:1000
    fprintf('Number of futures: %d, iteration: %d\n',numel(f),ii);
    % Add another N searches to the work load on the pool
    f = [f nMakeSearchs]; %#ok<AGROW>
    % logical array to track the completed searches
    complete = false(size(f));
    % Loop waiting for any N of the 2*N searches to complete
    for jj = 1:N
        [index, found] = fetchNext(f);
        % If the search finds a result then we can cancel 
        % all the others and return
        if found
            cancel(f)
            return
        end
        % Mark this particular search as complete 
        % so that we can remove it
        complete(index) =  true;
    end
    % Remove any searches that have returned an answer
    f = f(~complete);
end

    % function to make a block of searches in one go and
    % return an array of futures
    function f = nMakeSearchs
        for i = N:-1:1
            f(i) = parfeval(@iSearch, 1, T);
        end
    end

end


function found = iSearch(T)
found = any(any(rand(100) > T));
end