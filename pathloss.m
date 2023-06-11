function [pl_d2d,pl_tx_bs,pl_intf_bs,pl_d2d_intf] = pathloss(option,new_N,n_intfs,rx_tx_d,tx_bs_d,intf_bs_d,d2d_intf_d)
    
    %This funciton returns the path loss values for each distance case. 

    %For option 1 consider LOS links, therefore path loss can be free space
    % pl_d2d -> path loss between D2D Tx and Rx. 
    % pl_tx_bs -> path loss between D2D Tx and BS.
    % pl_intf_bs -> path loss between CUE and BS.
    % pl_d2d_intf -> path loss between D2D RX and CUE. 
    
    %For option 2 
    % pl_d2d -> path loss between D2D Tx and Rx. 
    % pl_tx_bs -> 0 as there is no Bs considered for communications.
    % pl_intf_bs -> path loss between CUE and RX.
    % pl_d2d_intf -> 0. 
    
    switch option 
        
        case 1 %Normal Execution  
            pl_d2d = zeros(1,new_N); 
            pl_tx_bs = zeros(1,new_N); 
            pl_intf_bs = zeros(1,n_intfs); 
            pl_d2d_intf = zeros(new_N,n_intfs); 
            FC = 2e6; %Carrier Frequency is 2GHz for Inband Underlay 5G system. However the below equations are used wuth kHz as base unit. 
            for i = 1:new_N                
                if rx_tx_d(i) >= 125
                    pl_d2d(i) = 20*log10(rx_tx_d(i)) + 32.45 + 20*(log10(FC));                    
                elseif rx_tx_d(i) < 125
                    pl_d2d(i) = 12*log10(rx_tx_d(i)) + 19.45 + 12*(log10(FC));                                         
                end
                                
                if tx_bs_d(i) >= 125 
                    pl_tx_bs(i) = 20*log10(tx_bs_d(i)) + 32.45 + 20*(log10(FC));
                elseif tx_bs_d(i) < 125 
                    pl_tx_bs(i) = 12*log10(tx_bs_d(i)) + 19.45 + 12*(log10(FC));                                
                end                             
                
                for j = 1:n_intfs
                    if d2d_intf_d(i,j) >= 250
                        pl_d2d_intf(i,j) = 34*log10(d2d_intf_d(i,j)) + 64.9 + 34*(log10(FC));                    
                    elseif d2d_intf_d(i,j) < 250
                        pl_d2d_intf(i,j) = 20*log10(d2d_intf_d(i,j)) + 32.45 + 20*(log10(FC));                        
                    end                
                end                   
            end
            
            for j = 1:n_intfs
                if intf_bs_d(j) >= 125
                    pl_intf_bs(j) = 20*log10(intf_bs_d(j)) +20*(log10(FC)) + 32.45;
                elseif intf_bs_d(j) < 125
                    pl_intf_bs(j) = 12*log10(intf_bs_d(j)) +12*(log10(FC)) + 19.42;
                end                
            end 
                 
            %This function plots the four different path losses with a reference value. 
            %plot_pl(1,new_N,n_intfs,rx_tx_d,tx_bs_d,intf_bs_d,d2d_intf_d,pl_d2d,pl_tx_bs,pl_intf_bs,pl_d2d_intf,FC);
            
        case 2 %Abnormal Execution.
            pl_d2d = zeros(1,new_N); 
            pl_tx_bs = 0;
            pl_intf_bs = zeros(new_N,n_intfs); 
            pl_d2d_intf = 0;                    
            
            a_nlos = (72.0 + 75.85)/2;
            a_los = 60; %Basic Value for the Los float intercept from Fading Article.            
            b_ple_nlos = (2.92 + 3.73)/2;
            b_ple_los = 2;
            sigma_nlos = (8.7 + 8.36)/2; 
            sigma_los = 5.9;
            ksi_nlos = (sigma_nlos^2-0)*rand;
            ksi_los = (sigma_los^2-0)*rand;
                                                
            for i = 1:new_N 
               if rx_tx_d(i,4) == 1 %NLOS
                   pl_d2d(i) = a_nlos + b_ple_nlos * 10*log10(rx_tx_d(i,3)) + ksi_nlos;                      
               elseif rx_tx_d(i,4) == 2 %LOS                    
                   pl_d2d(i) = a_los + b_ple_los * 10*log10(rx_tx_d(i,3)) + ksi_los;                   
               end 
            end   
            
            for k = 1:new_N
               for j = 1:n_intfs
                   if intf_bs_d(j,3) == 1%NLOS
                      pl_intf_bs(k,j) = a_nlos + b_ple_nlos * 10*log10(d2d_intf_d(k,j)) + ksi_nlos;                       
                   elseif intf_bs_d(j,3) == 2%LOS                      
                      pl_intf_bs(k,j) = a_los + b_ple_los * 10*log10(d2d_intf_d(k,j)) + ksi_los;                      
                   end 
               end         
            end                        
            
            %plot_pl(2,new_N,n_intfs,rx_tx_d(:,3),ksi_nlos,ksi_los,d2d_intf_d,pl_d2d,pl_tx_bs,pl_intf_bs,pl_d2d_intf,28e6);
            
        otherwise 
            quit 
    end 

end

