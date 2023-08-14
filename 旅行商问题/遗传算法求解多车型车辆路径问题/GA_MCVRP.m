clc
clear
close all;
tic;
%%
%算法参数
population_num=100;%种群规模
Max_gen=200;%迭代次数
Pc=0.9;%交叉概率
Pm=0.09;%变异概率
%%
%问题参数
%车辆数量Car_num=2
%客户数量Customer_num=8
%车辆容量capacity_max=8
%行驶距离distance_max=50
%Car_num=2;
Customer_num=19;%本题19个客户
capacity_max_6=6;%载重为6吨车辆
%%
capacity_max_4=4;%载重为6吨车辆
price_k_4=0.2;%4吨车空载的费用为0.2元/公里
price_k_6=0.4;%6吨车空载的费用为0.4元/公里
%对解码操作、计算目标值操作进行修改
%%
distance_max=4;%每台车每日工作4小时
load Demand %客户的需求
load coordinate %客户间的坐标
D=Distance(coordinate);%客户间的距离
load X %物流中心到客户间的距离
%%
%种群初始化
population=zeros(population_num,Customer_num);
for i=1:population_num
     population(i,:)=randperm(Customer_num);
end
%%
y=1;%循环计数器
 while y<Max_gen
     %交叉
     [new_pop_intercross]=Mating_pool(population_num,population,Pc);
     %变异
     [new_pop_mutation]=Mutation(new_pop_intercross,Pm);
     %计算目标函数
     mutation_num=size(new_pop_mutation,1);
     Total_Dis=[];
     for k=1:mutation_num
     [Result]=decode_MCVRP(new_pop_mutation(k,:),capacity_max_4,capacity_max_6,distance_max);
     [Total_Dis(k,1)]=parameter_MCVRP(Result,Customer_num,price_k_4,price_k_6,capacity_max_4,capacity_max_6);
     end
     %更新种群
     new_pop_new=zeros(population_num,Customer_num);
     [Total_Dissort, index] = sort(Total_Dis);
     for k=1:population_num
         new_pop_new(k,:)=new_pop_mutation(index(k),:);
     end
     population=new_pop_new;
     %迭代次数加一
     y=y+1
 end
 Dis_min1=min(Total_Dis);
for k=1:mutation_num
    if Total_Dis(k,1)==Dis_min1
       position1= k;
       break
    end
end
X_Best=new_pop_mutation(position1,:)
Y_Obj=Total_Dis(position1,1)
t=toc;