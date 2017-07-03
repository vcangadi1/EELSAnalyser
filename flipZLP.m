
function fS = flipZLP(S)



[~,idx] = max(S);

fS = [S(1:idx+1);flipud(S(1:idx-2))];

