function [] = BarColors(mat,lam,col)
    
    for k = 1:size(mat,2)
        nums = mat(:,k)';
        num_init = nums(1);
        
        % Find indices where 'nums' changes value
        change_indices = find(nums(1:end-1) ~= nums(2:end));
        
        % Calculate counts of consecutive runs
        consec_counts = [change_indices, length(nums)] - [0, change_indices];
       
        consec_nums = ones(1, length(consec_counts));
        consec_nums(2:2:end) = 0;
        consec_nums = (consec_nums == num_init);
        
        % Calculate starting locations of each run
        consec_loc = [1, cumsum(consec_counts) + 1];
        
        % Loop over runs and draw rectangles where 'consec_nums' is true
        for j = 1:length(consec_counts)
            if consec_nums(j) == 1
                start_idx = consec_loc(j);
                end_idx = consec_loc(j + 1) - 1;
                
                % Ensure indices do not exceed bounds
                if end_idx > length(lam)
                    end_idx = length(lam);
                end
                
                x_start = lam(start_idx);
                x_end = lam(end_idx);
                width = x_end - x_start;
                
                rectangle('Position', [x_start, k - 0.5, width, 1], ...
                          'EdgeColor', col, 'FaceColor', col);
            end
        end
    end
end