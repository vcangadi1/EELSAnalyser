function rsq = rsquare(Signal, Estimate)


SSE_residue = sum((Signal(:) - Estimate(:)).^2);

SSE_total = sum((Signal(:) - mean(Signal(:))).^2);

rsq = 1 - SSE_residue/SSE_total;