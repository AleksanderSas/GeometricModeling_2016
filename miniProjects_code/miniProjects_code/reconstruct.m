function [v, f] = reconstruct(v_ory, f_ory, n_f, n_v)
    %v = zeros(n_v, 3);
    v = v_ory;
    f = zeros(n_f, 3);
    
    f_idx = 1;
    for i = 1:size(f_ory, 1)
        if f_ory(i, 1) > 0
            f(f_idx, :) = f_ory(i, :);
            f_idx = f_idx + 1;
        end
    end
    
    