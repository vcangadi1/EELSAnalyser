%   This is a method by taking the difference between the spectrum points to check the monotonicity. 

fprintf(1,'\n--------------- Curve fit--------------\n\n');

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

%   Initialize the waitbar() components
h_bar = 0;
h = waitbar(h_bar,'Staring the Computation',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0);

for m=1:r,
    for n=1:c,
        
        %   Check if the Cancel button is pressed
        if getappdata(h,'canceling')
            break;
        end;
        EELS_spectrum = si_struct.image_data(16,16,:);
        EELS_spectrum = (reshape(EELS_spectrum,N,1));
        
        EELS = EELS_spectrum;               % Temp variable for EELS spectrum
        core = EELS_spectrum;               % Core Loss spectrum
        cf = EELS_spectrum;    % Curve fit variable
        X = (1:1024).';
        nX = (X );
        for i=1:N-1,
            ds(i) = (EELS(i)-EELS(i+1));
        end
        
        ds(N) = EELS(N);
        ds = (reshape(ds,N,1));
        [fitresult, gof] = exp1((1:100).', ds(1:100));
        nY = fitresult(nX);
        
        for i=N-1:-1:1,
            EELS(i) = ds(i) + EELS(i+1);
            cf(i) = nY(i) + cf(i+1);
        end
        
        core = EELS-cf;
        
        [fitresult, gof] = exp1((10:160).', core(10:160));
        cf1 = fitresult(nX);
        [fitresult, gof] = exp1((1:20).', EELS_spectrum(1:20));
        cf2 = fitresult(nX);
        curvef = EELS_spectrum;
        [fitresult, gof] = exp1((100:150).', EELS_spectrum(100:150));
        cf3 = fitresult(nX);
        for i=1:N,
            curvef(i) = max([cf(i) cf1(i) cf2(i) cf3(i)]);
        end

    %   Update status bar with new value and display the pixels
        h_bar = h_bar + 1;
        count = h_bar/(r*c);
        waitbar( count , h, sprintf('Pixel %d X %d is Calculated....%3.1f%% Complete', m, n, count*100));
    end
end

d_e = diff(smooth(EELS_spectrum));
%%  Plot the figures
figure;
plot((1:1024).*D -56+78,curvef,'r','LineWidth',3)
hold on
plot((1:1024).*D -56+78,EELS_spectrum-curvef,'g','LineWidth',3)
plot((1:1024).*D -56+78,EELS_spectrum,'-','LineWidth',3)
plot((1:1023).*D -56+78,d_e,'b','LineWidth',1)
xlabel('Energy (eV)');
ylabel('CCD counts');
title('EELS background subtraction from single exponential function');
legend('Background fit','Core-Loss','Spectrum');
%axis([0 N 0 maxEELS]);
hold off
grid on;
delete(h);