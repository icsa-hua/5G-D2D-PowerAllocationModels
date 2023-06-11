function thr = scrip(new_N,n_intfs,power_d2d,power_intf,rho,h_d2d_link,h_intf_bs,No,sum_bs,interference,BW)
    
    %This function is used to calculate the total capacity of the system
    %for all the available links. No matching of pairs is considered. 
    %By default it uses BW set to 100MHz. 
    
    thr_d_matched = 0; 
    thr_bs_matched = 0;
    

    for k = 1:new_N
            for j = 1:n_intfs
                thr_d_matched = thr_d_matched + throughput(2,power_d2d(k,j),power_intf(k,j),rho(j,k),h_d2d_link(k),h_intf_bs(j),No,BW,0,interference(k));
                thr_bs_matched = thr_bs_matched + throughput(1,power_d2d(k,j),power_intf(k,j),rho(j,k),h_d2d_link(k),h_intf_bs(j),No,BW,sum_bs,0);
            end 
    end 
    
    thr = thr_d_matched + thr_bs_matched;
end





