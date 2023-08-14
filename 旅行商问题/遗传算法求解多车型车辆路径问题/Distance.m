%% 计算两两城市之间的距离
%输入 a  各城市的位置坐标
%输出 D  两两城市之间的距离

function D=Distance(a)
row=size(a,1);
D=zeros(row,row);
for i=1:row
    for j=i+1:row
        %D(i,j)=((a(i,1)-a(j,1))^2+(a(i,2)-a(j,2))^2)^0.5;
        %%
        %假定街道方向均为平行与坐标轴，任意两站点间都可以通过依次拐弯到达
        D(i,j)=abs(a(i,1)-a(j,1))+abs(a(i,2)-a(j,2));
        %%
        D(j,i)=D(i,j);
    end
end