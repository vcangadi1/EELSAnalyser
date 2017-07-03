clc
clear all
close all

si_struct = DM3Import( 'EELS Spectrum Image 16x16 1s 0.5eV 78offset' );
EELS_spectrum = si_struct.image_data(16,16,:);
EELS_spectrum = reshape(EELS_spectrum,1,1024).';
N = 1024;
sEELS = smooth(EELS_spectrum,10);
d1 = diff(sEELS,1);
d1(N) = sEELS(N);
tEELS = ones(size(sEELS));

for m=150:N-3,
    if(sEELS(m)<sEELS(m+1))
        %if(sEELS(m)<sEELS(m+2))
            %if(sEELS(m)<sEELS(m+3))
                tEELS(m)= 0;
            %end
        %end
    end
end


%pEELS = sEELS(tEELS);
plot(sEELS,'.','Linewidth',2)
hold on
plot(tEELS*3000,'r','Linewidth',2)
%plot(sEELS,'.','Linewidth',2)
%hold on
%plot(d1,'.r','LineWidth',2)
%plot(atan2(sEELS(1:1024),(1:1024).'),'.g','LineWidth',2)