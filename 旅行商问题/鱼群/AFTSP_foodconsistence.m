function Y=AFTSP_foodconsistence(X,Distance)             %返回路径的长度
Y=Distance(X(length(X)),X(1));  
for i=1:length(X)-1         
    Y=Y+Distance(X(i),X(i+1));
end