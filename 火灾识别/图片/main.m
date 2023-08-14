%  程序名称: 主程序
%main()
%9.4.7 
 
clc
clear
close all

%  读取图像文件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgs_array = read_images();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  彩色图像灰度化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colorflame_img1 = imgs_array(1).img;     %自己选择K值，表示读取该文件夹下第几幅图像，实验选择了第一幅图像
Gray_Img  = RGBtoGray(colorflame_img1);

figure(10)
imshow(colorflame_img1)
title('原始图像')                    %第一幅图像
figure(11)
imshow(uint8(Gray_Img.Max_Intensity))
title('最大值法')
figure(12)
imshow(uint8(Gray_Img.Mean_Intensity))
title('平均值法')
figure(13)
imshow(uint8(Gray_Img.Weight_Intensity))
title('加权平均值法')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  利用5种边缘检测算子进行边缘检测
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Extra_Edge  = operator5(colorflame_img1);
figure(14)
imshow(Extra_Edge.sobel_edge)
title('边缘提取(sobel算子)')
figure(15)
imshow(Extra_Edge.prewitt_edge)
title('边缘提取(prewitt算子)')
figure(16)
imshow(Extra_Edge.roberts_edge)
title('边缘提取(roberts算子)')
figure(17)
imshow(Extra_Edge.log_edge)
title('边缘提取(log算子)')
figure(18)
imshow(Extra_Edge.canny_edge)
title('边缘提取(canny算子)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  火焰检测，用三幅图像
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flame_image1  = flame_detection(colorflame_img1);
figure(19)
imshow(uint8(flame_image1))
title('火焰模型特征提取')            %第一幅图像

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
