function q = exponential_mapping(v)

p = ones(1,length(v));

dif = 1 / (length(v)-1);
t = 0:dif:1;

nv = norm(v,2)/length(v);
q = cos(nv)*p + sin(nv)*v/(nv);
% q = cos(trapz(t,v.^2))*p  + sin(trapz(t,v.^2))*v/(trapz(t,v.^2));