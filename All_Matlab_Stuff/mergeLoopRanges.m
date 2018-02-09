function [N, fI, fR] = mergeLoopRanges( ranges, preserveLoopOrder )
% Copyright 2013 The MathWorks, Inc.
% Compute the total number of 1:N loops needed in the merged loop. Note
% that we use a 1:N range here so that we can undertake linear indexing
% into N-D arrays inside the merged loops.
N = prod(ranges);
% Make the 2 function handles needed to execute the iterations and reorder
% full output matricies
switch numel(ranges)
    case 2
        fI = @nGet2Iterates;
    case 3
        fI = @nGet3Iterates;
    otherwise
        fI = @nGetIterates;
end
n = numel(ranges);
out = cell(1, n);

if nargin > 1 && preserveLoopOrder
    % Use this to preserve the order of the loop, but you will require
    cpRanges = [fliplr(cumprod(ranges(end:-1:2))) 1];
    fR = @nReorderInputs;
else
    cpRanges = [1 cumprod(ranges(1:end-1))];
    fR = @nNoReorderInputs;
end

    % This function will be called for each iterate of the loop and will be
    % passed the loop iterate (which is between 1 and N). This function
    % returns the correct individual iterates for the original loop.
    function varargout = nGetIterates(x)        
        x = floor( (x-1) ./ cpRanges);
        v = rem(x, ranges) + 1;
        varargout = out;
        for ii = 1:n
            varargout{ii} = v(ii);
        end
    end

    % Optimized iterate function for a pair of loops
    function [ii, jj] = nGet2Iterates(x)        
        x = floor( (x-1) ./ cpRanges);
        v = rem(x, ranges) + 1;
        ii = v(1);
        jj = v(2);
    end

    % Optimized iterate function for 3 loops
    function [ii, jj, kk] = nGet3Iterates(x)        
        x = floor( (x-1) ./ cpRanges);
        v = rem(x, ranges) + 1;
        ii = v(1);
        jj = v(2);
        kk = v(3);
    end


    function varargout = nReorderInputs(varargin)
        varargout = cell(size(varargin));
        rangesBackward = fliplr(ranges);
        for ii = 1:numel(varargin)            
            t = reshape(varargin{ii}, rangesBackward);
            varargout{ii} = permute(t, n:-1:1);
        end
    end

    function varargout = nNoReorderInputs(varargin)
        varargout = varargin;
    end
end