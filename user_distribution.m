function user = user_distribution(num_of_pairs,R)     

    %This function returns the coordinates for the CUE and for the DUE. 

    user=zeros(num_of_pairs,2); 
    k=1;
                
    for i=1:num_of_pairs                    
        theta = 2*pi*rand; 
        
        %Generate the coordinates
        coord_x = rand*R*cos(theta);
        coord_y = rand*R*sin(theta); 
               
        user(k,1)= coord_x; %Pass the values for the x axis 
        user(k,2)= coord_y; %Pass the values for the y axis
        k = k + 1;      
    end    
end
         
        

