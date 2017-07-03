clc

si_struct = DM3Import( 'C:\Users\elp13va.VIE\Dropbox\MATLAB\InGaAs_Vn1061_230315\EELS Spectrum Image 2 Scan 69x2 pixels15.3nm 5s' );
EELS_spectrum = si_struct.image_data(2,1,:);
D = si_struct.zaxis.scale;
N = size(si_struct.image_data,3);
origin = si_struct.zaxis.origin;
EELS_spectrum = reshape(EELS_spectrum,1,N).';
si_struct.EELS_spectrum = (EELS_spectrum);

delta = 50;
si_struct.sensitivity = delta;

x = (((1:1024)-origin)*D);

edge = findedges_InGaAs_23032015(si_struct);

disp('Edge for background subtraction');
disp((edge-origin).');

si_struct.E = edge-origin;

%   Select pre-edge region
for i=1:length(edge),
    if(i==1)    %   check for first edge
        len_p_edge = (x(EELS_spectrum==max(EELS_spectrum)) + edge(i))/2;
    else        %   if not first edge
        len_p_edge = (si_struct.edge(i-1) + edge(i))/2;
    end
    
    disp('Start of pre-edge');
    disp(len_p_edge);
    
    
end


figure;
plot(x,smooth(si_struct.EELS_spectrum,15),'LineWidth',2)


