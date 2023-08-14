% clc;close all;clear;
function recognize
addpath('util/');
load('all_data_cnn.mat');
load datanum
% load final_cnn
% I=imread('./train_letters/l8.jpg');

for pp=1:length(tp)
%  I=imread(strcat(num2str(pp),'.jpg'));
    I=tp{pp};
    imwrite(uint8(I),strcat(num2str(pp),'.jpg'));
figure;imshow(I,[]);
if(length(size(I))>2)
    I=rgb2gray(I);
else
    I=double(I);
end

test_x=imresize(I,[28,28]);
test_y=zeros(10,40);
for oo=6:6
test_y(1,oo+1)=1;
end
% save hty test_x test_y

test_x=double(test_x);
test_y =double(test_y');


% 带标签的测试样本
k=size(test_x,3);
er=0;%统计错误识别的个数

for i=1:k
%     fprintf('第%d幅图片的识别情况：\n',pp);
    [bad,h] = cnntest(cnn, test_x(:,:,i), test_y(:,i)); %er是识别错误的个数与测试总字符数之比 
    er=er+numel(bad);
   % disp(['size(bad)=' num2str(size(bad))]);
   % disp(['bad=' num2str(numel(bad))]);
    %disp(['ernum=' num2str((er)) ]);
    switch(h)
        case 0
            fprintf('0');
        case 1
            fprintf('1');
        case 2
            fprintf('2');
        case 3
            fprintf('3');
        case 4
            fprintf('4');
        case 5
            fprintf('5');
        case 6
            fprintf('6');
        case 7
            fprintf('7');
        case 8
            fprintf('8');
        case 9
            fprintf('9');
    end
end  
% disp(['错误个数：' num2str(er)]);
%disp(['size(test_y, 2)=' num2str(size(test_y, 2))]);
er = er / size(test_y, 2); % 计算错误率,size(y, 2)是测试样本的数量 
 %plot mean squared error  
%  figure;
% plot(cnn.rL);  % 代价函数值，也就是训练样本时求的均方误差值，
% title('\bf代价函数--样本数量');
% xlabel('\bf样本数量');
% ylabel('\bf代价函数H(W,b)');
 %show test error  
% disp([num2str(er*100) '% error']); 
end
fprintf('\n');
