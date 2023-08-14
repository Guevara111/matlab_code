bookCovers = imageDatastore('Test_img');


imageIndex = indexImages(bookCovers);

%%
queryImage = imread('E:\咸鱼\特征点匹配\Target_img\B371K8_5.jpg');
imshow(queryImage)
queryROI = getPosition(imrect)
imageIDs = retrieveImages(queryImage,imageIndex,'ROI',queryROI)

%%

[imageIDs, ~, queryWords] = retrieveImages(queryImage,imageIndex);
bestMatch = imageIDs(2);
bestImage = imread(imageIndex.ImageLocation{bestMatch});
bestMatchWords = imageIndex.ImageWords(bestMatch);

%%
queryWordsIndex     = queryWords.WordIndex;
bestMatchWordIndex  = bestMatchWords.WordIndex;

tentativeMatches = [];
for i = 1:numel(queryWords.WordIndex)
    
    idx = find(queryWordsIndex(i) == bestMatchWordIndex);
    
    matches = [repmat(i, numel(idx), 1) idx];
    
    tentativeMatches = [tentativeMatches; matches];
    
end

%%
points1 = queryWords.Location(tentativeMatches(:,1),:);
points2 = bestMatchWords.Location(tentativeMatches(:,2),:);

figure
showMatchedFeatures(queryImage,bestImage,points1,points2,'montage')
%%
[tform,inlierIdx] = ...
    estimateGeometricTransform2D(points1,points2,'affine',...
        'MaxNumTrials',50);
inlierPoints1 = points1(inlierIdx, :);
inlierPoints2 = points2(inlierIdx, :);
%%
percentageOfInliers = size(inlierPoints1,1)./size(points1,1);

figure
showMatchedFeatures(queryImage,bestImage,inlierPoints1,...
    inlierPoints2,'montage')




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


outputView = imref2d(size(bestImage));
Ir = imwarp(queryImage, tform, 'OutputView', outputView);
