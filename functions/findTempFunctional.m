function ttemp = findTempFunctional(t,fnm,sig_peak_time_idx)

    % Find indices of all peaks and valleys
    peak_idxs = find(islocalmax(fnm));
    valley_idxs = find(islocalmin(fnm));
    
    % Identify insignificant peaks
    insig_peak_idxs = setdiff(peak_idxs, sig_peak_time_idx);
    
    % Group consecutive insignificant peaks
    consec_groups = {};
    group = [];
    for i = 1:length(insig_peak_idxs)
        if isempty(group) || insig_peak_idxs(i) == group(end) + 1
            group(end+1) = insig_peak_idxs(i);
        else
            consec_groups{end+1} = group;
            group = insig_peak_idxs(i);
        end
    end
    % Add the last group if not empty
    if ~isempty(group)
        consec_groups{end+1} = group;
    end
    
    % Determine which valleys to exclude
    excluded_valleys = [];
    for i = 1:length(consec_groups)
        group = consec_groups{i};
        prev_valley = max(valley_idxs(valley_idxs < group(1)));
        next_valley = min(valley_idxs(valley_idxs > group(end)));
        if isempty(prev_valley)
            prev_valley = 1;
        end
        if isempty(next_valley)
            next_valley = length(t);
        end
        
        if fnm(prev_valley) > fnm(next_valley)
            excluded_valleys(end+1) = prev_valley;
        else
            excluded_valleys(end+1) = next_valley;
        end
    end
    
    % Exclude the valleys that are adjacent to insignificant peaks
    valley_idxs = setdiff(valley_idxs, excluded_valleys);
    
    % Combine significant peaks and remaining valleys
    selected_idxs = sort([1; sig_peak_time_idx(:); valley_idxs(:); length(t)])';
    
    % Extract the corresponding y-values
    selected_points = fnm(selected_idxs);
    
    ttemp = interp1(t(selected_idxs),selected_points,t,'pchip');
