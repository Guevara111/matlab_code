function imgs_array = read_images()
  %9.4.1
%  函数功能：读取文件夹里的所有图像
%  输入参数：不需要输入参数
%  输出参数：imgs_array   结构体，包含所读图像
pathname = 'C:\Users\86182\Desktop\Fire\图片\';
%pathname=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
cd(pathname);
files = dir('*.jpg');
 
K = size(files,1);
imgs_array = [];

for i=1:K
    temp = imread(files(i).name);
    imgs_array(i).img = temp;
end

