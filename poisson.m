function P = poisson(n,TOL)


P = (TOL.^n).*(1./factorial(n)).*exp(-TOL);