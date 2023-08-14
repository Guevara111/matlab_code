rgb = imread('a.jpg');
I = rgb2gray(rgb);
imshow(I)
gmag = imgradient(I);
imshow(gmag,[])
 L = watershed(gmag);
 Lrgb = label2rgb(L);
 imshow(Lrgb)
se = strel('disk',1);
Io = imopen(I,se);
imshow(Io)
Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
imshow(Iobr)
Ioc = imclose(Io,se);
imshow(Ioc)
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
imshow(Iobrcbr)
fgm = imregionalmax(Iobrcbr);
imshow(fgm)
I2 = labeloverlay(I,fgm);
imshow(I2)
se2 = strel(ones(10,10));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
imshow(I3)
 bw = imbinarize(Iobrcbr);
 imshow(bw)
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
imshow(bgm)
gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);
subplot(1,2,1)
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
imshow(I4)
subplot(1,2,2)
Lrgb = label2rgb(L,'jet','w','shuffle');
imshow(Lrgb)
