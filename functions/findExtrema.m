function [idMax,idMin] = findExtrema(fk)

fk_dot = diff(fk);%first order differences to approximate


sig = sign(fk_dot); % get sign of data
if sig(end)==0
    sig(end)=sig(find(sig~=0, 1, 'last' )); %if sign at right boundary is zero,
                                            %replace by last nonzero sign
end

ind=find(fk_dot==0);    %find the rest 0-signed indices

for i=1:length(ind)
   sig(ind(i))=sig(ind(i)-1 + min((sig(ind(i):end)~=0)));   %find the next first nonzero sign
end

idMax = find(diff(sig)< -0.1)+1; % get zero crossings by diff ~= 0
idMin = find(diff(sig)> 0.1)+1;

if sig(1)>0
    idMin=[1 idMin];
else
    idMax=[1 idMax];
end

if sig(end)>0
    idMax=[idMax length(fk)];
else
    idMin=[idMin length(fk)];
end
    