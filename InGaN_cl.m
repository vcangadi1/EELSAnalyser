function InGaN = InGaN_cl(InN, GaN, x, E_off, energy_loss_axis)

%x = 0.9;
%E_off
%l = energy_loss_axis(eV2ch(energy_loss_axis,13.0051):eV2ch(energy_loss_axis,27.48));
l = energy_loss_axis;

InGaN1 = InN(169:169+540-1)*x+GaN(437:437+540-1)*(1-x);

%GaN onset is 23.8, But resdue begins at 19.53
InGaN = [zeros(eV2ch(l,19.53-E_off.*x)-1,1); InGaN1];

if length(InGaN) < length(energy_loss_axis)
    z = length(energy_loss_axis) - length(InGaN);
    InGaN = [InGaN; zeros(z,1)];
elseif length(InGaN) > length(energy_loss_axis)
    InGaN = InGaN(1:length(energy_loss_axis));
end

%l1 = (1:length(InGaN1))'*0.015+13;
