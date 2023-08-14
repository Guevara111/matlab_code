function Xi=AFTSP_prey(X,cityNum,i,visual,try_number,Distance,crossNum)
%Xi=AFTSP_init(cityNum);
for j=1:try_number
    jj=ceil(rand*visual);
    S(1)=ceil(rand*(cityNum-1))+1;       %随机产生2到cityNum之间的数
    p=1;
    while(p<jj)
       t=ceil(rand*(cityNum-1))+1;
       if((S==t)==0)
           p=p+1;
           S(p)=t;
       end
    end                                  %随机生成S向量，元素个数不定
   Xii=X(i,:);
   t=Xii(S(1));
   for k=1:jj-1
       Xii(S(k))=Xii(S(k+1));
   end
   Xii(S(jj))=t;
   if(j==1)
       Xibest=Xii;                      
   end
   if(AFTSP_foodconsistence(Xii,Distance)<AFTSP_foodconsistence(Xibest,Distance))
       Xibest=Xii;                      %Xibest存储觅食行为得到的最优解
   end
   if(AFTSP_foodconsistence(Xii,Distance)<AFTSP_foodconsistence(X(i,:),Distance))
       Xi=Xii;
       return
   end
end 
if(dis(Xibest,X(i,:),cityNum)<crossNum)          %如果没进步，并且太挤，则交换位置，保持距离
    for i=1:crossNum
        t1=ceil(rand*(cityNum-1))+1;
        t2=ceil(rand*(cityNum-1))+1;
        temp=Xibest(t1);
        Xibest(t1)=Xibest(t2);
        Xibest(t2)=temp;
        if(dis(Xibest,X(i,:),cityNum)>=crossNum)
            Xi=Xibest; 
            return
        end
    end
else
    Xi=Xibest; 
end
       
   
        
        