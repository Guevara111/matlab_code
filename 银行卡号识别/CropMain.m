%印刷体识别
clc;clear;close all;
addpath('util/');
addpath('凹凸/');
inputpath='凹凸/';
fdir=dir(strcat(inputpath,'*.jpg'));
p=size(fdir);
method=2;%定位方法
levelth=0.3;%水平分割缩放阈值
for i=2:p(1)
im=imread(fdir(i).name);
imtp=imresize(im,0.25);
%图像灰度化
if(length(size(im))>1)
    im=double(rgb2gray(im));
else
    im=double(im);
end
    im=imresize(im,0.25);
    
    th=graythresh(im);
    pt=size(im);
    
%提取上下位面  
    if(method==1)
       im=GuassSmoothfilter(im)*255;%平滑
       cent=2;
       [Labels,BW]=KmeansSg(im,cent);%kmeans聚类
       [pMax,pMin]=Findline(BW);%Hough变换
       downlevel=pMax.y-(pMax.y-pMin.y)*0.30;
       uplevel=pMin.y+(pMax.y-pMin.y)*0.55;
    else
       [pMax,pMin,pxMax,pxMin]=levelSg(im,levelth);%水平集分割
       downlevel=pMax-(pMax-pMin)*0.29;
       uplevel=pMin+(pMax-pMin)*0.55;
    end
    
   imcrop=im(uplevel:downlevel,:);%定位银行卡号
   po=size(imcrop);
   imtpcrop=zeros(po(1),po(2),3);
   imtpcrop(1:po(1),:,1)=imtp(uplevel:downlevel,:,1);
   imtpcrop(1:po(1),:,2)=imtp(uplevel:downlevel,:,2);
   imtpcrop(1:po(1),:,3)=imtp(uplevel:downlevel,:,3);
   figure;
   imshow(imcrop,[]);title('灰度切割')
   figure;
   imshow(imtpcrop,[]);title('彩色切割')
   
   srcyuv=rgb2yuv(imtpcrop);%rgb转换为YUV通道
   figure;
   imshow(srcyuv(:,:,2),[]);title('yuv通道')
   edg=edge(srcyuv(:,:,3),'sobel');%canny边缘检测
   
   figure;
   B=im2bw(uint8(imcrop),0.2);
   imshow(B,[]);title('二值化')
   
   %[L,num] = bwlabel(~B,4);%获取联通区域
   imwrite(uint8((~B)*255),'x.jpg');
   figure;
   imshow(edg,[]);title('边缘')
   B=uint8((~B)*255);
   cropAll(B)%最终裁剪
    recognize%卡号识别
   
end