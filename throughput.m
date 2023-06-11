function thr = throughput(opt,power_d2d,power_intf,rho,h_d2d_link,h_intf_bs,No,BW,sum_bs,interference)
    
    %This functions calculates at first the SINR metric and then based on
    %Shannon's Capacity theorem, it produces the throughput for the normal execution of the system. 
     
    if opt == 1
        SINR = power_intf*h_intf_bs / (No + sum_bs); 
    elseif opt == 2 
        if rho == 1
            SINR = (power_d2d*h_d2d_link)/(No + interference); 
        else
            SINR = 0;
        end
    end 

    thr = BW*(log2(1+SINR));
    
end



















