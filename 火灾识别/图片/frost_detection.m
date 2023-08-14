function [frog_img,Gral_pic]  = frost_detection(color_img)
%9.4.6 
%  函数功能：实现青灰色烟雾检测
%  输入参数：color_img  彩色图像
%  输出参数：frog_img   检测到的烟雾图像
%           Gral_pic   灰度图像

N = 2; 
Gral_pic = rgb2gray(color_img);
[row,col] = size(Gral_pic); 
 
h = imhist(Gral_pic)/row/col;           %归一化
Pa = cumsum(h);                     %累计直方图       
temp1 = abs(Pa - 1/N);
temp2 = abs(1 - Pa - 1/N);
temp = temp1 + temp2;
[~,under_value] = min(temp);
seg_img = ~(Gral_pic > under_value);
frog_img = double(Gral_pic).*seg_img;%本程序适合青灰色烟雾的检测