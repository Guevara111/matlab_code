%%
clc
clear
close all
%读取数据
[cityNum,cityPosition] = Readtsp('att48.tsp');

%%
%参数设置
 tic        
 afNum=50;                          %人工鱼个数
 iterativeTime=100;                  %迭代次数
 try_number=100;                    %随机试探次数
 crowd=0.618;                       %拥挤度因子
 pcross=0.15;                               %引入交换因子
 crossNum=ceil(pcross*cityNum);             %交换位数
 %%
 %
 for i=1:cityNum                            %任意两城市间距离
     Distance(i,i)=inf;
     for j=i+1:cityNum
         Distance(i,j)=norm(cityPosition(i,:)-cityPosition(j,:));   
         Distance(j,i)=Distance(i,j);
     end
 end
 %%
  for i=1:afNum                              %初始化
     X(i,:)=AFTSP_init(cityNum);
     Ytemp(i)=AFTSP_foodconsistence(X(i,:),Distance);
  end
  
  
  %%
  [a b]=min(Ytemp);
 YBest=a;
 XBest=X(b,:);
 k=1;
 Ybest=zeros(1,iterativeTime);
 while(k<=iterativeTime)
     visual=ceil((4/5-k/(2*iterativeTime))*cityNum);
     for i=1:afNum    
         [Xi,flag1]=AFTSP_follow(X,afNum,cityNum,visual,crowd,i,Distance,crossNum);                  %尝试追尾行为
         if(flag1==0) 
             [Xi,flag2]=AFTSP_swarm(X,afNum,cityNum,visual,crowd,i,Distance,crossNum);               %尝试聚群行为
             if(flag2==0)
                Xi=AFTSP_prey(X,cityNum,i,visual,try_number,Distance,crossNum);                      %再尝试觅食行为
             end
         end
%下面为考虑公告板的吸引力
         Xii=Xi;
         diff1=find(Xii~=XBest);              %求出Xi和XBest中对应元素不一样的位置
         if(length(diff1)>0)
            a=randperm(length(diff1));%在随机的floor(length(diff1)/2)个不一样的位置赋XBest的值
            for ii=1:floor(length(diff1)/2)
                Xii(a(ii))=XBest(a(ii));
            end
            diff2=find(Xii~=XBest);
            iii=1;
            temp1=[];
            for ii=1:cityNum            %找出赋值后没有出现的城市号
                if(sum(ii==Xii)==0)
                    temp1(iii)=ii;
                    iii=iii+1;
                end
            end
            iii=1;
            temp2=[];
            for ii=1:cityNum            %找出赋值后出现两次的城市号
                if(sum(ii==Xii)==2)
                    temp2(iii)=ii;
                    iii=iii+1;
                end
            end
            iii=1;
            temp3=[];
            for ii=1:length(diff2)      %出现两次的城市在赋值后不同位置的位置
                if(sum(Xii(diff2(ii))==temp2)==1)
                    temp3(iii)=ii;
                    iii=iii+1;
                end
            end
            for ii=1:length(temp1)      %把没出现的城市的位置赋到出现两次的城市在赋值后不同位置的位置上
                Xii(diff2(temp3(ii)))=temp1(ii);
            end
        end
        if(AFTSP_foodconsistence((Xii),Distance)<AFTSP_foodconsistence((Xi),Distance))
            Xi=Xii;
        end
        if(AFTSP_foodconsistence((Xi),Distance)<YBest)
            XBest=Xi;
            YBest=AFTSP_foodconsistence((Xi),Distance);
        end
        X(ceil(rand*cityNum),:)=XBest;
    end   
    disp(['第',num2str(k),'次迭代,得出的最优值：',num2str(YBest)]);
    k=k+1;
 end
%%
s=num2str(XBest(1));
for i=2:cityNum
    s=strcat(s,'->');
    s=strcat(s,num2str(XBest(i)));
end
s=strcat(s,'->');
s=strcat(s,num2str(XBest(1)));
disp(['得出的最优路径:',s,',最优值:',num2str(YBest)]);
toc
%%



 
 figure(1)
plot([cityPosition(XBest,1);cityPosition(XBest(1),1)],...
     [cityPosition(XBest,2);cityPosition(XBest(1),2)],'o-');
grid on
hold on

for i=1:cityNum-1
    plot([cityPosition(XBest(i),1),cityPosition(XBest(i+1),1)],[cityPosition(XBest(i),2),cityPosition(XBest(i+1),2)]);
    text(cityPosition(i,1),cityPosition(i,2),['   ' num2str(i)]);
    hold on;
end

% for i = 1:cityNum-1
%     text(cityPosition(i,1),cityPosition(i,2),['   ' num2str(i)]);
% end


text(cityPosition(XBest(1),1),cityPosition(XBest(1),2),'       起点');
text(cityPosition(XBest(end),1),cityPosition(XBest(end),2),'       终点');
 xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title(['改进的人工鱼群算法优化路径(最短距离:' num2str(YBest) ')'])
 
