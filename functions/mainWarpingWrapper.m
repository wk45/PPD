function [fn,gam,qn] = mainWarpingWrapper(t,f,lam)

binsize = mean(diff(t));
[M, N] = size(f);
f0 =f;

q = zeros(M, N);
%% compute the q-function of the plot 
for i = 1:N
    q(:,i) = gradient(f(:,i), binsize)./sqrt(abs(gradient(f(:,i), binsize))+eps);
end

%%% set initial using the original f space
mnq = mean(q,2);
dqq = sqrt(sum((q - mnq*ones(1,N)).^2,1));
[~, min_ind] = min(dqq);
mq = q(:,min_ind); 


%%% compute mean
% disp(sprintf(' Computing amplitude mean of %d functions in SRVF space...\n',N));
ds = inf; 
MaxItr = 10;

qun = zeros(MaxItr);
for r = 1:MaxItr
    
    gam = zeros(N, M);
    fn = zeros(M, N);
    qn = zeros(M, N);
    
    for k = 1:N
        q_c = q(:,k)'; mq_c = mq';
        gam0 = DynamicProgrammingQ_Adam(q_c/norm(q_c),mq_c/norm(mq_c),lam,0)';
        gam(k,:) = (gam0-gam0(1))/(gam0(end)-gam0(1));
        
        
        fn(:,k) = interp1(t, f0(:,k), (t(end)-t(1)).*gam(k,:) + t(1))';    
        qn(:,k) = gradient(fn(:,k), binsize)./sqrt(abs(gradient(fn(:,k), binsize))+eps);
    end
    
    ds(r+1) = sum(trapz(t, (mq*ones(1,N)-q).^2));
            
    
    %%%% Minimization Step %%%

    mqold = mq;
    mq = mean(qn,2);
    
    qun(r) = norm(mq-mqold)/norm(mqold);
    if (ds(r) < ds(r+1) || qun(r) < 1e-3)
        break;
    end
end

%% Centering in the orbit

    gamI = SqrtMeanInverse(gam);
    gamI_dev = gradient(gamI, 1/(M-1));
    mq = interp1(t, mq, (t(end)-t(1)).*gamI + t(1))'.*sqrt(gamI_dev');

    gam = zeros(N, M);
    fn = zeros(M, N);
    for k = 1:N
        q_c = q(:,k)'; mq_c = mq';
        gam0 = DynamicProgrammingQ_Adam(q_c/norm(q_c),mq_c/norm(mq_c),lam,0);
        gam(k,:) = (gam0-gam0(1))/(gam0(end)-gam0(1));


        fn(:,k) = interp1(t, f0(:,k), (t(end)-t(1)).*gam(k,:) + t(1))';   
    end        


end


