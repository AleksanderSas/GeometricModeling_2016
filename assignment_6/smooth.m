function data_out = smooth(data_in, window_size, degree)
    data_out = zeros(0,0);
    step = window_size / 2;
    i = 1;
    
    t = linspace(1, 10, window_size);
    points = [3.75,6.25];
    while i + window_size-1 < size(data_in, 2)
        subdata = data_in(:,i:i+window_size-1);
        
        data_out = [data_out,[poli_approximation(t, subdata(1,:), points ,degree);...
            poli_approximation(t, subdata(2,:), points ,degree)]];
        
        i = i + step;
    end