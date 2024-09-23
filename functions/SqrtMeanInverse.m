function [gamI, gam_mu] = SqrtMeanInverse(gam)
 


[n,T] = size(gam);
dT = 1/(T-1);
psi = zeros(n,T-1);
for i=1:n
    psi(i,:) = sqrt(diff(gam(i,:))/dT);
end


%Find direction
mu = psi(1,:);
t = 1;
clear vec;
for iter = 1:5
    for i=1:n
        v = psi(i,:) - mu;
        len = acos(sum(mu.*psi(i,:))*dT);
        if len > 0.0001            
            vec(i,:) = (len/sin(len))*(psi(i,:) - cos(len)*mu);
        else
            vec(i,:) = zeros(1,T-1);
        end
        
        %keyboard;
    end
    vm = mean(vec);
    lvm(iter) = sqrt(sum(vm.*vm)*dT);
    if lvm  > 0.0001
        mu = cos(t*lvm(iter))*mu + (sin(t*lvm(iter))/lvm(iter))*vm;
    end
end

gam_mu = [0 cumsum(mu.*mu)]/T;
gam_mu = (gam_mu-min(gam_mu))/(max(gam_mu)-min(gam_mu));
gamI = invertGamma(gam_mu);
