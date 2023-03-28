function[m,n]=LWST(Hs,Pr2,gama,type)
M1=100;
N1=100;

Pr=Period(gama,Pr2,type);

m=1;
n=1;
f1=0;
f2=0;


while Hs<=M1
if Hs<=m
    f1=1;
else
    m=m+1;
end
if f1==1
break;
end
end

while Pr<=N1
if Pr<=n
    f2=1;
else
    n=n+1;
end
if f2==1
break;
end
end

return