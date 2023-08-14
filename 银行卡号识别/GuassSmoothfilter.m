%图像高斯平滑滤波处理
function g=GuassSmoothfilter(f)
% f=rgb2gray(img);
f=double(f);
f=double(f);
f=fft2(f);
f=fftshift(f);
[m,n]=size(f); %
d0=80;
m1=fix(m/2);
n1=fix(n/2);

for i=1:m

    for j=1:n

        d=sqrt((i-m1)^2+(j-n1)^2);

        h(i,j)=exp(-d^2/2/d0^2);

    end

end

g=f.*h;

g=ifftshift(g);

g=ifft2(g);

g=mat2gray(real(g));

% imshow(g);
% imwrite(img,'2.jpg');