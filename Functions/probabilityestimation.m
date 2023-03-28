function [PE,Hs,PR,Hsi,PEExt,HEExt,PRExt,HRExt]= probabilityestimation(WSTX)

WSTX=WSTX/sum(sum(WSTX));
HEExt=0.5:0.1:24.5;
HRExt=0:0.1:24;

E=size(WSTX);

%Probability of Wave Height
for i=1:1:E(1)
    pr(i)=sum(WSTX(i,:));
end

PR=pr;
Hsi=0.5:1:24.5;
%extrapolation 
PRExt=interp1(Hsi,PR,HRExt,'spline');

%Probability of excedence calculation
for i=1:1:E(1)
    pe(i)=sum(pr(i:E(1)));
end
PE=pe;

Hs=0:1:24;
%extrapolation 
PEExt=interp1(Hs,PE,HEExt,'pchip');


return


