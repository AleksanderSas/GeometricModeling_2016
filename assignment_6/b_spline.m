function points = b_spline(controlPoints, intervalNum, points, first, last)
    controlNodes = getControlNodes(size(controlPoints, 2), 4);
    intervals = linspace(0.000001,.99999999,intervalNum);
    for i = first:last
        points(:,i) = deBoor(controlPoints, controlNodes, intervals(i), 4);
    end

function controlNodes = getControlNodes(controlPointNumber, k)
    controlNodes = zeros(1, controlPointNumber + k);
    
    intermediateNodes = controlPointNumber - k + 1;
    for i = 1:intermediateNodes
        controlNodes(k+i) = i / intermediateNodes;
    end
    
    for i = intermediateNodes+1+k:controlPointNumber+k
        controlNodes(i) = 1;
    end
    
function point = deBoor(controlPoints, controlNodes, t, k)
    [v, i] = find(controlNodes >= t);
    r = i(1)- 1; %-1 because i(1) is first greater equal control node
    
    auxArray = zeros(2,k,k);
    firstPoint = r - k + 1; %+1 because matlab index 'r' starts with 1
    auxArray(:,:,1) = controlPoints(:,firstPoint:firstPoint + k-1);
    
    for j=1:k-1
        for i = j+1:k
            alpha = getAlpha(t, k, firstPoint+i-2, j, controlNodes);
            auxArray(:,i,j+1) = auxArray(:,i-1,j) * (1-alpha) + auxArray(:,i,j) * alpha;
        end
    end
    
    point = auxArray(:,k,k);
    
    
function alpha = getAlpha(t, k, i, j, controlNodes)
    alpha = (t - controlNodes(i+1))/(controlNodes(i+k-j+1) - controlNodes(i+1));
        