function im=Otsu(I)
%%用大津法选取阈值：先任选T，将图像由T分为两个子块，
%%分别计算方差，使得他们的类间方差最小。适用于前景和背景差别大的情况
% I=rgb2gray(I);
mean_var=mean(mean(I));
I=double(I);
[m n]=size(I); 
sum_point=m*n;
var_total=var(var(I));
P=zeros(1,256);
Mean=zeros(1,256);
 for i=1:n
     for j=1:m
         a=uint8(I(j,i));
         P(1,a+1)=P(1,a+1)+1;
     end
  end
  for i=0:255
      P(1,i+1)=P(1,i+1)/sum_point;
  end
  w0=zeros(1,256);
  %%
  %%统计每个灰度级的像素个数
  for i=1:256
      if i==1
          w0(1,i)=P(1,i);
      end
      if i>1
         w0(1,i)=w0(1,i-1)+P(1,i);
     end
  end
  w1=ones(1,256);
  w1=w1-w0;
  %%
%%%%统计每一灰度级下的均值  
  for i=1:256
      if i==1
          Mean(1,i)=(i-1)*P(1,i);
      end
      if i>1
          Mean(1,i)=Mean(1,i-1)+(i-1)*P(1,i);
      end
  end
 mean_0=Mean./w0;
 a=mean_var-Mean;
 mean_1=a./w1;
 var_b=w0.*w1.*power(mean_0-mean_1,2);
 %%
 %%%计算每一灰度级下的类间方差
 ratio=var_b./var_total;
  max=0;
  %%
  %%搜寻最小类间方差
 for i=1:255
        if ratio(i)>max
            max=ratio(i);
            T=i;
        end
 end
 for i=1:m
     for j=1:n
         if(I(i,j)>T)
            im(i,j)=255;
         else
            im(i,j)=0;
         end
     end
 end


