function [rsq, adjrsq] = rsquare(Signal, Estimate, explanatory_variables)

if nargin < 3
    explanatory_variables = 0;
end

if explanatory_variables < 0 
    explanatory_variables = 0;
    warning("explanotory_variable cannot be negative. Assigning it to 0");
end

SSE_residue = sum((Signal(:) - Estimate(:)).^2);

SSE_total = sum((Signal(:) - mean(Signal(:))).^2);

rsq = 1 - SSE_residue/SSE_total;

adjrsq = 1 - (1 - rsq) * (length(Signal)-1)/(length(Signal)-explanatory_variables-1);
