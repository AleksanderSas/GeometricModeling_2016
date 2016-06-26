function window()

figure('Name','Assignment 6','NumberTitle','off','color','white');
myhandles=[];
myhandles.dragStyle=0;
myhandles.pressPosition = [0,0];
myhandles.currentPoint = 0;
myhandles.firstTime = true;
myhandles.points2draw_number = 20000;

%% design a basic  interface
% seup axis with a grid layout for drawing 
hax = gca; %get handle of current axes
set(hax,'Unit','normalized','Position',[0 0 1 1]); % make axis fill figure
grid on 
grid minor; % draw a fine grid 
hold on; % keep waiting for more input in the figure

myhandles = draw_curve(myhandles);

%d%efine Mouse callbacks
set(gcf,'WindowButtonDownFcn',@mousePress);
set(gcf,'WindowButtonMotionFcn',@mouseDrag);
set(gcf,'WindowButtonUpFcn',@mouseRelease);

myhandles.axis=hax;
guidata(gcf,myhandles) 


function myhandles = update_curve(myhandles)
    if myhandles.firstTime
        points = b_spline( myhandles.points, myhandles.points2draw_number, myhandles.points2draw, 1 , myhandles.points2draw_number);
        myhandles.points2draw = points;
        myhandles.firstTime = false;
        myhandles.curve=plot(points(1,:), points(2,:)); hold on;
        myhandles.control_polygon2=plot(myhandles.points(1,:), myhandles.points(2,:), '*', 'color', 'r'); hold on;
    else
        c = myhandles.points2draw_number / size(myhandles.points, 2) * myhandles.currentPoint;
        first = uint32(c - myhandles.points2draw_number / 100);
        last = uint32(c + myhandles.points2draw_number / 100);
        points = b_spline( myhandles.points, myhandles.points2draw_number, myhandles.points2draw,first, last);
        myhandles.points2draw = points;
        set(myhandles.curve,'Xdata',points(1,:));
        set(myhandles.curve,'Ydata',points(2,:));
        set(myhandles.control_polygon2,'Xdata',myhandles.points(1,:));
        set(myhandles.control_polygon2,'Ydata',myhandles.points(2,:));
    end

function myhandles = draw_curve(myhandles)

    fileID = fopen('ExampleData/CamelHeadSilhouette.txt','r');
    %fileID = fopen('ExampleData/MaxPlanckSilhouette.txt','r');
    %fileID = fopen('ExampleData/SineRandom.txt','r');
    A = fscanf(fileID,'%f');
    x = length(A)/ 2;
    A = reshape(A, 2, length(A)/ 2);
    fclose(fileID);

    B = smooth(A, 10, 2);
    myhandles.points = B;
    myhandles.points_t = B';
    
    myhandles.points2draw = zeros(2,myhandles.points2draw_number);
    myhandles.curve=plot(A(1,:), A(2,:), 'x', 'color','b'); hold on 
    myhandles = update_curve(myhandles);
    
%% Mouse button pressed
function mousePress(varargin)

    % get the variables stored in handles
    myhandles = guidata(gcbo);

    if strcmp(get(gcf,'SelectionType'),'normal') % left button: new control point being added 
        currentpos=get(myhandles.axis,'CurrentPoint'); %get the location of the current mouse position
        currentpos=currentpos(1,1:2);   % keep only what we need (see matlab help for currentpoint under figure properties)  
        myhandles.dragStyle=1;
        myhandles.pressPosition = currentpos;
        myhandles.currentPoint = dsearchn(myhandles.points_t, currentpos)
        guidata(gcbo,myhandles) %update data in handles    
    end

% Mouse button released
function mouseRelease(varargin)
    %global myhandles;
    myhandles = guidata(gcbo);

    myhandles.dragStyle=0;
    myhandles.currentPoint=0;
    guidata(gcbo,myhandles) 

% Mouse being moved (after clicking)
function mouseDrag(varargin)
    %global myhandles;
    myhandles = guidata(gcbo);

    if myhandles.dragStyle == 1
      xl = xlim;
      p=get(myhandles.axis,'CurrentPoint');
      p=p(1,1:2);
      minMove = min(abs(xl)) / 30000;
      move = p - myhandles.pressPosition;
      if move * move' > minMove
          myhandles.points(:,myhandles.currentPoint) = myhandles.points(:,myhandles.currentPoint) + move'; 
          myhandles.points_t(myhandles.currentPoint,:) = myhandles.points(:,myhandles.currentPoint)';
          myhandles.pressPosition = p;
          myhandles.pressPosition = p;
          myhandles = update_curve(myhandles);
          guidata(gcbo,myhandles) 
      end
    end 