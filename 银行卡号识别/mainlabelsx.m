%训练银行卡样本集(输入向量和目标向量)----hty
clc;
clear;
close all
trainNum=2;
for classnum=0:9
for kk=0:trainNum-1 
    %p1=ones(28,28);% 初始化28×28的二值图像像素值(全白)
    switch classnum
        case 0 
            m =strcat('trainx\0\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)  
        case 1
             m =strcat('trainx\1\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)  
        case 2
             m =strcat('trainx\2\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 3
             m =strcat('trainx\3\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 4
             m =strcat('trainx\4\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 5
             m =strcat('trainx\5\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 6
             m =strcat('trainx\6\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 7
             m =strcat('trainx\7\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 8
             m =strcat('trainx\8\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 9
             m =strcat('trainx\9\',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
    end
    x=imread(m,'jpg');% 读入训练样本图像文件  
    if(length(size(x))>2)
        x=rgb2gray(x);
    end
%     [labels,bw]=KmeansSg(x,3);
%     if(classnum==0||classnum==4)
%     [L, num] = bwlabel(bw, 8);
%     for i=1:num
%         if(size(find(L==i))<300)
%             bw(L==i)=0;
%         end
%     end
%     end
%         figure;
%     imshow(bw,[]);
%     bw=Otsu(x);
%     bw=edge(x,'canny');
%     bw=im2bw(x,0.25);% 将读入的训练样本图像转换为二值图像  
%     figure;
%     imshow(bw,[]);
%     bw=im2uint8(bw);
    bw=imresize(x,[28,28]);
%     figure;
%     imshow(bw,[]);
%     [i,j]= find(bw==0);% 寻找二值图像中像素值为0(黑)的行号和列号  
%     imin=min(i);% 寻找二值图像中像素值为0(黑)的最小行号 
%     imax=max(i);% 寻找二值图像中像素值为0(黑)的最大行号   
%     jmin=min(j);% 寻找二值图像中像素值为0(黑)的最小列号   
%     jmax=max(j);% 寻找二值图像中像素值为0(黑)的最大列号   
%     bw1=bw(imin:imax,jmin:jmax);% 截取图像像素值为0(黑)的最大矩形区域 
%    % rate=28/max(size(bw1));% 计算截取图像转换为28×28的二值图像的缩放比例(由于缩放比例  
%                                % 大多数情况下不为28的倍数,所以可能存在转换误差)
%     bw1=imresize(bw1,[28,28]);% 将截取图像转换为28×28的二值图像 
%   % [i,j]=size(bw1);% 转换图像的大小   
%  %  i1=round((28-i)/2);% 计算转换图像与标准28×28的图像的左边界差    
%  %  j1=round((28-j)/2);% 计算转换图像与标准28×28的图像的上边界差    
%  %  p1(i1+1:i1+i,j1+1:j1+j)=bw1;% 将截取图像转换为标准的28×28的图像 
%    p1=bw1;
%    p1= -1.*p1+ones(28,28);% 反色处理    % 以图像数据形成神经网络输入向量 
%    for m=0:27      
%    p(m*28+1:(m+1)*28,kk+1)=bw(1:28,m+1);   
%    end    % 形成神经网络目标向量  
   train_x(:,:,kk+1+trainNum*classnum)=bw;
   train_y(kk+1+trainNum*classnum,classnum+1)=1;%训练样本标签
end
end
% for kk=0:9
%     m =strcat('train_nums\num',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)    
%     x=imread(m,'jpg');% 读入训练样本图像文件   
%     bw=im2bw(x,0.5);% 将读入的训练样本图像转换为二值图像  
%     bw=im2uint8(bw);
%     bw=imresize(bw,[28,28]);
%     train_x(:,:,kk+27)=bw;
%     train_y(kk+27,kk+27)=1;%训练样本标签
% end


%汉字单独训练
% for kk=0:6
%     m =strcat('train_word\hanzi',int2str(kk+1),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)    
%     x=imread(m,'jpg');% 读入训练样本图像文件   
%     bw=im2bw(x,0.5);% 将读入的训练样本图像转换为二值图像  
%     bw=im2uint8(bw);
%     bw=imresize(bw,[28,28]);
%     train_x(:,:,kk+1)=bw;
%     train_y(kk+1,kk+1)=1;%训练样本标签
% end
testNum=1;
test_y=zeros(10,5);
trainNum=0;%重新限制
for classnum1=0:9
for k=0:testNum-1
    %p2=ones(28,28);% 初始化28×28的二值图像像素值(全白)   
     switch classnum1
        case 0 
             m2 =strcat('test\0\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)  
        case 1
             m2 =strcat('test\1\',int2str(k+1+trainNum)','.jpg');% 形成训练样本图像的文件名(0～259.bmp)  
        case 2
             m2 =strcat('test\2\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 3
             m2 =strcat('test\3\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 4
             m2 =strcat('test\4\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 5 
             m2 =strcat('test\5\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)  
        case 6
             m2 =strcat('test\6\',int2str(k+1+trainNum)','.jpg');% 形成训练样本图像的文件名(0～259.bmp)  
        case 7
             m2 =strcat('test\7\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 8
             m2 =strcat('test\8\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
        case 9
             m2 =strcat('test\9\',int2str(k+1+trainNum),'.jpg');% 形成训练样本图像的文件名(0～259.bmp)
     end 
    x=imread(m2,'jpg');% 读入训练样本图像文件   
     if(length(size(x))>2)
        x=rgb2gray(x);
    end
    bw=imresize(x,[28,28]);
%     [i,j]= find(bw==0);% 寻找二值图像中像素值为0(黑)的行号和列号  
%     imin=min(i);% 寻找二值图像中像素值为0(黑)的最小行号 
%     imax=max(i);% 寻找二值图像中像素值为0(黑)的最大行号   
%     jmin=min(j);% 寻找二值图像中像素值为0(黑)的最小列号   
%     jmax=max(j);% 寻找二值图像中像素值为0(黑)的最大列号   
%     bw2=bw(imin:imax,jmin:jmax);% 截取图像像素值为0(黑)的最大矩形区域 
%    % rate=28/max(size(bw1));% 计算截取图像转换为28×28的二值图像的缩放比例(由于缩放比例  
%                                % 大多数情况下不为28的倍数,所以可能存在转换误差)
%     bw2=imresize(bw2,[28,28]);% 将截取图像转换为28×28的二值图像 
%   % [i,j]=size(bw1);% 转换图像的大小   
%  %  i1=round((28-i)/2);% 计算转换图像与标准28×28的图像的左边界差    
%  %  j1=round((28-j)/2);% 计算转换图像与标准28×28的图像的上边界差    
%  %  p1(i1+1:i1+i,j1+1:j1+j)=bw1;% 将截取图像转换为标准的28×28的图像 
%    p2=bw2;
%    p2= -1.*p2+ones(28,28);% 反色处理    % 以图像数据形成神经网络输入向量 
%    for m=0:27       
%    test_x(m*28+1:(m +1)*28,k+1)=bw(1:28,m+1);   
%    end    % 形成神经网络目标向量  
   test_x(:,:,k+1+testNum*classnum1)=bw;
   test_y(k+1+testNum*classnum1,classnum1+1)=1;
% switch k   
%     case{0,5}  % 字母A       
%     test_y(k+1,1)=1;   
%     case{1,6} % 字母B    
%     test_y(k+1,2)=1;    
%     case{2,7}  % 字母C      
%     test_y(k+1,3)=1;    
%     case{3,8}  % 字母D      
%     test_y(k+1,4)=1;    
%     case{4,9}  %字母E           
%     test_y(k+1,5)=1;       
%     case{5,31}  %字母F        
%     test_y(k+1,6)=1;    
%     case{6,32}  % 字母G       
%     test_y(k+1,7)=1;     
%     case{7,33}  % 字母H        
%     test_y(k+1,8)=1;            
%     case{8,34}  % 字母I     
%     test_y(k+1,9)=1;       
%     case{9,35}  % 字母J      
%     test_y(k+1,10)=1; 
%     case{10,36}  % 字母K     
%     test_y(k+1,11)=1;
%     case{11,37}  % 字母L     
%     test_y(k+1,12)=1; 
%     case{12,38}  % 字母M    
%     test_y(k+1,13)=1; 
%     case{13,39}  % 字母N     
%     test_y(k+1,14)=1;
%     case{14,40}  % 字母O      
%     test_y(k+1,15)=1;
%     case{15,41}  % 字母P      
%     test_y(k+1,16)=1;
%     case{16,42}  % 字母Q      
%     test_y(k+1,17)=1; 
%     case{17,43}  % 字母R     
%     test_y(k+1,18)=1; 
%     case{18,44}  % 字母S     
%     test_y(k+1,19)=1; 
%     case{19,45}  %字母T     
%     test_y(k+1,20)=1; 
%     case{20,46}  % 字母U     
%     test_y(k+1,21)=1;
%     case{21,47}  % 字母V      
%     test_y(k+1,22)=1; 
%     case{22,48}  % 字母W      
%     test_y(k+1,23)=1;
%     case{23,49}  % 字母X    
%     test_y(k+1,24)=1; 
%     case{24,50}  % 字母Y     
%     test_y(k+1,25)=1; 
%     case{25,51}  % 字母Z      
%     test_y(k+1,26)=1;    
% end
end
end
%save LT test_x test_y;  

save all_data_labelsx train_x train_y test_x test_y;    % 存储形成的训练样本集(输入向量和目标向量)
disp('输入向量和目标向量生成结束！')