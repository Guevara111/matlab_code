bookCovers = imageDatastore('Test_img');


thumbnailGallery = [];
for i = 1:length(bookCovers.Files)
    I = readimage(bookCovers,i);
    thumbnail = imresize(I,[300 300]);
    thumbnailGallery = cat(4,thumbnailGallery,thumbnail);
end

figure
montage(thumbnailGallery);


imageIndex = indexImages(bookCovers);

%%
queryImage = imread('E:\咸鱼\特征点匹配\Target_img\B371K8_5.jpg');

imageIDs = retrieveImages(queryImage,imageIndex,'NumResults',10,'Metric','L1');


bestMatch = imageIDs(1);
bestImage = imread(imageIndex.ImageLocation{bestMatch});
figure(1)

imshowpair(queryImage,bestImage,'montage')
title('匹配的最相似的车辆')
figure(2)
for i=1:9
subplot(3,3,i)
bestMatch = imageIDs(i);
Image = imread(imageIndex.ImageLocation{bestMatch});
imshow(Image)
 titleName = strcat('第',num2str(i),'个最相似的车辆');
title(titleName)
hold on
end

