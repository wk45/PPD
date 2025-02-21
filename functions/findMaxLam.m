function maxlam = findMaxLam(t,f,maxVal,n_grid,varargin)

    p = inputParser;

    addRequired(p, 't');
    addRequired(p, 'f');
    addRequired(p, 'maxVal');
    addRequired(p, 'n_grid');

    addParameter(p, 'parallel', false, @(x) islogical(x) || isnumeric(x));

    parse(p, t, f, maxVal, n_grid, varargin{:});
    parallel = p.Results.parallel;
   
    lam_rough = linspace(0,maxVal,n_grid);

    Ft_rough = cell(1,n_grid);
    if parallel
        disp('Running in parallel mode');
        parfor i = 1:n_grid
            [fns, ~, ~] = mainWarpingWrapper(t,f',lam_rough(i));
            Ft_rough{i} = fns;
        end
    else
        disp('Running in sequential mode');
        for i = 1:n_grid
            [fns, ~, ~] = mainWarpingWrapper(t,f',lam_rough(i));
            Ft_rough{i} = fns;
        end
    end
        
    ll = zeros(1,n_grid);
    for i = 1:n_grid
        ll(i) = norm(mean(Ft_rough{i},2)' - mean(f),'fro');
    end
    
    idx_stop = (sum(ll > 1e-2) + 1);
    maxlam = lam_rough(idx_stop);
end
