function [bad,kk] = cnntest(net, x, y)  
    %  feedforward  
    net = cnnff2(net, x); % 前向传播得到输出 
    % [Y,I] = max(X) returns the indices of the maximum values in vector I  
    [~, h] = max(net.o); % 找到每列（一列表示一个测试样本）最大的输出对应的标签  
    [~, a] = max(y);     % 找到最大的期望输出对应的索引  
    bad = find(h ~= a);  % 找到他们不相同的个数，也就是错误的次数  
   % er = numel(bad) / size(y, 2); % 计算错误率,size(y, 2)是测试样本的数量  
%      disp(['实际输出：' num2str(h-1)]);
%      disp(['期望输出：' num2str(a-1)]);
%      fprintf('期望输出：%d ',a-1);
%      fprintf('实际输出：%d\n', h-1);
    kk=h-1;
%    if((h-1)>25)
%     disp(['实际输出：' num2str(h-1-26)]);
%     disp(['期望输出：' num2str(a-1)]);
%    else
%     disp(['实际输出：' num2str(h-1)]);
%     disp(['期望输出：' num2str(a-1)]);
%    end
   % disp(['错误个数：' num2str(numel(bad))]);
%     if numel(bad)>0
%         disp(['错误识别的索引：' num2str(bad)]);
%     end
  
    %打印测试输出结果
%     [m,n]=size(net.o);
%     % disp(['m=' num2str(m)  ' n=' num2str(n)]);
%     for i=1:m
%         for j=1:n
%             fprintf('%6.2f ',net.o(i,j));
%         end
%         fprintf('\n');
%     end
    
end   