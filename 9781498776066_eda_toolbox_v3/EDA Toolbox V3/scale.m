function nx = scale(x, a, b, c, d)
% This function converts a value x that orignally between a and b to
% one that is between c and d.

nx = (d - c)*(x - a)/(b - a) + c;