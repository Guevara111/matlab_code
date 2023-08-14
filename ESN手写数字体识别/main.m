%加载路径和加载数据
initTAO
%加载数据和标签，并归一化训练、测试数据
normal_trainData=trainData/255;
normal_testData =testData/255;
%将训练标签展开
trainResult10 = oneHot(train_labels1,10);

%% 设置网络参数
Nr=200;                 %储备池的大小
spectralRadius=0.85;    %权谱半径，小于1
regularization=1e-3;    %岭回归的正则化系数
washOut=100;
inputScaling=0.5;
esn=ESN(Nr,'spectralRadius',spectralRadius,'regularization',regularization,'inputScaling',inputScaling);

%训练
trainLen=9000;
esn.train(normal_trainData(1:trainLen,:),trainResult10(1:trainLen,:),washOut)
%预测
train_predict=esn.predict(normal_trainData(1:trainLen,:));
%训练精度
[accuracy,precious,predictValue]= resultsProcess(train_predict.',train_labels1(1:trainLen));
fprintf('训练集正确率：%d / %d \n',precious,trainLen)
fprintf('训练精度: %f\n', accuracy)

%测试精度
testLen=1000;
test_predict=esn.predict(normal_testData(1:testLen,:));
[accuracy,precious,predictValue]= resultsProcess(test_predict',test_labels1(1:testLen));
fprintf('测试集正确率：%d / %d \n',precious,testLen)
fprintf('训练精度: %f\n', accuracy)

