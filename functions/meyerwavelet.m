function M = meyerwavelet(j,k,w)
x=((2^j)*w)-k;
if(x==0.5)
    M=1.2732;
else if (x==1.25 | x==-.25)
        M=-.6162;
    else if(x==.875 | x==.125)
            M=-.3072;
else
p1=((4*(x-0.5)*cos(2*pi*(x-0.5)/3)/(3*pi))- sin(4*pi*(x-0.5)/3)/pi)/((x-0.5)-16*(x-0.5)^3/9);
p2=((8*(x-0.5)*cos(8*pi*(x-0.5)/3)/(3*pi))+ sin(4*pi*(x-0.5)/3)/pi)/((x-0.5)-64*(x-0.5)^3/9);
M=p1+p2;
        end
    end
end



