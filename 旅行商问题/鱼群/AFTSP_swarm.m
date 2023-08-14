function [Xi,flag]=AFTSP_swarm(X,afNum,cityNum,visual,crowd,i,Distance,crossNum)
label=NBlabel(X,afNum,cityNum,i,visual);%邻域内伙伴标号
nf=length(label);
Xi=[];                                  %默认聚群失败
flag=0;
if(nf==0)                               %邻域内没有伙伴
    return
elseif(nf==1)
    Xc=X(label(1),:);
    if(AFTSP_foodconsistence(X(i,:),Distance)>AFTSP_foodconsistence(Xc,Distance));
         flag=1;
         Xi=Xc;
         return
     elseif(dis(Xc,X(i,:),cityNum)<crossNum)          %如果没进步，并且太挤，则交换位置，保持距离
         for i=1:crossNum
             for i=1:ceil(crossNum/2)
                t1=ceil(rand*(cityNum-1))+1;
                t2=ceil(rand*(cityNum-1))+1;
                temp=Xc(t1);
                Xc(t1)=Xc(t2);
                Xc(t2)=temp;
            end
            if(dis(Xc,X(i,:),cityNum)>=crossNum)
                break
            end
         end
     else
         return
     end
     if(AFTSP_foodconsistence(X(i,:),Distance)>AFTSP_foodconsistence(Xc,Distance))
         flag=1;
         Xi=Xc;
         return
     end
elseif(nf/afNum<crowd)
    neigbor=X(label,:);
    Xc=[];
    Xc(1)=1;
    for j=2:cityNum
        tJ=neigbor(:,j);                %找出出现最多的城市，从而确定邻域中心
        temp=[];
        for k=1:nf
            temp(k)=sum(tJ==tJ(k));
        end
        [p q]=max(temp);
        %p是出现最多的城市代号 q是出现最多的城市位置    
        %可以考虑把以前有的位置置零，然后到最后把没有的值在这些位
        %置随机排列（把没有的值先随机排列然后按顺序放到该放的位置上）
        if(sum(Xc==tJ(q))~=0) %如果Xc之前有这个值
            while(1)
                a=ceil(rand*cityNum);
                if(sum(Xc==a)==0)
                    Xc(j)=a;
                    break
                end
            end
        else
            Xc(j)=tJ(q);
        end
    end
    if(AFTSP_foodconsistence(X(i,:),Distance)>AFTSP_foodconsistence(Xc,Distance));
        flag=1;
        Xi=Xc;
        return
    elseif(dis(Xc,X(i,:),cityNum)<crossNum)          %如果没进步，并且太挤，则交换位置，保持距离
        for i=1:crossNum         
            for i=1:crossNum
                t1=ceil(rand*(cityNum-1))+1;
                t2=ceil(rand*(cityNum-1))+1;
                temp=Xc(t1);
                Xc(t1)=Xc(t2);
                Xc(t2)=temp;
            end
            if(dis(Xc,X(i,:),cityNum)>=crossNum)
                break
            end
        end
        if(AFTSP_foodconsistence(X(i,:),Distance)>AFTSP_foodconsistence(Xc,Distance))
            flag=1;
            Xi=Xc;
        end
    end
end





