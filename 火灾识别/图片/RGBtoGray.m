function Gray_Img  = RGBtoGray(color_img)
 %9.4.2
%  函数功能：实现彩色图像的灰度化
%  输入参数：color_img  彩色图像
%  输出参数：Gray_Img   结构体，包含三种灰度图像


[M,N,~] = size(color_img);
R = color_img(:,:,1);
G = color_img(:,:,2);
B = color_img(:,:,3);
 
Wr = 0.11;
Wg = 0.3;
Wb = 0.59;
Gray_Img.Max_Intensity = [];
Gray_Img.Mean_Intensity= [];
Gray_Img.Weight_Intensity = [];
 
for i=1:M
    for j=1:N
        temp = max([R(i,j),G(i,j),B(i,j)]);
        Gray_Img.Max_Intensity(i,j) = temp(1);
        Gray_Img.Mean_Intensity(i,j) = (R(i,j) + G(i,j) + B(i,j))/3;
        Gray_Img.Weight_Intensity(i,j) = (Wg*R(i,j) + Wb*G(i,j) + Wr*B(i,j))/3;
    end
end