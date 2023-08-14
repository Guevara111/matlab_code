function Label=NBlabel(X,afNum,cityNum,i,visual)         %ÁÚÓòÄÚ»ï°é±êºÅ
Label=[];
p=0;
for j=1:afNum
    d=dis(X(i,:),X(j,:),cityNum);
    if((j~=i)&&(d<=visual))
        p=p+1;
        Label(p)=j;
    end
end




























