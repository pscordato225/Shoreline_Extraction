%This a manual extraction of the shoreline for a March 30, 2016 image
%during the GCP survey. We also calculate the sea level at that specific
%time by intepolating the data. 
clear 
close all

load('D:\Scodato_SSF_2018\Projects\SandwichBeachCam\oceanographic_data\Sandwidch_WL_surgeplustide_lag.mat')
addpath(genpath('D:\Scodato_SSF_2018\Projects\SandwichBeachCam\images\2016\cx'));
addpath(genpath('D:\Scodato_SSF_2018\Source Code\Shoreline_Extraction'));
I= imread('March301528031818.Sun.Jun.03_13_16_58.GMT.2018.Sandwich.cx.bright.png');
figure(2)
imshow(I)
line([356 372], [469 444], 'Color', 'm')
line([372 389], [444 417], 'Color', 'm')
line([389 410], [417 388], 'Color', 'm')
line([410 447], [388 330], 'Color', 'm')
line([447 475], [330 295], 'Color', 'm')
line([475 498], [295 251], 'Color', 'm')
line([498 524], [251 206], 'Color', 'm')


tt= datenum( 2016, 03, 30, 15, 51, 02);
dateT= find(T>=tt,1,'first');
dateS=datestr(T(dateT))
sl= sand_total(dateT)
sl_in = interp1(T,sand_total,tt,'linear')


legend('Elevation (m)=' num2str(sl_in)])