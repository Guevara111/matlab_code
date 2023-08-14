      %% wK算法
clear;close all;clc;

%% 程序说明
% 正视成像
% wKA算法
% 合成时长固定
% 基于走停模式生成回波信号(不考虑由于距离导致合成时间的差异）

% 在距离频域-方位频域进行一致压缩处理
% 在距离频域-方位频域进行Stolt插值处理
% 在距离频域-方位频域上进行参考距离下的距离移动
% 距离维IFFT处理
% 方位维IFFT处理

%% 参数设置
% 载频信号参数
c = 3e8;
fc = 1e9;                               % 信号载频
lambda = c/fc;                          % 载波波长

% 探测范围(地面范围）
Az0 = 9000;
AL = 1000;
Azmin = Az0-AL/2;                       % 方位向范围
Azmax = Az0+AL/2;                  
Rg0 = 9000;                             % 中心地距
RgL = 1000;                              % 测绘带宽

% 平台参数
vr = 20;                               % SAR搭载平台速度
H = 1000;                               % 平台高度
R0 = sqrt(Rg0^2+H^2);                   % 中心斜距（斜视角零度）

%天线参数
D = 4;                                  % 方位向天线长度
La = lambda*R0/D;                       % 合成孔径长度
Ta = La/vr;                             % 合成时长

% 方位维/慢时间维参数
Ka = -2*vr^2/lambda/R0;                 % 慢时间维调频率
Ba = abs(Ka*Ta);                        % 慢时间维带宽
PRF = 1.2*Ba;                           % 脉冲重复频率
Mslow = ceil((Azmax-Azmin+La)/vr*PRF);  % 慢时间维点数/脉冲数
Mslow = 2^nextpow2(Mslow);              % 用于慢时间维FFT的点数
ta = linspace((Azmin-La/2)/vr,(Azmax+La/2)/vr,Mslow);  
PRF = 1/((Azmax-Azmin+La)/vr/Mslow);    % 与慢时间维FFT点数相符的脉冲重复频率
Az = ta*vr;

% 距离维/快时间维参数
Tw = 5e-6;                              % 脉冲持续时间
Br = 30e6;                              % 发射信号带宽
Kr = Br/Tw;                             % 调频率
Fr = 2*Br;                              % 快时间维采样频率
R1 = sqrt((Rg0-RgL/2)^2+H^2);
R2 = sqrt((Rg0+RgL/2)^2+H^2);

Rmin = sqrt((Rg0-RgL/2)^2+H^2);
Rmax = sqrt((Rg0+RgL/2)^2+H^2+(La/2)^2);
Nfast = ceil(2*(Rmax-Rmin)/c*Fr+Tw*Fr); % 快时间维点数
Nfast = 2^nextpow2(Nfast);              % 用于快时间维FFT的点数
tr = linspace(2*Rmin/c-Tw/2,2*Rmax/c+Tw/2,Nfast);  
Fr = 1/((2*Rmax/c+Tw-2*Rmin/c)/Nfast);  % 与快时间维FFT点数相符的采样率
R = tr*c/2;


% 分辨率参数
Dr = c/2/Br;                            % 距离分辨率
Da = D/2;                               % 方位分辨率

% 点目标参数
Ptarget=[Az0+300,Rg0-300,1;Az0+300,Rg0,1;Az0+300,Rg0+300,1;
    Az0,Rg0-300,1;Az0,Rg0,1;Az0,Rg0+300,1;
    Az0-300,Rg0-300,1;Az0-300,Rg0,1;Az0-300,Rg0+300,1];  
Ntarget = size(Ptarget,1);                            % 目标数量
fprintf('仿真参数：\n');     
fprintf('快时间/距离维过采样率：%.4f\n',Fr/Br);     
fprintf('快时间/距离维采样点数：%d\n',Nfast);     
fprintf('慢时间/方位维过采样率：%.4f\n',PRF/Ba);     
fprintf('慢时间/方位维采样点数：%d\n',Mslow);     
fprintf('距离分辨率：%.1fm\n',Dr);     
fprintf('距离横向分辨率：%.1fm\n',Da);     
fprintf('合成孔径长度：%.1fm\n',La);     
disp('目标方位/地距/斜距：');
disp([Ptarget(:,1),Ptarget(:,2),sqrt(Ptarget(:,2).^2+H^2)])

%% 回波信号生成(距离时域-方位时域）
snr = 0;                                % 信噪比
Srnm=zeros(Mslow,Nfast);
for k=1:1:Ntarget
    sigmak=Ptarget(k,3);
    Azk=ta*vr-Ptarget(k,1);
    Rk=sqrt(Azk.^2+Ptarget(k,2)^2+H^2);
    tauk=2*Rk/c;
    tk=ones(Mslow,1)*tr-tauk'*ones(1,Nfast);
    phasek=pi*Kr*tk.^2-(4*pi/lambda)*(Rk'*ones(1,Nfast));
    Srnm=Srnm+sigmak*exp(1i*phasek).*(-Tw/2<tk&tk<Tw/2).*((abs(Azk)<La/2)'*ones(1,Nfast));
end
% Srnm = awgn(Srnm,snr,'measured');

figure;
mesh(tr,ta,abs(Srnm));
xlabel('距离时域/s');
ylabel('方位时域/s');
title('回波在距离时域方位时域上的表示');
view(2);
%-----------------------------wK成像算法---------------------------
%% 方位维傅里叶变换（距离多普勒域）
Srnm1 = fftshift(fft(Srnm,Mslow,1),1); 
% 方位频域划分
ft = linspace(-PRF/2,PRF/2,Mslow).';
figure;
mesh(tr,ft,abs(Srnm1));
xlabel('距离时域/s');
ylabel('方位频域/Hz');
title('回波在距离多普勒域上的表示');
view(2);

%% 距离维傅里叶变换（距离频域方位频域）
Srnm2 = fftshift(fft(Srnm1,Nfast,2),2); 
% 方位频域划分
ftau = linspace(-Fr/2,Fr/2,Nfast);
figure;
mesh(ftau,ft,abs(Srnm2));
xlabel('距离频域/Hz');
ylabel('方位频域/Hz');
title('回波在距离频域方位频域上的表示');
view(2);

%% 一致压缩
% 参考距离
R_ref = R0;
% 线性调频变标方程
H_RFM = exp(1i*4*pi*R_ref/c*sqrt((ones(Mslow,1)*(fc+ftau).^2)-c^2*ft.^2*ones(1,Nfast)/4/vr^2)+1i*pi*ones(Mslow,1)*ftau.^2/Kr); 
% 变标处理
Srnm3 = Srnm2.*H_RFM;

%% Stolt插值
Srnm4 = zeros(size(Srnm3));
for i=1:1:Mslow
    xx = sqrt((fc+ftau).^2+c^2*ft(i)/4/vr^2)-fc;
    pn = (abs(xx)<Fr/2);
    PN = find(pn~=0);
    a = interp1(ftau,Srnm3(i,:),xx,'linear');
    Srnm4(i,PN) = a(PN);
end

%% 参考距离平移
H_ref = exp(-1j*4*pi*R_ref/c*ones(Mslow,1)*ftau);
Srnm4 = Srnm4.*H_ref;

%% 距离向IFFT
Srnm5 = ifft(ifftshift(Srnm4,2),Nfast,2); 

figure;
mesh(R,ft,abs(Srnm5));
xlabel('距离/m');
ylabel('方位频域/Hz');
title('距离压缩后');
view(2);

%% 方位向IFFT
Srnm6 = ifft(ifftshift(Srnm5,1),Mslow,1); 
figure;
mesh(R,Az,abs(Srnm6));
xlabel('距离/m');
ylabel('方位/m');
title('方位压缩后');
view(2);

%% 成像区域SAR图像（数据获取面）

m1 = round(La/2/vr*PRF);
m2 = round(((Azmax-Azmin)/vr+La/2/vr)*PRF);
dA = vr/PRF;

n1 = round(Tw/2*Fr);
n2 = round((2*(R2-Rmin)/c+Tw/2)*Fr); 
dR = round(c/2/Fr);

figure;
mesh(R(n1:n2),Az(m1:m2),abs(Srnm6(m1:m2,n1:n2)));
xlabel('距离/m');
ylabel('方位/m');
title('数据获取面SAR图像');
view(2);
%--------------------------转换为地面SAR图像----------------------------------
%% 地距转换
Rg = linspace(Rg0-RgL/2,Rg0+RgL/2,1024);
[X,Y] = meshgrid(R,Az);
Rt = sqrt(Rg.^2+H^2);
[Xq,Yq] = meshgrid(Rt,Az);
SAR = interp2(X,Y,abs(Srnm6),Xq,Yq,'linear');

figure;
mesh(Rg,Az,SAR);
xlabel('地距/m');
ylabel('方位/m');
title('SAR图像（投影到地面）')

%% 3dB目标图像（地面SAR图像）
Max1 = max(max(SAR));
figure;
contourf(Rg,Az,SAR,[0.707*Max1,Max1],'b');grid on
xlabel('\rightarrow\it地距/m');
ylabel('\it方位/m\leftarrow');
title('投影到地面目标分辨率');
colormap(gray);
