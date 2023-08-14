%%
clc
clear
close
%网络构建
layers = [
    imageInputLayer([224 224 3],"Name","imageinput")
    convolution2dLayer([3 3],8,"Name","conv_1","Padding","same","Stride",[2 2])
    batchNormalizationLayer("Name","batchnorm_1")
    reluLayer("Name","relu_1")
    maxPooling2dLayer([2 2],"Name","maxpool_1","Padding","same","Stride",[2 2])
    convolution2dLayer([3 3],16,"Name","conv_2","Padding","same","Stride",[2 2])
    batchNormalizationLayer("Name","batchnorm_2")
    reluLayer("Name","relu_2")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Padding","same","Stride",[2 2])
    convolution2dLayer([3 3],32,"Name","conv_3","Padding","same","Stride",[2 2])
    batchNormalizationLayer("Name","batchnorm_3")
    reluLayer("Name","relu_3")
    maxPooling2dLayer([2 2],"Name","maxpool_3","Padding","same","Stride",[2 2])
    convolution2dLayer([3 3],64,"Name","conv_4","Padding","same","Stride",[2 2])
    batchNormalizationLayer("Name","batchnorm_4")
    reluLayer("Name","relu_4")
    fullyConnectedLayer(7,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
%%

imgpath='Class11(224)';   %读取数据集
huaf=0.8;   %训练集与测试集比例
imds = imageDatastore(imgpath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');



[imdsTrain,imdsTest] = splitEachLabel(imds,huaf,'randomized'); %划分训练集与测试集

label=imdsTest.Labels;  %获得测试集真实标签
imdsTrain = augmentedImageDatastore([224,224,3],imdsTrain,'ColorPreprocessing','gray2rgb');
imdsTest = augmentedImageDatastore([224,224,3],imdsTest,'ColorPreprocessing','gray2rgb');

%%


%%
%网络训练参数
miniBatchSize = 2;
% valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
valFrequency = floor(numel(imdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',50, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsTest, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',1, ...
    Plots="training-progress");
%%
net = trainNetwork(imdsTrain,layers,options); %利用训练集训练网络
save('net.mat','net') %保存网络

%%

[label_juanji,score_juanji]=classify(net,imdsTest); %测试集输入网络预测标签

acc=mean(label_juanji==label) %计算分类准确率









