function C=pickContour()
    hold on;
    [x,y,b] = ginput(1);
    if b ~= 1
     hold off
        return
    end
    C=[x;y];
    h=plot(C(1,:),C(2,:),'r-');
    g=plot(C(1,:),C(2,:),'ro');
    while b==1
        [x,y,b] = ginput(1);
        if b == 1
            C=[C [x;y]];
            set(h,'XData',[C(1,:) C(1,1)]);
            set(h,'YData',[C(2,:) C(2,1)]);
            set(g,'XData',[C(1,:) C(1,1)]);
            set(g,'YData',[C(2,:) C(2,1)]);
            drawnow;
        end 
    end
hold off; end