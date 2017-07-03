function Selection(obj, event)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the type of display (true color or gray scale).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global handles RGB data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles(47),'visible','on'); %"Display" button visible
[l m l] = size(data);

if isequal(gco,handles(37))
    %Display True color menu

    %True color menu 'on'
    set(handles(38), 'visible', 'on');
    set(handles(39), 'visible', 'on');
    set(handles(40), 'visible', 'on');
    set(handles(41), 'visible', 'on');
    set(handles(42), 'visible', 'on');
    set(handles(43), 'visible', 'on');

    %Grey scale menu 'off'
    set(handles(45), 'visible', 'off');
    set(handles(46), 'visible', 'off');
    
    R = str2num(get(handles(39), 'string'));
    R = max(min(R,l),1);
    G = str2num(get(handles(41), 'string'));
    G = max(min(G,l),1);
    B = str2num(get(handles(43), 'string'));
    B = max(min(B,l),1);

    RGB = [R G B];

elseif isequal(gco,handles(44))
    %Display Grey scale menu
    
    %True color menu 'off'
    set(handles(38), 'visible', 'off');
    set(handles(39), 'visible', 'off');
    set(handles(40), 'visible', 'off');
    set(handles(41), 'visible', 'off');
    set(handles(42), 'visible', 'off');
    set(handles(43), 'visible', 'off');

    %Grey scale menu 'on'
    set(handles(45), 'visible', 'on');
    set(handles(46), 'visible', 'on');
    
    R = str2num(get(handles(46), 'string'));
    R = max(min(R,l),1);

    RGB = R;

end
end

