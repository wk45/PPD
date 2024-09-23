function fn_est = Fn_Reconstruction(param,b,M,t,temp_idx)

c = param(1:size(b,1));
heights = param(size(b,1)+1:end);

m = size(b,2);
r = cToGamma(c,b);

if isempty(temp_idx)
    dif = floor(m/(2*M+2));
    temp_idx = 1:dif:m;
    temp_idx = [1, temp_idx(2:2*M+2), m];
end

fn_est = interp1(t(temp_idx), heights, (t(end)-t(1)).*r,'pchip');
