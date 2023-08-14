function [in_tri, index] = point_in_triangle(x, y, xtri, ytri)
    % 判断点是否在三角形内部
    d1 = (x - xtri(3)) * (ytri(1) - ytri(3)) - (y - ytri(3)) * (xtri(1) - xtri(3));
    d2 = (x - xtri(1)) * (ytri(2) - ytri(1)) - (y - ytri(1)) * (xtri(2) - xtri(1));
    d3 = (x - xtri(2)) * (ytri(3) - ytri(2)) - (y - ytri(2)) * (xtri(3) - xtri(2));
    if (d1 > 0 && d2 > 0 && d3 > 0) || (d1 < 0 && d2 < 0 && d3 < 0)
        % 点在三角形内部
        in_tri = true;
        [~, index] = ismember([x y], [xtri ytri], 'rows');
    else
        % 点在三角形外部
        in_tri = false;
        index = NaN;
    end
end