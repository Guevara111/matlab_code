%1.
files=xlsread('iris--鸢尾花数据.xlsx'); %导入excel表格
figure; %建立一个新的图形
subplot(1,2,1); %subplot(1行，2列，第一幅图);
histogram(files(:,3)); %到第3列
title('花瓣长度直方图')

subplot(1,2,2); %第二张图
histogram(files(:,4));%到第4列
title('花瓣宽度直方图')

%2.
for i=1:4
    for j=i+1:4
        R=corrcoef(files(:,i),files(:,j));
        disp(R);
    end;
end;
%先后输出属性1和属性2之间的相关性系数；属性1和属性3之间的相关性系数；
%属性1和属性4之间的相关性系数；属性2和属性3之间的相关性系数；
%属性2和属性4之间的相关性系数；属性3和属性4之间的相关性系数

%3.
for i=1:4
    for j=i+1:4
        figure;
        gplotmatrix(files(:,[i,j]),[],files(:,5));
        title(['第',num2str(i),'列与第',num2str(j),'列的按组划分的散点图'])
    end;
end;
%num2str()转换成字符串表示

%4.
figure;
boxplot(files(:,1:4)); %画出盒图
x=input('认为哪个属性有离散点：');
avg=mean(files(:,x)); %均值
disp(['均值为',num2str(avg)]); %输出均值

a=std(files(:,x)); %标准差
disp(['标准差为',num2str(a)]); %输出标准差

bianhao=[]; %保存值
for i=1:length(files(:,x))
    if(abs(files(i,2)-avg)>3*a)
        bianhao=[bianhao,i];
    end
end
disp(['用3σ原则找到离群点个数为:',num2str(length(bianhao))]);
liqun=files(bianhao,x);

%5.
[m,n]=size(files);
s=1:m;
label1=files(s,n); %测试集标签
b=zeros(1,length(files(:,5))); 
train=files(b==0,:);
test=files(bianhao,:);
Mdl = fitcecoc(train(:,1:4),train(:,5)); %训练分类器

label = predict(Mdl,test(:,1:4));  %预测标签

prc=mean(label==test(:,5));
disp('用SVM分类器预测离群点种类准确率为:');
disp(prc);


yuc=test(:,5);


m0=length(label);
u=zeros(m0,3);   
v=zeros(m0,3);   
for i=1:m0
 if label(i)==0
    u(i,:)=[1 0 0];
 else if label(i)==1
    u(i,:)=[0 1 0];
     else
         u(i,:)=[0 0 1];
     end
  end
end
u=u';     %取转置


for i=1:m0
    if yuc(i)==0
        v(i,1)=1;
    elseif yuc(i)==1
        v(i,2)=1;
    elseif yuc(i)==2
        v(i,3)=1;
    end
end
        
        

v=v';     %取转置

plotconfusion(u,v);        %输出混淆矩阵