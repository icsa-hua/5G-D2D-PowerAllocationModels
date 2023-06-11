function [thr,sinr] = thr_mmw(new_N,n_intfs,power_d2d,power_intf,pl_d2d,pl_intf_rx,h_d2d_link,h_intf_rx,G_d2d,G_intf,No,BW)
        
    %This function is used to calculate the total throughput of the D2D Rx - D2D Tx links
    %No matching is occured as no other links or devices are considered. 
    
    signal = zeros(1,new_N); 
    interference = zeros(new_N,n_intfs);
    sinr = zeros(1,new_N); 
    thr_vec = zeros(1,new_N); 
    Int = zeros(1,new_N);
    
    for k = 1:new_N
        signal(k) = power_d2d(k,1)*h_d2d_link(k)*G_d2d(k)*pl_d2d(k);
        for j = 1:n_intfs
            interference(k,j) = power_intf(k,j)*h_intf_rx(k,j)*G_intf(k,j)*pl_intf_rx(k,j);
        end 
    end 
  
    for k = 1:new_N
        for j = 1:n_intfs
            Int(k) = Int(k) + interference(k,j);
        end
    end 
    
    for k = 1:new_N
        sinr(k) = signal(k)/(No + Int(k));
        thr_vec(k) = BW*log2(1+sinr(k));
    end 
     
    thr = sum(thr_vec);   
    
end

