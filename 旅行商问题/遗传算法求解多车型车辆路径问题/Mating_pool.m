function [new_pop_intercross]=Mating_pool(population_num,population,Pc)
%%
%输入:population,population_num,Pc
%输出：1.new_popopulation_intercross
%     2.c3，配对池：随机将种群population两两配对
%     3.pool
%%
pl=randperm(population_num);
num=population_num/2;
c3=zeros(2,num);
pool=[];
new_pop_intercross=population;
for kj=1:num
    c3(1,kj)=pl(2*kj-1);
    c3(2,kj)=pl(2*kj);
end%生成“配对池c3”

%%判断“配对池c3”每一对个体的随机数是否小于交叉概率Pc
rd=rand(1,num);
for kj=1:num
    if rd(kj)<Pc
       pool=[pool,c3(:,kj)];
    end
end
%%判断配对池每一对个体的随机数是否小于交叉概率Pc,若小于，保存到“产子池pool”

pool_num=size(pool,2);
for kj=1:pool_num
    c1=population(pool(1,kj),:);
    c2=population(pool(2,kj),:);
    [new_c1,new_c2]=cross(c1,c2);
    new_pop_intercross(pool(1,kj),:)=new_c1;
    new_pop_intercross(pool(2,kj),:)=new_c2;
end
end

    