function Extra_Edge  = operator5(color_img)
  %9.4.3
%  函数功能：利用5种边缘检测算子进行边缘检测
%  输入参数：color_img  彩色图像
%  输出参数：Gray_Img   结构体，包含5种算子提取的边缘

Gral_Img = rgb2gray(color_img);
Extra_Edge.sobel_edge = edge(Gral_Img,'sobel');
Extra_Edge.prewitt_edge = edge(Gral_Img,'prewitt');
Extra_Edge.roberts_edge = edge(Gral_Img,'roberts');
Extra_Edge.log_edge = edge(Gral_Img,'log');
Extra_Edge.canny_edge = edge(Gral_Img,'canny');