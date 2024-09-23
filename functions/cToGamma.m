function r = cToGamma(c,b)
    q = exponential_mapping( c_To_v(c,b) );
    dif = 1 / (length(q)-1);
    t = 0:dif:1;
    r = cumtrapz(t,q.^2);
    r = r/r(end);
end