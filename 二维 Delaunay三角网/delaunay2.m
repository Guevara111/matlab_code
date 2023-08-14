function tri = delaunay2(x,y)
    % 构建超级三角形
    xmin = min(x);
    xmax = max(x);
    ymin = min(y);
    ymax = max(y);
    dx = xmax - xmin;
    dy = ymax - ymin;
    dmax = max(dx, dy);
    xmid = (xmax + xmin) / 2;
    ymid = (ymax + ymin) / 2;
    p1 = [xmid - 2*dmax, ymid - dmax];
    p2 = [xmid, ymid + 2*dmax];
    p3 = [xmid + 2*dmax, ymid - dmax];
    tri = [1 2 3];
    edges = [1 2; 2 3; 3 1];

    % 为每个点找到相应的三角形
    n = length(x);
    for i = 1:n
        xnew = x(i);
        ynew = y(i);
        j = 1;
        while true
            [in_tri, index] = point_in_triangle(xnew, ynew, x(tri(j,:)), y(tri(j,:)));
            if in_tri
                % 如果点在三角形内部，则将该三角形分成三个新的三角形
                t1 = [tri(j,1) tri(j,2) index];
                t2 = [tri(j,2) tri(j,3) index];
                t3 = [tri(j,3) tri(j,1) index];
                tri(j,:) = [];
                tri = [tri; t1; t2; t3];
                % 更新边界信息
                edges([j j+size(tri,1)-3],:) = [];
                edges = [edges; t1(1:2); t2(1:2); t3(1:2)];
                break;
            else
                % 如果点在三角形外部，则尝试下一个三角形
                j = j + 1;
                if j > size(tri,1)
                    break;
                end
            end
        end
    end
    
    % 删除超级三角形的顶点和边
    to_delete = tri == 1 | tri == 2 | tri == 3;
    tri(to_delete(:,1) & to_delete(:,2) | ...
        to_delete(:,2) & to_delete(:,3) | ...
        to_delete(:,3) & to_delete(:,1),:) = [];
    edges(any(edges == 1,2) | any(edges == 2,2) | any(edges == 3,2),:) = [];

    % 返回 Delaunay 三角网
    tri = sort(tri, 2);
end


