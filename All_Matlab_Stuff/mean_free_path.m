function varargout = mean_free_path(E0, beta, at_per, at_num)
%%



%%

if sum(at_per) == 100
    at_per = at_per./100;
end

%%
Z_eff = sum(at_per .* at_num.^1.3) / sum(at_per .* at_num.^0.3);

fprintf('\nEffective Atomic Number (Z_eff) = %.2f\n', Z_eff);

%%
Em = 7.6 *Z_eff^0.36;

fprintf('\nEnergy (eV) = %.2f\n', Em);

%%
F = (1 + E0/1022) / (1 + E0/511)^2;

%%
lambda = (106 * F * E0/Em) / log(2 * beta * E0/Em);

fprintf('\nMean Free Path (nm) = %.2f\n', lambda);

%%
if nargout == 1
    varargout{1} = lambda;
end