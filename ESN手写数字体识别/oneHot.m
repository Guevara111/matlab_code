function trainLabel10Dim=oneHot(originalLabels,Dim)
%%对于一个输入的标签，采用oneHot编码，
%%trainLabel10Dim 每一行为一个标签
%%originalLabels 表示原始的标签，Dim表示类别数
%%对于手写数字分类，采用十维的向量来表示，
%%如 1 ,[1,0,0,0,0,0,0,0,0,0]
%%如10, [0,0,0,0,0,0,0,0,0,1]
originalLabels(originalLabels==0)=10;              %将 0 号标签改为 10
trainLabel10Dim=zeros(length(originalLabels),Dim); %提前设置矩阵，减少运行时间
for k=1:length(originalLabels)
    trainLabel10Dim(k,originalLabels(k))=1;         %将对应位 置1
end
end


