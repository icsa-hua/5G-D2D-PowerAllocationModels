function outdoor_blocked = findoutdooruser(opt,user_coordinates_x,user_coordinates_y,coordBlP1,coordBlP2,coordBlP3,coordBlP4,d2d_rx)
    
    %This functions determines if the given coordinates of a user, are in outdoor
    %environment, indoor and if the hypothetical link created is LOS or NLOS. 

    switch opt 
        case 1 %Find if the user_coordinates are inside the space of the blockage. 
            n = 0; 
            outdoor_blocked = 1; 
            for i = 1:size(coordBlP1,1)
                if (user_coordinates_x >= coordBlP1(i,1) && user_coordinates_x <= coordBlP2(i,1))
                    if (user_coordinates_y >= coordBlP1(i,2) && user_coordinates_y <= coordBlP3(i,2))
                        n = n+1; 
                        if n>0  
                            outdoor_blocked = 0; 
                            break
                        end                         
                    end 
                end                 
            end             
        case 2 %Find if the link between the user and its corredponding D2D Rx is blocked by the blockage.              
            n = 0; 
            outdoor_blocked = 0; 
            user_coordinates = [0,0]; 
            user_coordinates(1) = user_coordinates_x; 
            user_coordinates(2) = user_coordinates_y; 
            for i = 1:size(coordBlP1,1) 
                if (Intersect1(d2d_rx,user_coordinates,coordBlP1(i,:),coordBlP2(i,:))||...
                     Intersect1(d2d_rx,user_coordinates,coordBlP2(i,:),coordBlP4(i,:))||...   
                     Intersect1(d2d_rx,user_coordinates,coordBlP4(i,:),coordBlP3(i,:))||...
                     Intersect1(d2d_rx,user_coordinates,coordBlP3(i,:),coordBlP1(i,:)))
                    n = n+1; 
                    if n>0
                        outdoor_blocked = 1; 
                        break 
                    end 
                end 
            end                               
    end         
end

