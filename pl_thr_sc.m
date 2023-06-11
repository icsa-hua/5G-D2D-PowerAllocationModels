function thr = pl_thr_sc(new_N,n_intfs,power_d2d,power_intf,rho,h_d2d_link,h_intf_bs,No,d2d_maxPower,sum_bs,interference,BW)
    
    %This function utilizes a plethora of functions to get the
    %finalized combination of throughput. After the process of power allocation has
    %finished this function will create the best DUE-CUE pairs 
 
    ptr = match_pairs(new_N,n_intfs,rho,power_d2d,power_intf,h_d2d_link,h_intf_bs,No,BW,sum_bs,interference);
    
    thr_d_matched = 0; 
    thr_bs_matched = 0; 
    min_sinr_bs = 10.^(linspace(15,20,50)/10);
    
    for k = 1:new_N
        for j = 1:n_intfs
            if rho(j,k) == 1 && ptr(j,1) == k
                thr_d_matched = thr_d_matched + throughput(2,power_d2d(k,j),power_intf(k,j),rho(j,k),h_d2d_link(k),h_intf_bs(j),No,BW,0,interference(k));
                thr_bs_matched = thr_bs_matched + throughput(1,power_d2d(k,j),power_intf(k,j),rho(j,k),h_d2d_link(k),h_intf_bs(j),No,BW,sum_bs,0);
            end 
        end
    end 
    
    for j = 1:n_intfs
        if ptr(j,1)==-1 || (ptr(j,1)~=-1 && rho(j,ptr(j,1))==0)
            min_p1 = (min_sinr_bs(1,j))*No/h_intf_bs(1,j);
            thr_bs_matched = throughput(1,0,(min_p1+rand*(d2d_maxPower-min_p1)),0,h_d2d_link(k),h_intf_bs(j),No,BW,sum_bs,0);
        end 
    end 
   
    thr = thr_d_matched + thr_bs_matched; 
end

