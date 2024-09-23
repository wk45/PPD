function fn_est = shapeConstrained_estimation(X, g_template, K, t, rho, varargin)

    % Default values
    basis_type = 'Fourier';  % Default basis type

    % Parse optional arguments
    if ~isempty(varargin)
        basis_type = varargin{1};
    end

    M = sum(islocalmax(g_template));

    if M == 0
        fn_est = [];
        K = [];
    end
   

   b = basis(K,t,basis_type);  
   b_size = size(b,1);
  
   % critical points
   [idxM,idxm] = findExtrema(g_template);
   
   temp_idx = sort([idxM, idxm]);
   heights = g_template(temp_idx); 

   if ismember(1,idxM)
       start = 1;
   elseif ismember(1,idxm)
       start = 0;
   end
   
   n = length(temp_idx);
   A = tril(ones(n-1,n),1) - tril(ones(n-1,n),-1);
  
   if start
        A(:,1:2:n) = A(:,1:2:n) * -1;
   else
        A(:,2:2:n) = A(:,2:2:n) * -1;
   end
   A = [zeros(n-1,b_size) A];
   B = ones(n-1,1) * -1e-6;

   opts = optimoptions(@fmincon,'Algorithm','active-set','MaxFunEvals',20000,'MaxIter',10000);

   % lb = -Inf(1,b_size); lb = [lb, min(g_template,[],'all') * ones(1,length(temp_idx))];
   % ub = +Inf(1,b_size); ub = [ub, max(g_template,[],'all') * ones(1,length(temp_idx))];
   
   lb = -Inf(1,size(A,2));
   ub = +Inf(1,size(A,2));
   % ub = max(X,[],'all');

   init_val = [ones(1,b_size) * 1e-10, heights];

   problem = createOptimProblem('fmincon','objective',@(param) ObjFn(X, param, b, M, t, rho, temp_idx),...
                                                        'x0',init_val,'Aineq',A,'bineq',B,'lb',lb,'ub',ub,'options',opts);
   param_est = run(GlobalSearch('Display','off'),problem);
   
   fn_est = Fn_Reconstruction(param_est, b, M, t, temp_idx);

end