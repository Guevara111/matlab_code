[filename, pathname] = uigetfile('*.xlsx');
path = fullfile(pathname, filename); 

data=table2array(readtable(path));

figure(1)
subplot(1,2,1)
histogram(data(:,3));
title('花瓣长度直方图')

subplot(1,2,2)
histogram(data(:,4));
title('花瓣宽度直方图')

%%
%相关性系数
for i=1:4
    for j=i+1:4
        R = corrcoef(data(:,i),data(:,j));
        
        disp(['第',num2str(i),'列与第',num2str(j),'列的相关性系数为：'])
        disp(R)
    end
end
    

%%
m=0;
for i=1:4
    for j=i+1:4
        m=m+1;
        figure(m+1)
        gplotmatrix(data(:,[i,j]),[],data(:,5))
        
        title(['第',num2str(i),'列与第',num2str(j),'列的按组划分的散点图'])
    end
end
        
%%
% % % %箱形图分开放
% % % fibure(8)
% % % for i=1:4
% % %     subplot(2,2,i)
% % %     boxplot(data(:,i))
% % % end

%箱形图放一起
figure(8)
boxplot(data(:,1:4))



%%

xmm=input('我认为离群点的列数为：');
ave = mean(data(:,xmm));%mean 求解平均值
disp(['数据均值为',num2str(ave)])



u = std(data(:,xmm));%求解标准差
disp(['数据标准差为',num2str(u)])


suoying=[];

for i=1:length(data(:,xmm))
    if(abs(data(i,2)-ave)>3*u)
        suoying=[suoying,i];
    end
end
disp(['用3σ准则找到该数据离群点个数为:',num2str(length(suoying))]);

liqun=data(suoying,xmm);
disp(['用3σ准则找到该数据离群点已保存至变量‘liqun’']);
disp(['其索引已保存至变量‘suoying’']);


%%

supyin_b=zeros(1,length(data(:,5)));
supyin_b(1,suoying)=1;  

train=data(supyin_b==0,:);
test=data(suoying,:);


Mdl = fitcecoc(train(:,1:4),train(:,5)); %训练分类器

label = predict(Mdl,test(:,1:4));  %预测标签

prc=mean(label==test(:,5));
disp('用正常数据训练SVM分类器预测离群点种类准确率为:');


disp(prc)
cm = confusionchart(test(:,5),label);
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

