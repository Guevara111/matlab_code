function d=dis(X1,X2,cityNum)    
d=0;
for k1=1:cityNum
    if(X1(k1)~=X2(k1))
        d=d+1;
    end
end