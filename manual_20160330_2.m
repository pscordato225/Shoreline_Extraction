%This a manual extraction of the shoreline for a March 30, 2016 image
%during the GCP survey. We also calculate the sea level at that specific
%time by intepolating the data. 
clear 
close all

%Load the sea level data and your dependent paths 
load('D:\Scodato_SSF_2018\Projects\SandwichBeachCam\oceanographic_data\Sandwidch_WL_surgeplustide_lag.mat')
addpath(genpath('D:\Scodato_SSF_2018\Projects\SandwichBeachCam\images\2016\cx'));
addpath(genpath('D:\Scodato_SSF_2018\Source Code\Shoreline_Extraction'));

%%
%load the image coordinate structure  
load('D:\Scodato_SSF_2018\Projects\SandwichBeachCam\shoreline_mapping\Local_Shoreline_Coordinates\20160330_2')
%%
%Extract the shoreline image coordinates and plot the line based on the
%coordinates
I= imread('March301528031818.Sun.Jun.03_13_16_58.GMT.2018.Sandwich.cx.bright.png');
figure(3)
imshow(I)
line([368 384], [490 468], 'Color', 'c')
line([384 392], [468 457], 'Color', 'c')
line([392 410], [457 419], 'Color', 'c')
line([410 419], [419 402], 'Color', 'c')
line([419 432], [402 377], 'Color', 'c')
line([432 444], [377 359], 'Color', 'c')
line([444 462], [359 331], 'Color', 'c')
line([462 488], [331 293], 'Color', 'c')
line([488 513], [293 253], 'Color', 'c')
line([513 526], [253 234], 'Color', 'c')

%%

%Add a legend that shows the elevation of the countour
% dateT= find(T>=tt,1,'first');
% dateS=datestr(T(dateT))
% sl= sand_total(dateT)
% sl_in = interp1(T,sand_total,tt,'linear')
% legend(['Elevation (m)=' num2str(sl_in)])

%% 
%Rotating the coordinate system back to UTM from local 

load('D:\Scodato_SSF_2018\Projects\SandwichBeachCam\extrinsic_calibration\gcp_surveys\2016-03-30_webcam_extrinsic_calibration\EastingNorthing_GCP_mat\gcpSandwich2016_master.mat')
addpath(genpath('D:\Scodato_SSF_2018\Source Code\Coordinate-System-Code'))

X=[ip.x];
Y=[ip.y];


for ii= 1 : length(gcp)
    [gcp(ii).x, gcp(ii).y]=coordSys_sandwich(E(ii),N(ii));
end


