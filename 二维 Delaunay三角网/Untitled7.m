%目标函数
Cc=0.95;%储能设备单位运行成本
Cco2=1;%二氧化碳成本
Objective = 0;

%需求响应成本
for k=1:24
    for w=1:nbus
Objective= Objective+0.205*Pfx(w,k);
    end
end

%CX是需求响应单位成本，Pfx(:,k)是t时刻的参与需求响应的负荷f的大小?
%CX鍙?0.235	0.205	0.175	0.145	0.11

%微型燃气轮机运行成本
for k=1:24
    for w=1:Nunits
Objective= Objective+0.88*onoff(w,k)*Pa(w,k);    %0.88燃气轮机成本系数
    end
end

%储能设备运行成本
for k=1:24
    for w=1:nbus
Objective= Objective+Cc*Pdis(w,k);   %Cc是储能设备单位运行成本
    end
end

%弃风弃光惩罚成本
%100是弃风单位惩罚成本，弃光单位惩罚成本。
for k=1:24
    for w=1:nbus
Objective=Objective +100*(sum(Pwas(w,k),'all')-sum(Pw(w,k),'all'))+Objective +100*(sum(Pvas(w,k),'all')-sum(Pp(w,k),'all'));
    end
end

%二氧化碳成本
for k=1:24
    for w=1:nbus
Objective= Objective+Cco2*(sum(0.85*sum(Pa(w,k),'all')-sum(Qin(w,k),'all')));
    %Cco2为碳排放单位成本，a2...是微型燃气轮机的碳排放计算系数。
    end
    end

%求解
ops = sdpsettings('solver', 'Gurobi');
optimize(Constraints,Objective,ops)
zongchengben=value(Objective);
value_gas=value(Pa);%燃气轮机功率
value_pv=value(Pp);            %光伏
value_windpower=value(Pw);%风力
value_charge=value(Pcha);%充电
value_discharge=value(Pdis);%放电
value_storage=value(SOC);%容量
value_carbon=value(Qin);%碳捕集量
value_demand=value(Pfx);%需求响应负荷