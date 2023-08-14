function [ distances ] = calculateDistance( city )
%计算距离
    [~, col] = size(city);
    distances = zeros(col);
    for i=1:col
        for j=1:col
            distances(i,j)= distances(i,j)+ sqrt( (city(1,i)-city(1,j))^2 + (city(2,i)-city(2,j))^2  );           
        end
    end
end