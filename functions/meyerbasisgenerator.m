function phi=meyerbasisgenerator(J,K,T)

phi=zeros((J*K)+1,length(T));
row=1;
for j=1:J
    for k=1:K
        for t=1:length(T)
            phi(row,t) = 2^((j-1)/2)*meyerwavelet(j-1,k-((K+1)/2),T(t));
        end
        row=row+1;
    end
end

T1 = T*(2^(J+1));
T2 = T1-1;

phi((J*K)+1,:) = 2^((J+1)/2)*(sin(2*pi*T1/3)+ 4*T1.*cos(4*pi*T1/3)/3)./(pi*T1 - 16*pi*T1.^3/9);

ind = (T1 == 0);
phi((J*K)+1,ind) = 2^((J+1)/2)*(2/3 + (4/(3*pi)));

l = ones(1,length(T));

for z = 1:((J*K)+1)
    phi(z,:) = phi(z,:) - sum(phi(z,:)) * l * 0.01; %orthogonalize wrt 1
end


