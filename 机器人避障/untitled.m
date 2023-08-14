close all;
fol_num=2;       % 追随者
N=3;             % 追随者 + 1 领导者
countmax=500;   % 最大循环计数数
dt=0.1;          % 控制与通信
gama=0.5;
beta=10;         
K0=1;
KN=0.2;        
goal=[12 12];   % 目标点
% X和y速度:m/s，角速度:rad/s，加速度:m/s ^2和rad/s^2
Kinematic=[0.5;0.5;0.5;0.5];
%% 相邻矩阵
A=[1 0 0 0 0 0;
   0 0 0 1 0 0;
   0 0 0 0 0 1];
B=[-1 0 0 0 0;0 0 0 0 -1;0 0 0 -1 1];
 %% 初始位置矩阵

        init_f=[-6 -2.4 -pi/4;
                -1 -4.5 -pi/2;
                -2.5 -4 pi/2];  

    pose_x=init_f(:,1);
    pose_y=init_f(:,2);
    pose_th=init_f(:,3);
    pose_x(:,2)=init_f(:,1);
    pose_y(:,2)=init_f(:,2);
    pose_th(:,2)=init_f(:,3);
    
    ob_temp=[3 2.3;
             5 4;
             4 7.5;
             7 4;
             14 16]; %障碍的位置

    %% 相对位置

    delta_x=[-1.5 1.5 -3 ];    
    delta_y=[1.5 1.5 0 ];  %领导者和追随者之间的相对位置
    V_x(:,1)=[0;0;0];
    V_y(:,1)=[0;0;0]; % 速度矩阵
    k=1;    
    d_max=2;
    detect_R=1; %%障碍物探测距离
    
    %% 边加权矩阵
    edge_w=[];
    sum_weight=[0;0;0];
                
    
    for count=1:countmax
        k=k+1;
%         存储最后一次速度
        %%%计算目标的吸引力，并把它放在领先速度上
        distance=sqrt((goal(1)-pose_x(N,k))^2+(goal(2)-pose_y(N,k))^2);
        th=atan2(goal(2)-pose_y(N,k),goal(1)-pose_x(N,k));
        if distance>d_max
            distance=d_max;
        end
        V_x(N,k+1)=KN*distance*cos(th);
        V_y(N,k+1)=KN*distance*sin(th);
        out=confine([V_x(N,k) V_y(N,k)],[V_x(N,k+1) V_y(N,k+1)],Kinematic,0.1);
        
        %% 计算agent速度
        ob_pose=ob_temp;
        
        % 对领导者施加障碍排斥
        [V_x(N,k+1),V_y(N,k+1)]=DynamicWindowApproach(pose_x(N,k),pose_y(N,k),ob_pose,V_x(N,k+1),V_y(N,k+1));
        
        % 当局部最小值出现时，给出一个随机误差
        if(distance>1&&abs(V_x(N,k+1))<=0.1&&abs(V_y(N,k+1))<=0.1)
            V_x(N,k+1)=-1+2*rand(1);
            V_y(N,k+1)=-1+2*rand(1);
        end
        
        for i=1:fol_num        
            sum_delta_x=0;
            sum_delta_y=0;
            sum_edge_weight=0;
            for j=1:N       
                if A(i,j)==1
                    w_ij=2-exp(-((pose_x(j,k-1)-pose_x(i,k)-(delta_x(j)-delta_x(i)))^2+(pose_y(j,k-1)-pose_y(i,k)-(delta_y(j)-delta_y(i)))^2)); %edge weighted calculation 
                    sum_delta_x=sum_delta_x+A(i,j)*w_ij*((pose_x(j,k-1)-pose_x(i,k))-(delta_x(j)-delta_x(i)));
                    sum_delta_y=sum_delta_y+A(i,j)*w_ij*((pose_y(j,k-1)-pose_y(i,k))-(delta_y(j)-delta_y(i)));
                    sum_edge_weight=sum_edge_weight+w_ij;
                end
            end
            edge_w(i,k)=sum_edge_weight;
            % 将权重误差存储到sum_weight矩阵中
            if edge_w(i,k)>edge_w(i,k-1)&&k>2
                sum_weight(i,k)=sum_weight(i,k-1)+abs(edge_w(i,k)-edge_w(i,k-1));
            else
                sum_weight(i,k)=sum_weight(i,k-1);
            end
            if mod(k,100)==1 % 周期10s后矩阵复位为0
                sum_weight(i,k)=0;
            end
            
            distance=sqrt(sum_delta_x^2+ sum_delta_y^2);
            th=atan2(sum_delta_y, sum_delta_x);
            if distance>d_max
                distance=d_max;
            end
            V_x(i,k+1)=K0*V_x(N,k)+gama*distance*cos(th); % 不受障碍物排斥的理想速度
            V_y(i,k+1)=K0*V_y(N,k)+gama*distance*sin(th);
            
            out=confine([V_x(i,k) V_y(i,k)],[V_x(i,k+1) V_y(i,k+1)],Kinematic,0.1);
