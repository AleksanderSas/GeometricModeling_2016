

%fileID = fopen('ExampleData/CamelHeadSilhouette.txt','r');
fileID = fopen('ExampleData/MaxPlanckSilhouette.txt','r');
%fileID = fopen('ExampleData/SineRandom.txt','r');
A = fscanf(fileID,'%f');
x = length(A)/ 2;
A = reshape(A, 2, length(A)/ 2);
fclose(fileID);

B = smooth(A, 10, 2);

points = b_spline(B, 20000);
figure(1);
plot(A(1,:), A(2,:), 'x', 'color','b'); hold on 
%plot(B(1,:), B(2,:), 'x', 'color','g'); hold on 
plot(points(1,:), points(2,:), 'color', 'g'); hold on;

B = smooth(A, 14, 2);
points = b_spline(B, 20000);
figure(1);
plot(points(1,:), points(2,:), 'color', 'r');