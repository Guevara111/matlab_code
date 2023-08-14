function cropAll(I)
%% 读入图像数据
% I=imread('x.jpg');
% I=rgb2gray(I);
[m n]=size(I);
th=200;
% 求垂直投影
for y=1:n
    S(y)=sum(I(1:m,y));
end
y=1:n;
figure
subplot(211),plot(y,S(y));
title('垂直投影');
count=0;
for i=1:n-1
    if((S(1,i)-th)*S(1,i+1)<0)
        count=count+1;
        px(count)=i;
    end
    if(S(1,i)*(S(1,i+1)-th)<0)
        count=count+1;
        px(count)=i;
    end
end
% 求水平投影
for x=1:m
    S(x)=sum(I(x,:));
end
x=1:m;
subplot(212),plot(x,S(x));
title('水平投影');
count=0;
for j=1:m-1
%     t=(S(1,j)-1)*(S(1,j+1))
    if((S(1,j)-1000)*(S(1,j+1))<0 ||(S(1,j)*(S(1,j+1)-1000)<0))
        count=count+1;
        py1(count)=j;
    end
end
c=0;
tp=cell(1,19);

a=1;

%水平投影切割
for i=1:length(py1)-1
    if(abs(py1(i)-py1(i+1))>10 && mean(mean(I(py1(i):py1(i+1),:)))>10)
    a=i;
    break;
    end
end
    I=I(py1(a):py1(a+1),:);
    figure;imshow(I,[]);
  
%垂直投影切割    
for i=1:2:length(px)-1
%     && abs(px(i)-px(i+1))<=(px(2)-px(1))
    if(abs(px(i)-px(i+1))>10 && mean(mean(I(:,px(i):px(i+1))))>10)
    c=c+1;
    tp{c}=I(:,px(i):px(i+1));
%     figure;
%     imshow(tp{c},[]);
    end
end

    wsize=size(tp);
for p=1:c
    psize=size(tp{p});

   if(psize(2)>30) 
       %垂直投影
    for y=1:psize(2)
    Sx(y)=sum(tp{p}(1:psize(1),y));
    end
    thx=300;%细分割
    count=0;
    for j=1:psize(1)-1
    if((Sx(1,j)-thx)*(Sx(1,j+1))<0 ||(Sx(1,j)*(Sx(1,j+1)-thx)<0))
        count=count+1;
        pl(count)=j;
    end
    end
    pl=[pl psize(2)];
    for k=wsize(2):-1:p+2
    tp{1,k}=tp{1,k-1};
    end
    tp{p+1}=[];
    c=1;
    for i=length(pl):-2:2
        if(abs(pl(i)-pl(i-1))>10)
            m=tp{p}(:,pl(i-1):pl(i));
            tp{p+c}=m;
             c=c-1;  
        end
    end
   end
end
for p=1:wsize(2)
    [ps1,ps2]=find(tp{p}(:,:)==255);
    tp{p}=tp{p}(min(ps1):max(ps1),:);
    figure(1);
    imshow(tp{p});
end

%开操作
% for p=1:wsize(2)
%    se = strel('square',2);
%    afterOpening = imopen(~tp{p},se);
%    figure;imshow(afterOpening,[]);title('开操作结果')
%    tp{p}=afterOpening;
% end

save datanum tp

