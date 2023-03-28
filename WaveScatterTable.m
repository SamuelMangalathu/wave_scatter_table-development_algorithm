clear all
close all
clc
%%
%Tool to make wave scatter table
%Edit line 14 and 19

%%
%addpath fpr functions
addpath('./Functions');%input file folder

%%
%folder names for reading files
inputfolderName={'SeaareaNew'}; %multiple files can be run at same time
%example for multiple file being done in single program 
%inputfolderName={'Inbass','Inarea8','Inarea9','Inarea15','Inarea16','Inarea40','Inarea62','Inarea91','Inarea92','Inarea93','Inarea99','Inarea100','Inarea101','StandardWaveScatterTable'};
%%
%User entry
gama=3.3;%gama value range from 1 to 7
% 1 for peak period and 2 for mean period

%%
Foldernumber=size(inputfolderName);
for FN=1:1:Foldernumber(2)

    
%*******************************************************************************************************%
%netcdf files
inputfolder=inputfolderName{FN};
filedirectory=strcat(inputfolder,'/','*.mat');
S=dir(filedirectory); %read all file with .mat extension from folder
URL={S.name}; %saving file name obtained from the folder
s=size(URL);% calculating number of files read from the folder
s=s(1,2); %saving the value for number of files to variable


%*******************************************************************************************************%
%Identifying the year of the file
for i=1:1:s
C1= strsplit(URL{i},'.');
C1=C1(1);
C1=strsplit(C1{1},'_');
C{i}=C1{4};
Y1(i)=sscanf(C{(i)}(1:4),'%d');
M1(i)=sscanf(C{(i)}(5:6),'%d');
end


%*******************************************************************************************************%
for i1=1:1:s
    
    
%*******************************************************************************************************%
%Initialising Matrix
WSTM=zeros(25,25);
WSTW=zeros(25,25);
WSTS=zeros(25,25);
WSTA=zeros(25,25);   


data1=strcat(inputfolder,'/',URL{i1});
disp(data1)
load(data1)


for i2=1:1:size(Time)   
for i3=1:1:size(lat_w)
for i4=1:1:size(lon_w)

Hs=Hs_f(i3,i4,i2);
Pr=Period1mom_f(i3,i4,i2);
if (~isnan(Hs))&&(~isnan(Pr))
[m,n]=LWST(Hs,Pr,gama,2);
WSTM(m,n)=WSTM(m,n)+1;
WSTA(m,n)=WSTA(m,n)+1;
end
clear m n
HsW=HsWind_f(i3,i4,i2);
PrW=PeriodPeakWind_f(i3,i4,i2);
if (~isnan(HsW))&&(~isnan(PrW))
[m,n]=LWST(HsW,PrW,gama,1);
WSTW(m,n)=WSTW(m,n)+1;
WSTA(m,n)=WSTA(m,n)+1;
end
clear m n
HsS=HsS_1_f(i3,i4,i2);
PrS=PeriodPeakS_1_f(i3,i4,i2);
if (~isnan(HsS))&&(~isnan(PrS))
[m,n]=LWST(HsS,PrS,gama,1);
WSTS(m,n)=WSTS(m,n)+1;
WSTA(m,n)=WSTA(m,n)+1;
end

end
end
end


WST.(inputfolderName{FN}).Name=inputfolderName{FN};
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).Name=Y1(i1);
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).Name=M1(i1);
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WSTM=WSTM;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WSTA=WSTA;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WSTW=WSTW;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WSTS=WSTS;


WM=sum(sum(WSTM));
WW=sum(sum(WSTW));
WS=sum(sum(WSTS));
WA=sum(sum(WSTA));


%*******************************************************************************************************%
%Wave scatter table averge
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.Mean=WM;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.Mean=WA;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.Mean=WW;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.Mean=WS;


%*******************************************************************************************************%
%Wave scatter table probability
[PE,HsE,PR,HsR,PEExt,HsEExt,PRExt,HsRExt]= probabilityestimation(WSTM);
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.PE=PE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.HsE=HsE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.PR=PR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.HsR=HsR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.PEExt=PEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.HsEExt=HsEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.PRExt=PRExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).MValue.HsRExt=HsRExt;

clear PE HsE PR HsR PEExt HsEExt PRExt HsRExt 


[PE,HsE,PR,HsR,PEExt,HsEExt,PRExt,HsRExt]= probabilityestimation(WSTA);
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.PE=PE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.HsE=HsE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.PR=PR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.HsR=HsR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.PEExt=PEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.HsEExt=HsEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.PRExt=PRExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).AValue.HsRExt=HsRExt;

clear PE HsE PR HsR PEExt HsEExt PRExt HsRExt


[PE,HsE,PR,HsR,PEExt,HsEExt,PRExt,HsRExt]= probabilityestimation(WSTW);
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.PE=PE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.HsE=HsE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.PR=PR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.HsR=HsR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.PEExt=PEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.HsEExt=HsEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.PRExt=PRExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).WValue.HsRExt=HsRExt;

clear PE HsE PR HsR PEExt HsEExt PRExt HsRExt


[PE,HsE,PR,HsR,PEExt,HsEExt,PRExt,HsRExt]= probabilityestimation(WSTS);
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.PE=PE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.HsE=HsE;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.PR=PR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.HsR=HsR;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.PEExt=PEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.HsEExt=HsEExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.PRExt=PRExt;
WST.(inputfolderName{FN}).(strcat('Y',num2str(Y1(i1)))).(strcat('M',num2str(M1(i1)))).SValue.HsRExt=HsRExt;

clear PE HsE PR HsR PEExt HsEExt PRExt HsRExt 


clear WSTM WSTA WSTW WSTS


end

end
file.WST=WST;
save('WSTstruct.mat', '-struct', 'file');
disp('Contents of newstruct.mat:')
whos('-file', 'WSTstruct.mat')

