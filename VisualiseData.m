%*******************************************************************************************************%
%*******************************************************************************************************%
%Develope Wave sctter table from CISCO data Server


%*******************************************************************************************************%
%*******************************************************************************************************%
%How to access the online data
%step 1:  Search the below link online
%"https://data-cbr.csiro.au/thredds/catalog/catch_all/CMAR_CAWCR-Wave_archive/CAWCR_Wave_Hindcast_aggregate/gridded/catalog.html"
%step 2: click the files with 24m resolution for months required (example file name shown below)
%24 minitue resolution (ww3.glob_24m.xxxxxx.nc)
%step 3: click HTTPServer to download data
%step 4:copy the downloaded file to main program folder inside sub folder
%name "Netcdf_file"
%step 4: run program in sequence


%*******************************************************************************************************%
%*******************************************************************************************************%
%Part 1: Run this before part 2 and 3


%*******************************************************************************************************%
%*******************************************************************************************************%
%Tool to identify and visualise the data region


clear all
close all
clc
%edit line 39 to 42


%*******************************************************************************************************%
%*******************************************************************************************************%
%Matrix location for specific sea area.
%Example Sea area 40 (x=263, y=206, x1=40, y1=50)
x=1;%751;%263;%Start point for location
y=1;%296;%206;%Start point of location
x1=inf;%126;%40;%lenth of 
y1=inf;%51;%50;%length of 

startLoc = [x y 1];
count  = [x1 y1 Inf];


%*******************************************************************************************************%
%*******************************************************************************************************%
%access netcdf files
S=dir('Netcdf_file/*.nc'); %read all file with .nc extension from folder "Netcdf_file"
URL={S.name}; %saving file name obtained from the folder
s=size(URL);% calculating number of files read from the folder
s=s(1,2); %saving the value for number of files to variable


%*******************************************************************************************************%
%*******************************************************************************************************%
%editing file name strings for saving file later
for i=1:1:1
    C = strsplit(URL{i},'.');
    C=C(1:3);
    URL{i}=join(C,'_');
end
DirNetcdfFile='Netcdf_file/';


%*******************************************************************************************************%
%*******************************************************************************************************%
for i=1:1:1
    URL1=[DirNetcdfFile S(i).name];
    
    %Read time
    Time=ncread(URL1,'time');

    %Location and map
    lon_w=ncread(URL1,'longitude',x,x1);
    lat_w=ncread(URL1,'latitude',y,y1); 

    %read wave height
    Hs=ncread(URL1,'hs',startLoc,count);%significant height of wind and swell waves 

end

T1=size(Time);

for t=1:1:1%T1(1,1)
    Hs_1=Hs(:,:,t);Hs_1=Hs_1';Hs_f(:,:,t)=Hs_1;
end

[LON,LAT] = meshgrid(lon_w,lat_w);

load coastlines;
for i=1:1:9865
    if (coastlon(i)<0 && ~isnan(coastlon(i)))
        coastlon(i)=coastlon(i)+360;
    end
end
j=0;
for i=2:1:9865
    j=j+1;
    if (abs(coastlon(i-1)-coastlon(i))>10)
        coastlon1(j)=nan;
        coastlat1(j)=nan;
        coastlon1(j+1)=coastlon(i);
        coastlat1(j+1)=coastlat(i);
        j=j+1;
    else
        coastlon1(j)=coastlon(i);
        coastlat1(j)=coastlat(i);
    end
end

figure(1)
pcolor(LON,LAT,Hs_f(:,:,t));
shading flat
colorbar
xlabel('Longitude'),ylabel('Latitude')
title('Wave Height')
hold on
plot(coastlon1,coastlat1,'r-')
hold off
