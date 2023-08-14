%通过K-means进行图像分割
function [IX,IMMM]=KmeansSg(IM,cent)
IM=uint8(IM);
IM=IM(:,:,1);
IM=double(IM);
[maxX,maxY]=size(IM);
 
[a,IX]=imKmeans(IM,cent);
store(1:9)=[255,230,200,170,140,110,80,50,0];
% store(1:2)=[0,255];

IMMM=zeros(maxX,maxY);%初始分割矩阵
for i=1:maxX
    for j=1:maxY
        for pp=1:cent
         if IX(i,j)==pp
            IMMM(i,j)=store(pp);
         end
        end
    end
end
IMMM=uint8(IMMM);

 