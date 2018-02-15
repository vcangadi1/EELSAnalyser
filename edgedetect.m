function [edge] = edgedetect(strt,stp,ang)

edge = 0;
tc = 0;
for m=strt:stp
    if(ang(m)>0)
        tc = tc + 1;
    end
end
if(tc>((stp-strt)*2/3))
    edge = strt;
    %disp(edge);
end