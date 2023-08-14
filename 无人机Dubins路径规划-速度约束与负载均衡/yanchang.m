function [outputArg1,outputArg2] = yanchang(inputArg1,inputArg2)
%YANCHANG 此处显示有关此函数的摘要
%   此处显示详细说明

outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

function [outputArg1,outputArg2] = shijiancha(t,inputArg2)
T=[];
a=max(t);
tmax=a(1);

end

function [t1] = shijian(t0,T)%%无人机初始到达时间
d =T/24/3600;
t=T/3600-d*24;
m=T/60-d*24*60-t*60;
s=T-d*24*3600-t*3600-m*60;
t1=[];
t1(1)=t0(1)+d;
t1(2)=t0(2)+t;
t1(3)=t0(3)+m;
t1(4)=t0(4)+s;
if t1(4)>=60
    t1(4)=t1(4)-60;
    t1(3)=t1(3)+1;
end
if t1(3)>=60
    t1(3)=t1(3)-60;
    t1(2)=t1(2)+1;
end
if t1(2)>=24
    t1(2)=t1(2)-24;
    t1(1)=t1(1)+1;
end
end

function [T] = shichang(l,v)
T=l/v
end
