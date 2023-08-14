function X=AFTSP_init(cityNum)          %返回从1到cityNum的随机排列 
X=1:cityNum;
for i=2:cityNum
    t=ceil(rand*(cityNum-1))+1;
    temp=X(i);
    X(i)=X(t);
    X(t)=temp;
end                                     %随机调换cityNum-1次