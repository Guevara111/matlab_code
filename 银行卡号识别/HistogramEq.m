function out=HistogramEq(I) 
%直方图均衡化   
[height,width] = size(I);    
%进行像素灰度统计;  
NumPixel = zeros(1,256);%统计各灰度数目，共256个灰度级  
for i = 1:height  
    for j = 1: width  
        NumPixel(I(i,j) + 1) = NumPixel(I(i,j) + 1) + 1;%对应灰度值像素点数量增加一  
    end  
end  
%计算灰度分布密度  
ProbPixel = zeros(1,256);  
for i = 1:256  
    ProbPixel(i) = NumPixel(i) / (height * width * 1.0);  
end  
%计算累计直方图分布  
CumuPixel = zeros(1,256);  
for i = 1:256  
    if i == 1  
        CumuPixel(i) = ProbPixel(i);  
    else  
        CumuPixel(i) = CumuPixel(i - 1) + ProbPixel(i);  
    end  
end  
%累计分布取整  
CumuPixel = uint8(255 .* CumuPixel + 0.5);  
%对灰度值进行映射（均衡化）  
for i = 1:height  
    for j = 1: width  
        I(i,j) = CumuPixel(uint8(I(i,j)+1));  
    end  
end

out=I;%保存最终结果