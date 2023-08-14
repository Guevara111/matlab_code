function RGBPixel_Dis = RGB_distribution()
%9.4.4 
%  函数功能：估计RGB分量的分布
%  输入参数：不需要输入参数
%  输出参数：RGBPixel_Dis   结构体，RGB三分量的分布
 
pathname = 'D:\yjbs\fire\photo\'; %uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
cd(pathname);
files = dir('*.jpg');
 
K = size(files,1);
 
RPixel_Dis = 0;
GPixel_Dis = 0;
BPixel_Dis = 0;
 
for i=1:K
    temp = imread(files(i).name);
    R = temp(:,:,1);
    G = temp(:,:,2);
    B = temp(:,:,3);
    [counts,x] = imhist(R);
    RPixel_Dis = RPixel_Dis + counts;
    [counts,x] = imhist(G);
    GPixel_Dis = GPixel_Dis + counts;
    [counts,x] = imhist(B);
    BPixel_Dis = BPixel_Dis + counts;
end
 
RGBPixel_Dis.RPixel_Dis = RPixel_Dis;
RGBPixel_Dis.GPixel_Dis = GPixel_Dis;
RGBPixel_Dis.BPixel_Dis = BPixel_Dis;