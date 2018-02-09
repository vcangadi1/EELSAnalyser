function myID = getMyTaskID
% Copyright 2013 The MathWorks, Inc.
persistent ID
if isempty(ID)
    t = getCurrentTask;
    if isempty(t)
        ID = 1;
    else
        ID = get(getCurrentTask, 'ID');
    end
end
myID = ID;