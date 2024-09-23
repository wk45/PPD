%% load data
load example1.mat

% You can skip (Step 0) as example data contains aligned functions.

%% (Step 0) Obtain a lambda candidate set

    maxVal = 2; n_grid = 20;
    maxlam = findMaxLam(t, f, maxVal, n_grid, 'parallel', true);
    lam = linspace(0,maxlam,50); % Generate a lambda grid
    Fa = getAlignedFns(t, f, lam, 'parallel', true); % Get aligned functions

%% (Step 1) Peak Persistent Diagrams

    pt = 0.15; % the percentile of negative curvature of raw data
    th = find_tau(t,f,pt); % get the threshold for significant peaks (tau)
    
    [IndicatorMatrix, Curvatures, Heights, Locs, Labels, FNm] = getPPDinfo(t, Fa, lam, th);
    persistent_peak_labels = getPersistentPeaks(IndicatorMatrix');
    
    labelMax = size(IndicatorMatrix,2);
    
    % Choose optimal lambda
    
    ref_row = zeros(1,size(IndicatorMatrix,2));
    ref_row(persistent_peak_labels) = 1;
    
    n_lams = size(IndicatorMatrix, 1);
    hamming_distances = zeros(1, n_lams);
    exact_match_indices = [];
    
    for i = 1:n_lams
        comp = double(~isnan(IndicatorMatrix(i, :)));
        
        % Check for exact match
        if isequal(comp, ref_row)
            exact_match_indices = [exact_match_indices, i];
        end    
        % Calculate Hamming distance
        hamming_distances(i) = sum(comp ~= ref_row);
    end
    
    if ~isempty(exact_match_indices)
        idx_opt = min(exact_match_indices);
    else
        min_distance = min(hamming_distances);
        
        min_distance_indices = find(hamming_distances == min_distance);
        idx_opt = min(min_distance_indices);
    end
    
    % Draw PPD BarChart
    drawPPDBarChart(IndicatorMatrix,Heights,lam,size(IndicatorMatrix,2),idx_opt)
    % Draw PPD Surface
    drawPPDSurface(t,lam,FNm,Heights,Locs,IndicatorMatrix,Labels,idx_opt)

%% (Step 2) Shape Constrained Function Estimation

    fnm = mean(Fa{idx_opt},1);
    g_template = findTempFunctional(t, fnm, Locs{idx_opt}(ismember(Labels{idx_opt}, persistent_peak_labels)));
    
    basis_type = 'Fourier'; 
    rho = 1e-9 ; k = 8; c = 1;
    
    fn_est = shapeConstrained_estimation(Fa{idx_opt}/c, g_template/c, k, t, rho, basis_type);
    fn_est = fn_est * c;


figure
hold on
if ~isempty(g)
    plot(t,g,'r','LineWidth',3)
end

plot(t, mean(Fa{1}),'b','LineWidth',2)
plot(t, mean(Fa{end})','b:','LineWidth',2)
plot(t, mean(Fa{idx_opt}),'b--','LineWidth',2)
plot(t, g_template, 'c','LineWidth',2)
plot(t, fn_est,'g','LineWidth',3)
legend("$g$","$\hat g_0$","$\hat g_{\infty}$","$\hat g_{\lambda^*}$", "$\hat g_{temp}$", "$\hat g$", ...
        'Interpreter', 'Latex', 'FontSize', 15)
hold off

xlabel('$t$','Interpreter','Latex', 'FontSize', 14)
ylabel('$f(t)$', 'Interpreter','Latex', 'Rotation', 0, 'HorizontalAlignment', 'right', 'FontSize', 14)
