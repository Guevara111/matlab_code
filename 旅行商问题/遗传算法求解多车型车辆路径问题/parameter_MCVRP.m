%function [Total_Dis]=parameter(Result,Customer_num,Car_num)
%% 解码
%if Result(Customer_num,2)<=Car_num
% Current_Workstation=1;
% Total_Dis=0;
% for i=1:Customer_num
%     if Result(i,2)==Current_Workstation;
%         continue
%     else
%         Total_Dis=Total_Dis+Result(i-1,3);
%         Current_Workstation=Current_Workstation+1;
%     end
% end
% Total_Dis=Total_Dis+Result(Customer_num,3);
% else
%     Total_Dis=10000;%引入罚函数
% end
%%
%function [Value]=parameter(Result,Customer_num)
function [Value]=parameter_MCVRP(Result,Customer_num,price_k_4,price_k_6,capacity_max_4,capacity_max_6)
%目标值为最小费用
price_z=2;%货物运费单价

load X
load Demand
load coordinate
D=Distance(coordinate);
Current_Workstation=1;
Total_Dis=[];Value=0;
for i=1:Customer_num
    if Result(i,2)==Current_Workstation;
        continue
    else
        Total_Dis=[Total_Dis,Result(i-1,4)];
        Current_Workstation=Current_Workstation+1;
    end
end
Total_Dis=[Total_Dis,Result(Customer_num,4)];
Current_Workstation=1;
WT=1;a1=0;b1=Total_Dis(Current_Workstation);
for i=1:Customer_num
    if Result(i,2)==Current_Workstation;
        if WT==1
        a1=b1*X(Result(i,1))*price_z;
        else
            b1=b1-Demand(Result(i-1,1));
            a1=a1+b1*D(Result(i,1),Result(i-1,1))*price_z;
        end
        WT=WT+1;
        continue
    else
        %%
        if Result(i-1,5)==capacity_max_4
            Value=Value+a1+X(Result(i-1,1))*price_k_4;
        else
            Value=Value+a1+X(Result(i-1,1))*price_k_6;
        end
        %%
        %Value=Value+a1+X(Result(i-1,1))*price_k;
        Current_Workstation=Current_Workstation+1;
        b1=Total_Dis(Current_Workstation);
        a1=b1*X(Result(i,1))*price_z;
        WT=2;
    end
end
%%
if Result(i-1,5)==capacity_max_4
    Value=Value+a1+X(Result(i,1))*price_k_4;
else
    Value=Value+a1+X(Result(i,1))*price_k_6;
end
%%
%Value=Value+a1+X(Result(i,1))*price_k;
        
        
        
        
        
        
        
        
        
        
        