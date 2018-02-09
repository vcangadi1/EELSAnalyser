%%  This is a Generic Exponential Curve fit for all pixel

fprintf(1,'\n---------------Generic Exponential Curve fit--------------\n\n');

%   Read spectrum from input file
si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );
display(si_struct);

%   Read length of the Spectrum
N = size(si_struct.image_data,3);
fprintf('\nLength of the spectrum z-axis : %d\n',N);

%   Read Image dimentions
r = size(si_struct.image_data,1);
c = size(si_struct.image_data,2);
fprintf('\nImage dimentions : %d X %d\n',r,c);

%   Read Dispersion of the spectrum
D = si_struct.zaxis.scale;
fprintf('\nDispersion : %.2f\n',D);

%   Read the actual Origin of the Spectrum
Origin = si_struct.zaxis.origin;
fprintf('\nOrigin : %d\n',Origin);

%   Select the data range of interests
n(1) = input('Enter the start point : ');
n(2) = input('Enter the end point : ');

%%  Computation of Curve fit

%   Initialize the waitbar() components
h_bar = 0;
h = waitbar(h_bar,'Staring the Computation',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0);

for i=1:r,
    for j=1:c,
        
        %   Check if the Cancel button is pressed
        if getappdata(h,'canceling')
            break;
        end;
        
        %   Read the EELS Spectrum from meta data
        EELS_spectrum = si_struct.image_data(i,j,:);
        EELS_spectrum = reshape(EELS_spectrum,1,N);
        
        %   Consider only the specified range from n1 to n2
        EELS = EELS_spectrum(n(1):n(2));
        X = (n(1):1:n(2)).';
        
        %   Normalize EELS from 0 - 1, Dividing by max value of EELS
        %   Normalize X from 0 - 1, Dividing by N
        maxEELS = max(EELS_spectrum);
        nEELS = (EELS.')./maxEELS;
        nX = X./N;
        
        % Call Exponential Curve fit funtion
        [fitresult, gof] = exp1(nX, nEELS);
        
        %  Calculate the Residual Core-Loss spectrum
        nY = fitresult(nX(1:end));
        cfilt = (nEELS(1:end) - nY(1:end))>0;
        Core = nEELS(cfilt) - nY(cfilt);
        
        %   Update status bar with new value and display the pixels
        h_bar = h_bar + 1;
        count = h_bar/(r*c);
        waitbar( count , h, sprintf('Pixel %d X %d is Calculated....%3.1f%% Complete', i, j, count*100));
        
    end;
end;

%%  Plot the figures
figure;
plot(nX*N ,nY*maxEELS,'r','LineWidth',3)
hold on
plot(nX*N ,nEELS*maxEELS,'--','LineWidth',3)
plot(nX(cfilt)*N ,Core*maxEELS,'-g','LineWidth',3)
xlabel('Energy (eV)');
ylabel('CCD counts');
title('EELS background subtraction from single exponential function');
legend('Background fit','Spectrum','Core-Loss');
%axis([0 N 0 maxEELS]);
grid on;

%%   Delete the waitbar. Waite bar will be closed and Print the finish message.
delete(h);

fprintf(1,'\n------------------------Computation of Curve fit---------------\n\n');