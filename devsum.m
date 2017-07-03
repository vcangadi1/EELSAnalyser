function d = devsum(a)
global X Y
d = sum((Y - a(1)./((X-a(2)).^2+a(3))).^2);