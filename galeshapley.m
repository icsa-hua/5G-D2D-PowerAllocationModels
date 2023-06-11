function stablematch = galeshapley(num_intf,num_d2d,PL_D2D,PL_INTF)

    %This function follows the Gale-Shapley algoritm for matching pairs. The D2D devices follow the male optimism, whereas the CUE have 
    %female pesimism. For more information on the algorithm refer to Resource Allocation using Matching Theory for Device-to-Device Underlay Communication
    %by Seung Hyun Lee, Yongwoo Lee, Jitae Shin.
    
    resr_partner = (-1)*ones(num_intf,1);  
    rank = zeros(num_intf, num_d2d); 

    for i = 1:num_intf
        for j = 1:num_d2d 
            for k = 1:num_d2d
                if(PL_INTF(i,k)==j) 
                    rank(i,j) = k; 
                end
            end
        end
    end

    temp = 1;
    while (temp <= num_intf)
        for i = 1:num_d2d
            f = find(PL_D2D(i,:)==temp); 
            if isempty(f)~=1 
                f = f(1,1); 
                if(resr_partner(f,1) ==-1 || rank(f,resr_partner(f,1))>rank(f,i))
                    resr_partner(f,1) = i; 
                end
            end
        end
        temp = temp + 1;
    end

    stablematch = resr_partner; 
end