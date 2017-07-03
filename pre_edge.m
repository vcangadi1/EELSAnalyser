
function [len_p_edge] = pre_edge(si_struct)




if(si_struct.fedge==1)
    si_struct.fedge = 0;
    len_p_edge = (si_struct.x(1) + si_struct.edge(1))/2;
else
    len_p_edge =        