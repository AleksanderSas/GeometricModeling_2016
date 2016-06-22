function sum = poli_approximation(x, y, points, degree)
    m = repmat(x', 1, degree+1);
    m = bsxfun(@power, m, 0:degree);
    coefficeints = m \ y';
    
    m = repmat(points', 1, degree+1);
    m = bsxfun(@power, m, 0:degree);
    sum = m*coefficeints;
    sum = sum';