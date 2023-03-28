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
%Save netcdf files in Netcdf_file folder
clear all
close all
clc
%edit line 35 to 41

%*******************************************************************************************************%
%Matrix location for specific sea area.
%Example Sea area 40 (x=263, y=206, x1=40, y1=50)
x=1;%263;%Start point for location
y=1;%206;%Start point of location
x1=inf;%40;%lenth of 
y1=inf;%50;%length of 

% makeing new folder for sea area mat file
Inputfolder= 'SeaareaNew';% use name resepctive to sea area required
mkdir (Inputfolder)


startLoc = [x y 1];
count  = [x1 y1 Inf]; 

%*******************************************************************************************************%
%Reading files from defined folder
%netcdf files
S=dir('Netcdf_file/*.nc'); %read all file with .nc extension from folder "Netcdf_file"
URL={S.name}; %saving file name obtained from the folder
s=size(URL);% calculating number of files read from the folder
s=s(1,2); %saving the value for number of files to variable
%*******************************************************************************************************%
%editing file name strings for saving file later
for i=1:1:s
C = strsplit(URL{i},'.');
C=C(1:3);
URL{i}=join(C,'_');
end

DirNetcdfFile='Netcdf_file/';



%*******************************************************************************************************%
for i=1:1:s
    
URL1=[DirNetcdfFile S(i).name];
data1=strcat(Inputfolder,'/',URL{i},'.mat');


Time=ncread(URL1,'time');

%Location and map
lon_w=ncread(URL1,'longitude',x,x1);
lat_w=ncread(URL1,'latitude',y,y1); 

Hs=ncread(URL1,'hs',startLoc,count);%significant height of wind and swell waves 
%
HsWind=ncread(URL1,'phs0',startLoc,count);%significant height of wind waves 
HsS_1=ncread(URL1,'phs1',startLoc,count);%significant height of primary swell waves 

PeakDir=ncread(URL1,'dp',startLoc,count);%peak direction
MeanDir=ncread(URL1,'dir',startLoc,count);%wave mean direction
MeanDirWind=ncread(URL1,'pdir0',startLoc,count);%wave mean direction of wind sea
MeanDirS_1=ncread(URL1,'pdir1',startLoc,count);%wave mean direction of primary swell waves 

Period1mom=ncread(URL1,'t01',startLoc,count);%mean period of first frequency moment
PeriodPeakWind=ncread(URL1,'ptp0',startLoc,count);% peak period of wind sea
PeriodPeakS_1=ncread(URL1,'ptp1',startLoc,count);% peak period of primary swell waves 

%*******************************************************************************************************%
T1=size(Time);
%}
for t=1:1:T1(1,1)
Hs_1=Hs(:,:,t);Hs_1=Hs_1';Hs_f(:,:,t)=Hs_1;
%
HsWind_1=HsWind(:,:,t);HsWind_1=HsWind_1';HsWind_f(:,:,t)=HsWind_1;
HsS_1_1=HsS_1(:,:,t);HsS_1_1=HsS_1_1';HsS_1_f(:,:,t)=HsS_1_1;

PeakDir_1=PeakDir(:,:,t);PeakDir_1=PeakDir_1';PeakDir_f(:,:,t)=PeakDir_1;
MeanDir_1=MeanDir(:,:,t);MeanDir_1=MeanDir_1';MeanDir_f(:,:,t)=MeanDir_1;
MeanDirWind_1=MeanDirWind(:,:,t);MeanDirWind_1=MeanDirWind_1';MeanDirWind_f(:,:,t)=MeanDirWind_1;
MeanDirS_1_1=MeanDirS_1(:,:,t);MeanDirS_1_1=MeanDirS_1_1';MeanDirS_1_f(:,:,t)=MeanDirS_1_1;

Period1mom_1=Period1mom(:,:,t);Period1mom_1=Period1mom_1';Period1mom_f(:,:,t)=Period1mom_1;
PeriodPeakWind_1=PeriodPeakWind(:,:,t);PeriodPeakWind_1=PeriodPeakWind_1';PeriodPeakWind_f(:,:,t)=PeriodPeakWind_1;
PeriodPeakS_1_1=PeriodPeakS_1(:,:,t);PeriodPeakS_1_1=PeriodPeakS_1_1';PeriodPeakS_1_f(:,:,t)=PeriodPeakS_1_1;

end

save(data1{1},'Hs_f','HsWind_f','HsS_1_f','PeakDir_f','MeanDir_f','MeanDirWind_f','MeanDirS_1_f','Period1mom_f','PeriodPeakWind_f','PeriodPeakS_1_f','Time','lon_w','lat_w')
clear Hs_f HsWind_f HsS_1_f PeakDir_f MeanDir_f MeanDirWind_f MeanDirS_1_f Period1mom_f PeriodPeakWind_f PeriodPeakS_1_f Time lon_w lat_w
end