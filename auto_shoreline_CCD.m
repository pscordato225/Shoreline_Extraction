function sl = mapShorelineCCD(xgrid,ygrid,Iplan,transects,editoption)
%
%function sl = mapShorelineCCD(xgrid,ygrid,Iplan,transects,editoption)
%
%function that maps a shoreline from a rectified planview image using the
%Colour Channel Divergence (CCD) technique (Red minus the Blue channel - can be adapted).
%
%xgrid -- a 1xM array of local UTM eastings
%ygrid -- a 1xN array of local UTM northings
%Iplan -- a MxNx3 uint8 image of the planview
%transects -- a structure that seeds the shoreline search algorithm
%using a series of cross-shore transects spaced at ~5m apart
   % transects.x -- the start and end points of each transect
   % x-coordinates (2 x M matrix, where 1st row = start, 2nd row = end)
   % transects.y -- the start and end points of the transects
   % y-coordinates (2 x M matrix, where 1st row = start, 2nd row = end)
%editoption == 1 if you want to manually edit the shoreline
%
%Created by Mitch Harley
%June 2018

%Add dependent paths 
addpath(genpath('D:\Scordato_SSF_2018\Source_Code\Shoreline_Extraction'))

%Choose your edit option 
editoption= 1

if nargin==4
    editoption=1;
end

%Import your image
Iplan = uint8(frameRect.I);

%Define your xy grids 
xgrid= [0 .1 400];
ygrid= [-250 .1 100];

%Import your transects start and end points 
%Import your x coordinates
load('D:\Scordato_SSF_2018\Source_Code\Shoreline-Mapping-Toolbox\x_coordinates')
x_coordinates= (x_coordinates);
x_coordinates(:, [31:48])= []; 

%Import your y coordinates
load('D:\Scordato_SSF_2018\Source_Code\Shoreline-Mapping-Toolbox\y_coordinates')
y_coordinates= (y_coordinates);

f1=figure;
image(xgrid,ygrid,Iplan)
axis image; axis xy
[X,Y] = meshgrid(xgrid,ygrid);

%Find threshold
P = improfile(xgrid,ygrid,Iplan,x_coordinates,y_coordinates); %Sample pixels at transects to determine threshold
[pdf_values,pdf_locs] = ksdensity(P(:,:,1)-P(:,:,3)); %find smooth pdf of CCD (Red minus Blue) channel
xlabel_type = 'Red minus blue';
thresh_weightings = [1/3 2/3]; %This weights the authomatic thresholding towards the sand peak (works well in SE Australia)
[peak_values,peak_locations]=findpeaks(pdf_values,pdf_locs); %Find peaks
thresh_otsu = multithresh(P(:,:,1)-P(:,:,3)); %Threshold using Otsu's method
f2 = figure;
plot(pdf_locs,pdf_values)
hold on
I1 = find(peak_locations<thresh_otsu);
[~,J1] = max(peak_values(I1));
I2 = find(peak_locations>thresh_otsu);
[~,J2] = max(peak_values(I2));
plot(peak_locations([I1(J1) I2(J2)]),peak_values([I1(J1) I2(J2)]),'ro')
%thresh = mean(peak_locations([I1(J1) I2(J2)])); %only find the last two peaks
thresh = thresh_weightings(1)*peak_locations(I1(J1)) + thresh_weightings(2)*peak_locations(I2(J2)); %Skew average towards the positive (i.e. sand pixels)

YL = ylim;
plot([thresh thresh], YL,'r:','linewidth',2)
%plot([thresh_otsu thresh_otsu], YL,'g:','linewidth',2)
xlabel(xlabel_type,'fontsize',10)
ylabel('Counts','fontsize',10)
disp(['Sand/water threshold determined to be ' num2str(thresh, '%0.0f')])

%Extract contour
RminusBdouble = double(Iplan(:,:,1))- double(Iplan(:,:,3));

%Mask out data outside of ROI (ROI determined from transects)
ROIx = [x_coordinates(1,:) fliplr(x_coordinates(2,:))]; %Transects file determines the ROI
ROIy = [y_coordinates(1,:) fliplr(y_coordinates(2,:))]; %Transects file determines the ROI
Imask = ~inpoly([X(:) Y(:)],[ROIx',ROIy']); %use the function inpoly instead of inpolygon as it is much faster
RminusBdouble(Imask) = NaN; %Mask data
%Imask = find(RminusBdouble==0); %Also remove regions of black colour
%RminusBdouble(Imask) = NaN; %Mask data
c = contours(X,Y,RminusBdouble,[thresh thresh]);
figure(f1)

%Now look at contours to only find the longest contour (assumed to be the
%shoreline)
II = find(c(1,:)==thresh);
if II==1 %If only one line
    startI = 2;
    endI = size(c,2);
else   
    D = diff(II);
    [~,J] = max(D); %Select contour that is the longest continuous contour
    if J == 1
        startI = 2;
    else
        startI = 1+J+sum(D(1:J-1));
    end
    endI = startI+D(J)-J-1;
end
xyz.y = c(1,startI:endI)';
xyz.x = c(2,startI:endI)';
points = [xyz.y xyz.x];

%Now loop through transects to extract shorelines only at the transects
sl.x = NaN(1,length(x_coordinates));
sl.y = NaN(1,length(y_coordinates));
warning off
for i = 1:length(transects.x)
    angle = atan(diff(y_coordinates(:,i))/diff(x_coordinates(:,i)));
    points_rot = rotatePoints(points,angle,[x_coordinates(1,i) y_coordinates(1,i)],'rads');
    max_distance = sqrt(diff(y_coordinates(:,i))^2+ diff(x_coordinates(:,i))^2);
        I = find(points_rot(:,2)>-1&points_rot(:,2)<1&points_rot(:,1)>0&points_rot(:,1)<max_distance); %Only find points greater than zero so that they are in the roi
        if ~isempty(I)
            [~,Imin] = min(points_rot(I,1));
            %[~,Imin] = max(points_rot(I,1));
            sl.x(i) = points(I(Imin),1);
            sl.y(i) = points(I(Imin),2);
        end
end

if editoption ==1
    h = impoly(gca,[sl.x' sl.y'],'closed',0);
    disp('Please edit your shoreline now or press any key to continue')
    pause
    newpos = getPosition(h);
    sl.x = newpos(:,1);
    sl.y = newpos(:,2);
end

%Remove NaNs
I = find(isnan(sl.x));
sl.x(I) = [];
sl.y(I) = [];
sl.method = 'CCD';
sl.threshold = thresh;