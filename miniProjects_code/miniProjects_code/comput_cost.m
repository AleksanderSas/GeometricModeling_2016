function [cost, v] = comput_cost(q1,q2)
    q =q1+q2;
    q3 = q;
    q(4,:) = 0.0;
    q(4,4) = 1.0;
    q = inv(q);
    v = q(:, 4);
    
    %we want the smollest elemet on the top of queue
    cost = -v' * q3 * v;