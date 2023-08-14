bookCovers = imageDatastore('Test_img');%构建待检测图像数据集
imageIndex = indexImages(bookCovers); %构建词袋
%%
queryImage = imread('Target_img\B371K8_5.jpg');%匹配图像

queryROI = [475.5 338.75 588 693];%确定roi区域
%%
imageIDs = retrieveImages(queryImage,imageIndex,'ROI',queryROI) %词袋匹配
%%
% 绘图
bestMatch = imageIDs(1);
bestImage = imread(imageIndex.ImageLocation{bestMatch});
figure(1)
imshowpair(queryImage,bestImage,'montage')
title('匹配的最相似的车辆')
figure(2)
for i=1:6
subplot(2,3,i)
bestMatch = imageIDs(i);
Image = imread(imageIndex.ImageLocation{bestMatch});
imshow(Image)
 titleName = strcat('第',num2str(i),'个最相似的车辆');
title(titleName)
hold on
end