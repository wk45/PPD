function Fa = getAlignedFns(t,f,lam,varargin)

    p = inputParser;

    addRequired(p, 't');
    addRequired(p, 'f');
    addRequired(p, 'lam');
    
    addParameter(p, 'parallel', false, @(x) islogical(x) || isnumeric(x));

    parse(p, t, f, lam, varargin{:});
    parallel = p.Results.parallel;
       
    Fa = cell(1,length(lam));
    if parallel
        disp('Running in parallel mode');
        parfor i = 1:length(lam)
            fns = mainWarpingWrapper(t,f',lam(i));
            Fa{i} = fns';
        end
    else
        disp('Running in sequential mode');
        for i = 1:length(lam)
            fns = mainWarpingWrapper(t,f',lam(i));
            Fa{i} = fns';
        end
    end
