function [pairs, pair_table] = get_valid_pairs(connections, v_num)
    %[v1, v2] = find(triu(connections+connections'));
    [v1, v2] = find(triu(connections));
    pairs = zeros(size(v1,1), 2);
    
    pairs(:, 1) = v1;
    pairs(:, 2) = v2;
    
    vertices = reshape(pairs, 1, size(v1,1) * 2);
    pair_idx = [1:size(v1,1),1:size(v1,1)];
    pair_table = sparse(vertices, pair_idx, ones(1, size(v1,1) * 2), v_num, size(v1,1));