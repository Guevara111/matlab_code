clear; close all; clc;  
% addpath('../data');  
% addpath('../util'); 

% load PT;
% load('data/mnist_uint8.mat');
%load LT;
load all_data_labelsx.mat
%   
% train_x = double(reshape(train_x,28,28,140))/255;%训练样本为28*28的矩阵，总共有30个样本
% test_x = double(reshape(test_x,28,28,1))/255;  
% train_y = double(train_y'); 
% test_y =double(test_y');  
p_train=size(train_y);
p_test=size(test_y);
num=p_train(1);%训练集数量
testnum=p_test(1);%测试集数量
% train_x = double(reshape(p,28,28,num))/255; 
% test_x = double(reshape(test_x,28,28,testnum))/255; 
% train_y = double(t');  
% test_y =double(test_y'); 



% train_x = double(reshape(train_x,28,28,num))/255; 
% test_x = double(reshape(test_x,28,28,testnum))/255; 
train_x=double(train_x);
test_x=double(test_x);
train_y = double(train_y');  
test_y =double(test_y'); 
% 
% figure(1)
% 
%       for k=1:10
% %     k=fix(i/10+1);
%             subplot(fix(10/10+1),10,k);imshow(train_x(:,:,k),[]);title(num2str(k));
%       end
% figure(2)
% 
%       for k=1:testnum
% %     k=fix(i/10+1);
%             subplot(fix(testnum/10+1),10,k);imshow(test_x(:,:,k),[]);title(num2str(k));
%       end
cnn.layers = {  
    struct('type', 'i') %input layer  
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer  
    struct('type', 's', 'scale', 2) %sub sampling layer  
    struct('type', 'c', 'outputmaps', 10, 'kernelsize', 5) %convolution layer  
    struct('type', 's', 'scale', 2) %subsampling layer  
%     struct('type', 'c', 'outputmaps', 20, 'kernelsize', 5) %convolution layer 
%     struct('type', 's', 'scale', 2) %subsampling layer
};  %6 10 0.08 500 28% error
  
% 这里把cnn的设置给cnnsetup，它会据此构建一个完整的CNN网络，并返回  
cnn = cnnsetup(cnn, train_x, train_y);  
  
% 学习率  
opts.alpha = 0.09;  
% 每次挑出一个batchsize的batch来训练，也就是每用batchsize个样本就调整一次权值，而不是  
% 把所有样本都输入了，计算所有样本的误差了才调整一次权值  
% BatchSize是批大小， 通常是用在数据库的批量操作里面
opts.batchsize =1;   
% 训练次数，用同样的样本集。我训练的时候：  
%手写数字集（60个训练样本 10个测试样本）
% 100的时候 0% error
% 50的时候 3.333%error  0%error 0.5s
% 10的时候 80% error  
%手写数字集（140个训练样本 40个测试样本）
%10的时候  25% error 6.5s
%50       2.5% error每趟6.5s
%100      2.5% error每趟6.5s 
opts.numepochs=1000;  
  
% 然后开始把训练样本给它，开始训练这个CNN网络  
cnn = cnntrain(cnn, train_x, train_y, opts);  

%不带标签的测试样本
% kk=0;
% m =strcat('test_letters\',int2str(kk),'.jpg');% 形成训练样本图像的文件名(100-139.jpg)
% x=imread(m,'jpg');% 读入训练样本图像文件   
% bw=im2bw(x,0.5);% 将读入的训练样本图像转换为二值图像  
% bw=im2uint8(bw); 
% for m=0:27%测试样本
%    test(m*28+1:(m +1)*28,1)=bw(1:28,m+1); 
% end
% test=double(reshape(test,28,28,1))/255; 
% net=cnnff2(cnn,test);
% [~,h]=max(net.o);
% disp(['识别结果：' num2str(h-1) ]);

% 带标签的测试样本
k=size(test_x,3);
er=0;%统计错误识别的个数
for i=1:k
    fprintf('第%d幅图片的识别情况：\n',i);
    bad = cnntest(cnn, test_x(:,:,i), test_y(:,i)); %er是识别错误的个数与测试总字符数之比 
    er=er+numel(bad);
   % disp(['size(bad)=' num2str(size(bad))]);
   % disp(['bad=' num2str(numel(bad))]);
    %disp(['ernum=' num2str((er)) ]);
end
disp(['错误个数：' num2str(er)]);
%disp(['size(test_y, 2)=' num2str(size(test_y, 2))]);
er = er / size(test_y, 2); % 计算错误率,size(y, 2)是测试样本的数量 
 %plot mean squared error  
plot(cnn.rL);  % 代价函数值，也就是训练样本时求的均方误差值，
title('\bf代价函数--样本数量');
xlabel('\bf样本数量');
ylabel('\bf代价函数H(W,b)');
 %show test error  
disp([num2str(er*100) '% error']); 
save all_data_cnnx cnn





 