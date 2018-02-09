%function R = edge_fit_detect(EELS,i,j)
function R = edge_fit_detect(SImage,energy_loss_axis,i,j)
%S = exp(medfilt1(log(abs(S)),10,'truncate'));
%S = exp(medfilt1(log(abs(S)),10,'truncate'));

w = 50;
r = [];
%a = [];
%r = zeros(EELS.SI_z,1);
%a = zeros(EELS.SI_z,1);
%r(1:w/2) = NaN;
%a(1:w/2) = NaN;
%r(EELS.SI_z-w/2:EELS.SI_z) = NaN;
%a(EELS.SI_z-w/2:EELS.SI_z) = NaN;
l = w/2;
u = size(SImage,3)-w/2;
for k = l:u,
    %disp(k);
    %fitresult = Power_law(EELS.energy_loss_axis(k-w/2+1:k+w/2),S(k-w/2+1:k+w/2));
    fitresult = Power_law(energy_loss_axis(k-w/2+1:k+w/2),squeeze(SImage(i,j,(k-w/2+1:k+w/2))));
    r = [r fitresult.b];
    %a = [a fitresult.a];
    %r(k) = fitresult.b;
    %a(k) = fitresult.a;
end

R = [repmat(r(1),1,w/2) r repmat(r(end),1,w/2-1)];
    %r(1:w/2) = r(w/2+1);
    %r(EELS.SI_z-w/2+1:EELS.SI_z) = r(EELS.SI_z-w/2);
%figure;

%plot(EELS.energy_loss_axis,R)
%hold on
    %figure
%[Ru,Rl]=envelope(R,2*w,'peak');
%Ru = medfilt1(Ru,w/2,'truncate');
%plot(EELS.energy_loss_axis,Ru)
    %dR = diff(Ru);
    %dR(dR<0)=0;
    %plot(EELS.energy_loss_axis(15:999),dR)
%[p,loc] = findpeaks(Ru);