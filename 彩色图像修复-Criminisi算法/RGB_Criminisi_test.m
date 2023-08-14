
clc;
clear;
tic
% imagepath =imread( 'chunhua.bmp');    %原图像
% maskpath =imread('chunhuamask.bmp');  %破损图像
% fillColor=[0,0,0];     %破损图像中标定的破损区域RGB颜色值
imagepath =imread( '1.png');    %原图像
maskpath =imread('2.png');  %破损图像
% fillColor=[255,255,0];     %破损图像中标定的破损区域RGB颜色值，黄色
fillColor=[0,255,0];  %绿色


[Psnr,inpaintedImg] =RGB_Criminisi(imagepath,maskpath,fillColor);
toc   
  

