
function fS = flipZLP(S)



[~,idx] = max(S);

if iscolumn(S)
    fS = [S(1:idx+1);flipud(S(1:idx-2))];
elseif isrow(S)
    fS = [S(1:idx+1),fliplr(S(1:idx-2))];
else
    error('Input S - Spectrum must be either row or column');
end
   
        
        
