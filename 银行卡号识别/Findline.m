function [positionMax,positionMin]=Findline(im)
%        load data
       BW = edge(im,'sobel');
       figure;
       subplot(121);imshow(im,[]);title('原始图像')
       subplot(122);imshow(BW,[]);title('图像边缘')
       [H,T,R] = hough(BW);
       figure;
       imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
       xlabel('\theta'), ylabel('\rho');
       axis on, axis normal, hold on;
       P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
       x = T(P(:,2)); 
       y = R(P(:,1));
       plot(x,y,'s','color','white');
      title('霍夫变换域')
       % Find lines and plot them
       lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
       figure, imshow(im,[]), hold on
       max_len = 0;
       
       
       for k = 1:length(lines)
         xy = [lines(k).point1; lines(k).point2];%获取直线起点和终点位置
         xielv(k)=(lines(k).point2(2)-lines(k).point1(2))/(lines(k).point2(1)-lines(k).point1(1)+0.0001);%获取直线斜率
         plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
 
         % plot beginnings and ends of lines
         plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
         plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
       end
        ag=atan(xielv)*180/3.14;
        
        %获取上下界水平线
        p=find(abs(ag')<5);%允许10度角偏差
        lines=lines';
        for l=1:length(p)
        storex(l)=lines(l).point1(1);
        storey(l)=lines(l).point1(2);
        end
        ps=find(storey==max(storey))
        ps2=find(storey==min(storey))
        if(length(ps)==1)
            positionMax.x=storex(ps);
            positionMax.y=storey(ps);
        else
            positionMax.x=storex(ps(1));
            positionMax.y=storey(ps(1));
        end
         if(length(ps2)==1)
            positionMin.x=storex(ps2);
            positionMin.y=storey(ps2);
         else
            positionMin.x=storex(ps2(1));
            positionMin.y=storey(ps2(1));
         end
        x=[positionMin.x positionMax.x];
        y=[positionMin.y positionMax.y]
        plot(x,y,'LineWidth',2,'Color','b');
        hold off
        
        
            