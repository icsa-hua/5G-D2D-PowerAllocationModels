function blocked = Intersect1(P1,P2,P3,P4)

    %This function calculates, if the hypothetical link between a single point and the D2D Rx located near the device,
    %is blocked by a random blockage. This means that if the link is blocked there is no LOS communication. 

    X1 = [P1(1),P2(1)];
    X2 = [P3(1),P4(1)];
    Y1 = [P1(2),P2(2)];
    Y2 = [P3(2),P4(2)];

    if (X1(1)==X1(2) && X2(1) == X2(2))
       if (max(Y2) >= min(Y1) && max(Y2) <= max(Y1)) || (min(Y2) >= min(Y1) && min(Y2) <=max(Y1))
           blocked = 1; 
       else
           blocked = 0; 
       end
    elseif (X1(1)==X1(2)) && ~(X2(1) == X2(2))
        y_intersect = ((Y2(2) - Y2(1)) / (X2(2)-X2(1))) * (X1(1)-X2(1)) + Y2(1);
        if (y_intersect >= min(Y1) && y_intersect <= max(Y1)) && (y_intersect >= min(Y2) && y_intersect <= max(Y2))
            blocked = 1; 
        else
            blocked = 0; 
        end
    elseif (X2(1) == X2(2)) && ~(X1(1) == X1(2))
        y_intersect = ((Y1(2)-Y1(1))/(X1(2) - X1(1)))*(X2(1)-X1(1)) + Y1(1);
        if (y_intersect >= min(Y2) && y_intersect <= max(Y2)) && (y_intersect >= min(Y1) && y_intersect<=max(Y1))
            blocked = 1; 
        else
            blocked = 0; 
        end
    else 
        slope1 = (Y1(1)-Y1(2))/(X1(1)-X1(2)); 
        slope2 = (Y2(1)-Y2(2))/(X2(1)-X2(2));  

        if slope1 == slope2 
            if ( max(X2) <=min(X1) && max(X2)>=max(X1) && max(Y2)<=min(Y1) && max(Y2) >= max(Y1)) ||...
                    (max(X1)<=min(X2) && max(X1)>=max(X2) && max(Y1)<=min(Y2)&&max(Y1)>=max(Y2))
                    blocked = 1; 
            else 
                blocked = 0; 
            end    
        else 
            x_intersect = (Y2(1)-Y1(1) + slope1*X1(1)-slope2*X2(1))/(slope1-slope2); 
            y_intersect1 = slope1*(x_intersect-X1(1))+Y1(1); 
            y_intersect2 = slope2*(x_intersect-X2(1))+Y2(1); 
            if (x_intersect >= min(X1) && x_intersect <=max(X1)) && (x_intersect >= min(X2) && x_intersect<=max(X2))&&...
                  (y_intersect1 >= min(Y1) && y_intersect1 <= max(Y1))&&(y_intersect2>=min(Y2) && y_intersect2 <=max(Y2))&&...
                  (y_intersect1 == y_intersect2)
                blocked = 1; 
            else 
                blocked = 0; 
            end                           
        end    
    end

end