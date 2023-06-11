function [rx_tx_d,tx_bs_d,intf_bs_d,d2d_intf_d] = distance(option,new_N,n_intfs,d2d_rx,d2d_tx,intfs)

    %This function is used to find the Euclidean distances between the points used
    %for the 5G networks. 

    %For option 1 
    % rx_tx_d -> distance between D2D devices (Rx-Tx).
    % tx_bs_d -> distance between tx and the BS.
    % intf_bs_d -> distance between the CUE and the BS. 
    % d2d_intf_d -> distance between the D2D Rx and the CUE. 
   
    %For option 2 
    % rx_tx_d -> distance between D2D devices (Rx-Tx). 
    % tx_bs_d -> 0 as np base station is considered for the communications.
    % intf_bs_d -> distance between the CUE and the Rx.
    % d2d_intf_d -> 0, not utilized. 
    
    switch option 
        
        case 1 %Normal Execution of the system.
            rx_tx_d = zeros(1,new_N); 
            tx_bs_d = zeros(1,new_N); 
            intf_bs_d = zeros(1,n_intfs); 
            d2d_intf_d = zeros(new_N,n_intfs); 
                        
            for i = 1:new_N
                tx_bs_d(i) = sqrt((d2d_tx(i,1))^2+(d2d_tx(i,2))^2);
                rx_tx_d(i) = sqrt((d2d_tx(i,1)-d2d_rx(i,1))^2 + (d2d_tx(i,2)-d2d_rx(i,2))^2);
                          
                for j = 1:n_intfs 
                    d2d_intf_d(i,j) = sqrt((intfs(j,1)-d2d_rx(i,1))^2 + (intfs(j,2)-d2d_rx(i,2))^2);
                end                                 
            end 
            
            for j = 1:n_intfs
                intf_bs_d(j) = sqrt((intfs(j,1))^2 + (intfs(j,2))^2); 
            end 
                        
        case 2 %Abnormal Execution of the System. 
            rx_tx_d = zeros(1,new_N);             
            intf_bs_d = zeros(new_N,n_intfs); 
            tx_bs_d = 0;
            d2d_intf_d = 0; 
            
            for i = 1:new_N 
                rx_tx_d(i) = sqrt((d2d_tx(i,1)-d2d_rx(i,1))^2 + (d2d_tx(i,2)-d2d_rx(i,2))^2);                
            end 
            
            for k = 1:new_N
                for j = 1:n_intfs
                    intf_bs_d(k,j) = sqrt((intfs(j,1)-d2d_rx(k,1))^2 + (intfs(j,2)-d2d_rx(k,2))^2);
                end 
            end 
                       
        otherwise 
            quit 
            
    end 
    
end 






















