function [Xi,flag]=AFTSP_follow(X,afNum,cityNum,visual,crowd,i,Distance,crossNum)        %若追尾成功，则flag 为1，否则flag为0
label=NBlabel(X,afNum,cityNum,i,visual);    %邻域内伙伴标号
nf=length(label);
Xi=[];                                      %默认追尾失败
flag=0;
if(nf==0)                        %邻域内没有伙伴
       return
end
bestY=inf;
bestj=0;
for jj=1:length(label)
      Ynb=AFTSP_foodconsistence(X(label(jj),:),Distance);
       if(bestY>Ynb)
           bestY=Ynb;
           bestj=label(jj);
       end
end                                          %邻域内状态最佳的伙伴X(bestj,:)
Xii=X(bestj,:);
if(AFTSP_foodconsistence(X(i,:),Distance)>AFTSP_foodconsistence(Xii,Distance)&nf/afNum<crowd)                 
    Xi=Xii;
    flag=1;
    return
end
if(dis(Xii,X(i,:),cityNum)<crossNum)          %如果没进步，并且太挤，则交换位置，保持距离
    for i=1:crossNum
        for i=1:ceil(crossNum/2)
            t1=ceil(rand*(cityNum-1))+1;
            t2=ceil(rand*(cityNum-1))+1;
            temp=Xii(t1);
            Xii(t1)=Xii(t2);
            Xii(t2)=temp;
        end
        if(dis(Xii,X(i,:),cityNum)>=crossNum)
            break
        end
    end
%     for i=1:crossNum
%         t1=ceil(rand*(cityNum-1))+1;
%         t2=ceil(rand*(cityNum-1))+1;
%         temp=Xii(t1);
%         Xii(t1)=Xii(t2);
%         Xii(t2)=temp;
%         if(dis(Xii,X(i,:),cityNum)>=crossNum)
%             Xi=Xii; 
%             return
%         end
%     end
else
    return
end
if(AFTSP_foodconsistence(X(i,:),Distance)>AFTSP_foodconsistence(Xii,Distance))                 
    Xi=Xii;
    flag=1;
end
    
    
    
    
    
    
    
    
    
    
    