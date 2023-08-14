clc
clear
close all
clear classes
%微电网+风+光
%% 数据 单位kW
Horizon=24;%时间为24
Nunits=10;  %燃气轮机机组数量为10
nbus=1;%机组数量
%定义
onoff_d1=binvar(1,24,'full'); %充电状态
onoff_d2=binvar(1,24,'full'); %放电状态
Pcha=sdpvar(1,24,'full');%充电功率
Pdis=sdpvar(1,24,'full');%放电功率
SOC=sdpvar(1,24,'full');%储能容量
Qin=sdpvar(1,24,'full');%碳捕集量
onoff=binvar(10,24,'full'); %启停状态
Pa=sdpvar(10,24,'full');%燃气轮机有功出力
Pw=sdpvar(1,24,'full');%风力发电调度
Pp=sdpvar(1,24,'full');%光伏发电
Pfx=sdpvar(1,24,'full');%参与需求响应的负荷

%风电出力 行-时间
Pwas=[206.4868428,224.87433,264.4967784, 268.0794844,262.2881316, 260.8942008, 241.2916236,233.510206,245.788402, 223.281688,222.506714,207.102848 ,212.6954896, 203.3015592,202.8842652 ,222.4868428,227.2618168 ,219.698982, 223.281688, 219.102848, 223.0829768,208.87433, 200.278196,200.6954896];
%光伏发电预测出力
Pvas=[0, 0, 0,0 ,0 ,0 ,9.9496181, 19.4024562,37.8304723 ,46.2733815, 65.1740933, 85.0748051 ,90.5475009 ,86.5673585, 66.1691289,65.1740933 ,40.2982036,19.899974, 10.4471359, 0, 0, 0 ,0 ,0];
%燃气轮机出力 列为发电机编号
%第1行：最小出力；2：最大出力；
Pd=[30	52
100	100
2	2
1	1
55	55
55	55
13.58	13.58
13.58	13.58
1.5891	3.1782
0.85	0.85
];

%电负荷预测值（Kw）
Pf=[249.7297272 ,244.324324 ,240.0000012, 249.7297272, 252.9729692,260.5405336 ,301.6215984, 347.0269856,378.3783248,381.6215664,390.2702116, 388.1080504,380.540486,376.2161632,372.9729212,387.02697, 395.6756152,397.8377764,395.6756152 ,382.7026472, 342.7026632,335.1350984, 299.4594372,283.2432272];

%约束条件
Constraints = [];
%功率平衡约束   燃气轮机+风电+光伏 +放电=充电+负荷-参与需求响应的负荷
for k = 1:24 
Constraints = [Constraints,Pa(:,k)+Pw(:,k)+Pp(:,k)+Pcha(:,k)==Pdis(:,k)+Pf(:,k)-Pfx(:,k)];         
end


%风力发电约束
for k = 1:24 
Constraints = [Constraints,0<=Pw(:,k)<=Pwas(:,k)];
end

%光伏发电约束
for k = 1:24 
Constraints = [Constraints,0<=Pp(:,k)<=Pvas(:,k)];
end
%弃光功率的计算


%储能装置约束 
%储能充放电功率最大小值  
Pchamax=[1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1  ];
Pdismin=[1,1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1  ];
 

for k=1:24
%充电功率小于最大，大于最小
Constraints = [Constraints,0<=Pcha(:,k)<=Pchamax(:,k)*onoff_d1(:,k)];
end

%放电功率小于最大，大于最小
for k=1:24
Constraints = [Constraints,0<=Pdis(:,k)<=Pdismin(:,k)*onoff_d2(:,k)];
end

%onoff之和小于1
for k=1:24
Constraints = [Constraints,onoff_d1(:,k)+onoff_d2(:,k)<=1];
end

%储能容量约束\
SOCmin=[0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,];
SOCmax=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
for k=1:24
Constraints = [Constraints,SOCmin(:,k)<=SOC(:,k)<=SOCmax(:,k)];
end

%计算SOC）
Constraints = [Constraints,SOC(:,1)==0.4+Pcha(:,1)*0.95-Pdis(:,1)/0.9];%SOC为容量初始值
for k=2:24
Constraints = [Constraints,SOC(:,k)==SOC(:,k-1)+Pcha(:,k)*0.95-Pdis(:,k)/0.9];%0.95,0.9为充放电效率
end

%Qinmax=20
Qinmax=[20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20 ];
%碳约束
for k = 1:24 
Constraints = [Constraints, 0<=Qin(:,k)<=20];
end

%负荷需求响应约束?
for k = 1:24 
Constraints = [Constraints,0<=Pfx(:,k)<=Pf(:,k)*0.1];%Pfmax(:,k)在10-20之间取
end
 


%燃气轮机有功出力
for k = 1:Horizon
    for w=1:Nunits
       Constraints = [Constraints, onoff(w,k)*Pd(:,1) <= Pa(:,k) <= onoff(w,k)*Pd(:,2)];
    end
end

ramp_rate=[0.35; 0.35; 0.35; 0.35; 0.35; 0.35 ;0.35; 0.35 ;0.35 ;0.35];

%燃气轮机爬坡
for k = 2:Horizon
    Constraints = [Constraints, -ramp_rate(:)<=Pa(:,k)-Pa(:,k-1)<=ramp_rate(:)];
end

minup=[2 ,2 ,2,2,2, 2, 2, 2,2,2,2, 0 ,0, 0, 0,0 ,0 ,0, 0, 0 ,0 ,0 ,0,0,0 ];

% 燃气轮机最小开机时间
for k = 2:Horizon
for unit = 1:Nunits
   %indicator will be 1 only when switched on
  indicator = onoff(unit,k)-onoff(unit,k-1);
  range = k:min(Horizon,k+minup(:,k)-1);
   %Constraints will be redundant unless indicator = 1
  Constraints = [Constraints, onoff(unit,range) >= indicator];
 end
end

mindown=[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
%%燃气轮机最小关机时间?
for k = 2:Horizon
 for unit = 1:Nunits
  %indicator will be 1 only when switched off
  indicator = onoff(unit,k-1)-onoff(unit,k);
  range = k:min(Horizon,k+mindown(unit)-1);
   %Constraints will be redundant unless indicator = 1
  Constraints = [Constraints, onoff(unit,range) <= 1-indicator];
 end
end