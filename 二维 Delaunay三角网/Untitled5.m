% 生成一组随机点
n = 30;
x = rand(n, 1);
y = rand(n, 1);

% 计算 Delaunay 三角网
tri = [];
for i = 1:n
    for j = i+1:n
        for k = j+1:n
            % 判断第 i, j, k 个点是否构成一个三角形
            flag = true;
            for l = 1:n
                if l ~= i && l ~= j && l ~= k
                    if inpolygon(x(l), y(l), x([i,j,k]), y([i,j,k]))
                        flag = false;
                        break;
                    end
                end
            end
            
            % 如果构成三角形，则将其加入到三角网中
            if flag
                tri(end+1, :) = [i, j, k];
            end
        end
    end
end

% 可视化 Delaunay 三角网和原始点
figure;
hold on;
triplot(tri, x, y);
scatter(x, y);
