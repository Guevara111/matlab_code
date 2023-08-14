classdef ESN < handle
    % Echo State Network
    %首先创建ESN网络对象，其可修改的属性如下
    %第二步调用train成员函数
    %第三步调用预测成员函数
    properties
        Nr             %储备池的神经元个数
        alpha          %是否是漏积分
        rho            %储备池权谱半径
        inputScaling   %输入的缩放因子
        biasScaling    %偏置的缩放因子
        lambda         %正则化系数
        connectivity   %系数程度
        readout_training %输出权值的训练方法
        Win            %输入连接权值矩阵
        Wb             %偏置矩阵
        Wr             %内部连接权值矩阵
        Wout           %输出连接去权值矩阵
        internalState  %储备池的状态矩阵
        outDim         %输出的维度/类别数量
        inputDim       %输入维度
    end
    methods
       function esn = ESN(Nr,varargin)
            esn.Nr = Nr;
            esn.alpha = 1;
            esn.rho = 0.9;
            esn.inputScaling = 1;
            esn.biasScaling = 1;
            esn.lambda = 2;
            esn.connectivity = 1;
            esn.readout_training = 'ridgeregression';
            
            numvarargs = length(varargin);
            for i = 1:2:numvarargs
                switch varargin{i}
                    case 'leakRate', esn.alpha = varargin{i+1};
                    case 'spectralRadius', esn.rho = varargin{i+1};
                    case 'inputScaling', esn.inputScaling = varargin{i+1};
                    case 'biasScaling', esn.biasScaling = varargin{i+1};
                    case 'regularization', esn.lambda = varargin{i+1};
                    case 'connectivity', esn.connectivity = varargin{i+1};
                    case 'readoutTraining', esn.readout_training = varargin{i+1};
                    
                    otherwise, error('the option does not exist');
                end
            end
       end
        
        function train(esn, trX, target, washout)
            %trX表示训练的数据
            %target表示目标
            %修改 trX为N*dimData的矩阵
            %修改 trY为N*dimTaret的矩阵
            %如要在[-a,a]之间生成，则为R = a - 2*a*rand(m,n)
            
            [inputQuantity,esn.inputDim]=size(trX);
            [~,esn.outDim] = size(target);
            esn.Win=esn.inputScaling *(rand(esn.Nr, esn.inputDim) *2 - 1);   %产生服从[-inputScaling,inputScaling]的均匀分布
            esn.Wb = esn.biasScaling * (rand(esn.Nr, 1) * 2 - 1);
            esn.Wr = full(sprand(esn.Nr,esn.Nr, esn.connectivity));      %生成一个m×n的服从均匀分布的随机稀疏矩阵，非零元素的分布密度是density
            esn.Wr(esn.Wr ~= 0) = esn.Wr(esn.Wr ~= 0) * 2 - 1;           
            esn.Wr = esn.Wr * (esn.rho / max(abs(eig(esn.Wr))));         %缩放权值权谱半径
 
            X = zeros(1+esn.inputDim+esn.Nr, inputQuantity-washout);        %状态矩阵，每一列代表了，偏置状态+输入状态+内部状态
            x=zeros(esn.Nr,1);                                  %内部状态矩阵
      
            for s = 1:inputQuantity
                u = trX(s,:).';                                 %取出一行，即一张照片
                x_ = tanh(esn.Win*u + esn.Wr*x + esn.Wb);
                x = (1-esn.alpha)*x + esn.alpha*x_;
                if (s > washout)
                    X(:,s - washout) = [1;u;x]; 
                end
            end
            esn.internalState = X(1+esn.inputDim+1:end,:);
            esn.Wout = feval(esn.readout_training,X ,target(washout+1:end,:), esn);
        end
        
        function y = predict(esn, data)
            [N,~] = size(data);
            Y_out10 = zeros(esn.outDim,N);
            x=zeros(esn.Nr,1);
            for k =1 : N
                u = data(k, :).';
                x_ = tanh(esn.Win*u + esn.Wr*x + esn.Wb);
                x = (1-esn.alpha)*x + esn.alpha*x_;
                Y_out10( : ,k) = esn.Wout*[1;u;x];        %预测值yt
            end
            y = Y_out10';
        end
    end
end