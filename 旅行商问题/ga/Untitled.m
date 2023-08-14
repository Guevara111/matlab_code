
clc;
tStart = tic; % 算法计时器

%%%%%%%%%%%%自定义参数%%%%%%%%%%%%%
% [cityNum,cities] = Read('kroA200.tsp');
% cities = cities';

cityNum=20;
cities=rand(2,cityNum)*10;

%cityNum = 100;
maxGEN = 1000;
popSize = 100; % 遗传算法种群大小
crossoverProbabilty = 0.9; %交叉概率
mutationProbabilty = 0.1; %变异概率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gbest = Inf;
% 随机生成城市位置
%cities = rand(2,cityNum) * 100;%100是最远距离

% 计算上述生成的城市距离
distances = calculateDistance(cities);

% 生成种群，每个个体代表一个路径
pop = zeros(popSize, cityNum);
for i=1:popSize
    pop(i,:) = randperm(cityNum); 
end
offspring = zeros(popSize,cityNum);
%保存每代的最小路劲便于画图
minPathes = zeros(maxGEN,1);

% GA算法
for  gen=1:maxGEN

    % 计算适应度的值，即路径总距离
    [fval, sumDistance, minPath, maxPath] = fitness(distances, pop);

    % 轮盘赌选择
    tournamentSize=4; %设置大小
    for k=1:popSize
        % 选择父代进行交叉
        tourPopDistances=zeros( tournamentSize,1);
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end

        % 选择最好的，即距离最小的
        parent1  = min(tourPopDistances);
        [parent1X,parent1Y] = find(sumDistance==parent1,1, 'first');
        parent1Path = pop(parent1X(1,1),:);


        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
        parent2  = min(tourPopDistances);
        [parent2X,parent2Y] = find(sumDistance==parent2,1, 'first');
        parent2Path = pop(parent2X(1,1),:);

        subPath = crossover(parent1Path, parent2Path, crossoverProbabilty);%交叉
        subPath = mutate(subPath, mutationProbabilty);%变异

        offspring(k,:) = subPath(1,:);
        
        minPathes(gen,1) = minPath; 
    end
    fprintf('代数:%d   最短路径:%.2fKM \n', gen,minPath);
    % 更新
    pop = offspring;
    % 画出当前状态下的最短路径
    if minPath < gbest
        gbest = minPath;
        paint(cities, pop, gbest, sumDistance,gen);
    end
end
figure 
plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
title('收敛曲线图（每一代的最短路径）');
set(gca,'ytick',500:100:5000); 
ylabel('路径长度');
xlabel('迭代次数');
grid on
tEnd = toc(tStart);
fprintf('时间:%d 分  %f 秒.\n', floor(tEnd/60), rem(tEnd,60));