%             out=[V_x(i,k+1) V_y(i,k+1)];
            V_x(i,k+1)=out(1);
            V_y(i,k+1)=out(2);
            
           %%%考虑代理之间的排斥，并将姿态存储到obs_pose
            kk=0;
            for j=1:N
                if j~=i
                    kk=kk+1;
                    obs_pose(kk,1)=pose_x(j,k);
                    obs_pose(kk,2)=pose_y(j,k);
                end
            end
            ob_pose=[obs_pose;ob_temp];
            
            [V_x(i,k+1),V_y(i,k+1)]=DynamicWindowApproach(pose_x(i,k),pose_y(i,k),ob_pose,V_x(i,k+1),V_y(i,k+1));
        end
        
        % 更新位置，计算预测与真实误差
        for i=1:N
            out=confine([V_x(i,k) V_y(i,k)],[V_x(i,k+1) V_y(i,k+1)],Kinematic,0.1);
%             out=[V_x(i,k+1) V_y(i,k+1)];
            V_x(i,k+1)=out(1);
            V_y(i,k+1)=out(2);
            pose_x(i,k+1)=pose_x(i,k)+dt*V_x(i,k+1);
            pose_y(i,k+1)=pose_y(i,k)+dt*V_y(i,k+1);
            pose_th(i,k+1)=atan2(V_y(i,k+1),V_x(i,k+1));
       
        end
        %% ====动画====
        area = compute_area(pose_x(N,k+1),pose_y(N,k+1),N+1);
        hold off;
        ArrowLength=0.5;% 
        for j=1:N
            quiver(pose_x(j,k+1),pose_y(j,k+1),ArrowLength*cos(pose_th(j,k+1)),ArrowLength*sin(pose_th(j,k+1)),'*k');hold on;
            if j==N
                state=2;
            else
                state=1;
            end
            draw_circle (pose_x(j,k+1),pose_y(j,k+1),0.25,state);hold on;
        end
        for i=1:N
            for j=1:N
                if A(i,j)==1
                    draw_arrow([pose_x(j,k+1),pose_y(j,k+1)],[pose_x(i,k+1),pose_y(i,k+1)], .2);hold on;
                end
            end
        end
        if size(ob_temp)~=[0 0]
            plot(ob_temp(:,1),ob_temp(:,2),'Xk','LineWidth',2);hold on;
        end
        axis(area);
        grid on;
        drawnow;    
        %% 判断是否到达
        now=[pose_x(N,k+1),pose_y(N,k+1)];
        if norm(now-goal)<0.5
            disp('Arrive Goal!!');break;
        end
        
    end
    
    color='mgb'; %%%对应6种颜色
    type=[2,1,0.5];%%%不同的线条
%     xlswrite('attmse.xlsx',attmse);
    %% 绘制路径记录
    figure                               % 绘制路径记录
    for i=1:N
        plot(pose_x(i,:),pose_y(i,:),color(1,i),'LineWidth',2);
        hold on
    end
    for i=1:N-1
        plot(pose_x(i,1),pose_y(i,1),'bp','color',color(1,i),'LineWidth',1);
        hold on
    end
    plot(pose_x(N,1),pose_y(N,1),'*','color',color(1,N),'LineWidth',1);
    hold on
    for i=1:N-1
        plot(pose_x(i,k),pose_y(i,k),'m^','color',color(1,i),'LineWidth',2);
        hold on
    end
    plot(pose_x(N,k),pose_y(N,k),'o','color',color(1,N),'LineWidth',2);
    hold on
    if size(ob_temp)~=[0 0]
        plot(ob_temp(:,1),ob_temp(:,2),'Xk','LineWidth',2);hold on;
    end
    grid on;
    xlabel('x');
    ylabel('y');
    legend('跟随者 1','跟随者 2','领航者');
    xlabel('x(m)');
    ylabel('y(m)');
%     title('Formation Consensus');


