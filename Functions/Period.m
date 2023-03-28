function Tz= Period(gama,T,Type)
switch Type
case 1
Tz=(0.6673+(0.05037*gama)-(0.006230*gama^2)+(0.0003341*gama^3))*T;
case 2
Tp=T/(0.7303+(0.04936*gama)-(0.006556*gama^2)+(0.00023610*gama^3));  
Tz=(0.6673+(0.05037*gama)-(0.006230*gama^2)+(0.0003341*gama^3))*Tp;     
otherwise
disp('invalid')        
end
return