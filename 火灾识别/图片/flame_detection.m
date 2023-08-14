function flame_image  = flame_detection(color_img)
 %9.4.5 
%  函数功能：实现火焰检测
%  输入参数：color_img  彩色图像
%  输出参数：flame_image   检测到的彩色火焰图像
 
[M,N,~] = size(color_img);
R = double(color_img(:,:,1));
G = double(color_img(:,:,2));
B = double(color_img(:,:,3));

flame_logical = [];
for i=1:M
    for j=1:N
%         temp1 = G(i,j)/(R(i,j)+1);
%         temp2 = B(i,j)/(R(i,j)+1);
%         temp3 = G(i,j)/(G(i,j)+1);
        
        if  R(i,j)>G(i,j)&&G(i,j)> B(i,j)&& R(i,j)>150&&G(i,j)<200&&B(i,j)<150
%             temp1 >= 0.25 &&  temp1 <= 0.65 && temp2 >= 0.05 &&  temp2 <= 0.45 && temp3 >= 0.20 &&  temp1 <= 0.60
          
            flame_logical(i,j) = 1;
        else
            flame_logical(i,j) = 0;
        end
      end
end
flame_image = [];
flame_image(:,:,1) = uint8(double(R).*flame_logical);
flame_image(:,:,2) = uint8(double(G).*flame_logical);
flame_image(:,:,3) = uint8(double(B).*flame_logical);