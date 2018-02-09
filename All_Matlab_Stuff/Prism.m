function Prism( u, eps1, eps2, K1, g, R, phi, v )
%First order focusing based on Eq 2.8, 2.9, 2.10, and 2.11
% Details in: EELS in the Electron Microscope, 3rd edition, Springer 2011
% Corrections (28Sep2011): convert psi to psid (in degrees) at line 76, 
% and add line 97:  m11(3,4) = phi.*R.*3.14159265./180.;  

fprintf(1,'\n-----------------Prism---------------\n\n');
if(nargin < 8)
    fprintf('Alternate Usage: Prism( u, eps1, eps2, K1, g, R, phi, v )\n\n');

    u = input('Object distance u : ');
    eps1 = input('Entrance tilt epsilon1 (deg): ');
    eps2 = input('Exit tilt epsilon2 (deg): ');
    K1 = input('Fringing-field parameter K1 (e.g. 0 or 0.4): ');
    g = input('Polepiece gap g : ');
    R = input('Bend radius R : ');
    phi = input('Bend angle phi (deg) : ');
    v = input('Image distance v : ');
else
    fprintf('Object distance u : %g\n',u);
    fprintf('Entrance tilt epsilon1 (deg): %g\n',eps1);
    fprintf('Exit tilt epsilon2 (deg): %g\n',eps2);
    fprintf('Fringing-field parameter K1 (e.g. 0 or 0.4): %g\n',K1);
    fprintf('Polepiece gap g : %g\n',g);
    fprintf('Bend radius R : %g\n',R);
    fprintf('Bend angle phi (deg) : %g\n',phi);
    fprintf('Image distance v : %g\n',v);
end;

x0=0;
y0=0;
dx0=0.001; % 1 mrad entrance
dy0=0.001; % 1 mrad entrance



xy0 = [x0;dx0;y0;dy0];
%disp('xy0');
%disp(xy0);

xy = eq8(xy0,u);
xy = eq9(xy, eps1, K1, g, R); %caclulate for eps1
xy = eq11(xy, phi, R); %magnetic field
xy = eq9(xy, eps2, K1, g, R); %calculate for eps2

fl = -xy(1)/xy(2);

fprintf(1,'Entrance-cone semi-angle = 1 mrad.\n\n');
fprintf(1,'For v = %g\n',v);
%disp('Answer 1');
ans1 = eq8(xy,v);
fprintf(1,'x  = %g\nx'' = %g\ny  = %g\ny'' = %g\n\n',ans1);
fprintf(1,'For v = %g\n',fl);
%disp('Answer 2');
ans2 = eq8(xy,fl);
fprintf(1,'x  = %g\nx'' = %g\ny  = %g\ny'' = %g\n',ans2);


end

function xy = eq8( xy, u )

m8 = eye(4);
m8(1,2) = u;
m8(3,4) = u;
xy = m8 * xy;

%disp('m8');
%disp(m8);
%disp('xy8');
%disp(xy);
end

function xy = eq9( xy, eps, K1, g, R )

psi = (g./R).* K1 .* (1 + sind(eps).^2)./cosd(eps);
psid = psi .* 180./3.14159265; % convert to degrees

m9 = eye(4);
m9(2,1) = tand(eps) ./ R;
m9(4,3) = -tand(eps-psid)./ R;
xy = m9 * xy;

%disp('m9');
%disp(m9);
%disp('xy9');
%disp(xy);
end

function xy = eq11( xy, phi, R)

m11 = eye(4);
m11(1,1) = cosd(phi);
m11(2,1) = -sind(phi) ./ R;
m11(1,2) = R .* sind(phi);
m11(2,2) = cosd(phi);
m11(3,4) = phi.*R.*3.14159265./180.;
xy = m11 * xy;

%disp('m11');
%disp(m11);
%disp('xy11');
%disp(xy);
end

