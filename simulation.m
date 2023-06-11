function [simul_1,simul_2,simul_3,simul_4] = simulation(num_rep,option,power_alloc_opt,BW)
    
    %This function represents the main function for the execution of every
    %simulation. 


    %Parameters to run a standalone simulation manually
    %num_rep = ~;
    %option = ~;
    %power_alloc_opt = ~;
    %BW = ~;

    %Basic System Parameters
    MC = 35; %Monte Carlo Repetitions
    num_intf = 20; %number of CUE devices to interfere
    num_d2d = 30; %Number of points to be created. Not used points.

    %Power related parameters 
    d2d_minPower = 10^(20/10-3); %Minimum power for transmission is a little less than 0.1 W
    d2d_maxPower = 10^(24/10-3); %Maximum power for transmission given by korean article   
    Ptot = 10^(35/10-3); %Total System power for D2D
    PC = 10^(34/10-3); %Total System power for interferers ********

    %Calculation Matrices
    thr_vector = zeros(1,50); %Throughput for each repetition. 
    thr_port = zeros(1,10); 
    power_vector = zeros(50,25); %Power allocated to each pair 
    D2D_pairs_matched = zeros(1,50);

    for i = 1:num_rep    
    
        d2d_pairs = 0; %Hold the number of D2D pairs created every time.

        if option == 1 %Normal Execution of the System. 
            R = 250; %Cell's Radius        
            No = 10^((-174 + 10*log(BW) + 10)/10-3); %Noise calculation formula
            d2d_rx = user_distribution(num_d2d,R); %Create the d2d_rx coordinates 
              
        elseif option == 2 %Abnormal execution with no BS
        
            R = 200; %Smaller Radius because mmW can hold up to 200m communications.
            No = 10^((-174 + 10*log(BW) + 10)/10-3); %Same noise formula as above.         
            d2d_rx = user_distribution(num_d2d,R); %Create the d2d_rx coordinates         
        
            %Create Blockages 
            blockLen = 50; blockWid = 55; 
            num_blockages = poissrnd(5e-5 * (4*R)^2); %~35
            [coordBlP1,coordBlP2,coordBlP3,coordBlP4] = rand_blockage(blockLen,blockWid,num_blockages,R);
        end

        for N = 1:MC %Start every unrelated repetition.        
            X = ['|Repetition = ',num2str(i),' | MC = ',num2str(N),' | Simulation = ',num2str(power_alloc_opt)];
            display(X); 
        
            if option == 1 %First Environment for simulations
            
                %Create the points of the cell (D2D Txs and CUE)
                d2d_tx = user_distribution(num_d2d,R);
                intfs = user_distribution(num_intf,R); 

                %Plot the cell before dist.m
                %plot_cell(1,d2d_rx,d2d_tx,intfs,R,0,0,0,0);

                %Get the minimum distance pairs between D2D Rxs and Txs.
                %Number of usable pairs is set to 25. 
                [d2d_rx,d2d_tx,num_d2d] = rec_dist(d2d_tx,d2d_rx,num_d2d); 

                %Plot the cell after dist.m 
                %plot_cell(1,d2d_rx,d2d_tx,intfs,R,0,0,0,0);

                %Get the distaces between all the points of the network.  
                [rx_tx_d,tx_bs_d,intf_bs_d,d2d_intf_d] = distance(option,num_d2d,num_intf,d2d_rx,d2d_tx,intfs);

                %Calculate the path loss for each connection based on distance and frequency (microwave band - 2GHz licenced) 
                [pl_d2d,pl_tx_bs,pl_intf_bs,pl_d2d_intf] = pathloss(option,num_d2d,num_intf,rx_tx_d,tx_bs_d,intf_bs_d,d2d_intf_d);
            
                %Get the total value of pairs matched. 
                d2d_pairs = d2d_pairs + num_d2d;

                %Calculate the channel Coefficient based on the path loss
                %values and then that channel coefficient is returned as channel gain.
                h_d2d_link = channel_coefficient(pl_d2d,1,num_d2d); 
                h_tx_bs = channel_coefficient(pl_tx_bs,1,num_d2d);
                h_intf_bs = channel_coefficient(pl_intf_bs,1,num_intf); 
                h_d2d_intf = channel_coefficient(pl_d2d_intf,num_d2d,num_intf); 
                        
                %POWER ALLOCATION SCHEMES
                power_d2d = zeros(num_d2d,num_intf); 
                power_intf = zeros(num_d2d,num_intf); 

                switch power_alloc_opt
                    case 1 %First Option - Equal Allocation 
                        for k = 1:num_d2d                        
                            for j = 1:num_intf
                                power_d2d(k,j) = Ptot/num_d2d; 
                                power_intf(k,j) = PC/num_intf;
                            end                        
                        end                     
                        %Relations based on channel coefficients to find the points for D2D and CUE to allow communications  
                        rho = rho_mat(num_d2d,num_intf,h_d2d_link,h_tx_bs,h_intf_bs,h_d2d_intf,No);                       
                  
                    case 2 %Second Option - Random Allocation                     
                        rand_source = random_value(num_d2d); %Random factor
                        rand_intf_value = random_value(num_intf);
                        for k = 1:num_d2d
                            for j = 1:num_intf
                                power_d2d(k,j) = rand_source(k)*Ptot; 
                                power_intf(k,j) = rand_intf_value(j)*PC;
                            end                        
                        end

                        rho = rho_mat(num_d2d,num_intf,h_d2d_link,h_tx_bs,h_intf_bs,h_d2d_intf,No);                                           
                
                    case 3 %Third Option - Allocation based on path loss. 
                   
                        temp_sum = 0;
                        temp_intf_sum = 0;

                        %Calculate the total path loss for d2d and interferers.
                        for k = 1:num_d2d                        
                            temp_sum = temp_sum + pl_d2d(k);                                                  
                        end                     
                        for j = 1:num_intf
                            temp_intf_sum = temp_intf_sum + pl_intf_bs(j);
                        end

                        for k = 1:num_d2d 
                            for j = 1:num_intf
                                power_d2d(k,j) = Ptot*(pl_d2d(k)/temp_sum);
                                power_intf(k,j) = PC*(pl_intf_bs(j)/temp_intf_sum);
                            end
                        end

                        rho = rho_mat(num_d2d,num_intf,h_d2d_link,h_tx_bs,h_intf_bs,h_d2d_intf,No);                                       
                
                    case 4 %Fourth Option - Allocation based on throughput
                    
                        [p_d,p_c,rho] = admiss_control(num_d2d,num_intf,h_d2d_link,h_tx_bs,h_intf_bs,h_d2d_intf,No,d2d_maxPower,BW);                                        
                        for k = 1:num_d2d
                            for j = 1:num_intf 
                                power_d2d(k,j) = p_d(j,k);
                                power_intf(k,j) = p_c(j,k);
                            end 
                        end                                         
                    otherwise 
                        fprintf("Wrong input for simulations. Use the default options to run the simulatios.")
                        quit;                    
                end         
            
                %Check the power values to be between the max and minimum predefined              
                for k = 1:num_d2d
                    for j = 1:num_intf                    
                        if power_d2d(k,j) > d2d_maxPower
                            power_d2d(k,j) = d2d_maxPower; 
                        elseif power_d2d(k,j) < d2d_minPower
                            power_d2d(k,j) = d2d_minPower; 
                        end
                    end 
                end                         
                        
                for k = 1:num_d2d
                    power_vector(i,k) = power_d2d(k,1) + power_vector(i,k);
                end

                %Get the sum of interference for each usable SINR metric when not all devices interfere with the receiver, due to lack of
                %power, distance and pathloss. This effect could be random.  
                sum_bs = 0; 
                for k = 1:num_d2d
                    for j = 1:num_intf
                        sum_bs = sum_bs + (rho(j,k)*power_d2d(k,j)*h_tx_bs(k));
                    end                 
                end 
            
                interference = zeros(1,num_d2d);
                for k = 1:num_d2d
                  for j = 1:num_intf
                     interference(k) = interference(k) + (rho(j,k)*power_intf(k,j)*h_d2d_intf(k,j));  
                  end
                end 

                if BW == 0.1 
                     %Calculate the total throughput for the repetition without Gale-Shapley Matching 
                     thr = scrip(num_d2d,num_intf,power_d2d,power_intf,rho,h_d2d_link,h_intf_bs,No,sum_bs,interference,BW);    
                elseif BW == 0.5
                     %Calculate the total throughput for the repetition with Gale-Shapley Matching
                     thr = pl_thr_sc(num_d2d,num_intf,power_d2d,power_intf,rho,h_d2d_link,h_intf_bs,No,d2d_maxPower,sum_bs,interference,BW);          
                end 

                thr_vector(1,i) = thr + thr_vector(1,i); 
            
            elseif option ==2 %Second Scenario             
            
                %Create the points for the system without base station. 
                d2d_tx = user_distribution(num_d2d,R);
                intfs = user_distribution(num_intf,R);             

                %Plot the cell before excluding points
                %plot_cell(2,d2d_rx,d2d_tx,intfs,R,coordBlP1,coordBlP2,coordBlP3,coordBlP4);

                %Get the minimum distance pairs between D2D Rxs and Txs.
                %Number of usable pairs is set to 25.
                [d2d_rx,d2d_tx,num_d2d] = rec_dist(d2d_tx,d2d_rx,num_d2d);

                %Matrices to include all the values related to the D2D and CUE. 
                d2d_rx_full = zeros(num_d2d,2);
                d2d_tx_full = zeros(num_d2d,4);
                intfs_full = zeros(num_intf,3);   
            
                %Plot the cell before excluding points
                %plot_cell(2,d2d_rx,d2d_tx,intfs,R,coordBlP1,coordBlP2,coordBlP3,coordBlP4);

                %Check if Rx user is indoor and if he is then don't include them
                %into the simulation. Do the same for Txs. MMW cannot go
                %through buildings. 
                for k = 1:num_d2d
                    outdoor = findoutdooruser(1,d2d_rx(k,1),d2d_rx(k,2),coordBlP1,coordBlP2,coordBlP3,coordBlP4,d2d_rx);
                    outdoor_tx = findoutdooruser(1,d2d_tx(k,1),d2d_tx(k,2),coordBlP1,coordBlP2,coordBlP3,coordBlP4,d2d_rx);

                    if (outdoor == 1) && (outdoor_tx == 1)
                        d2d_rx_full(k,1) = d2d_rx(k,1);
                        d2d_rx_full(k,2) = d2d_rx(k,2);
                        d2d_tx_full(k,1) = d2d_tx(k,1);
                        d2d_tx_full(k,2) = d2d_tx(k,2);

                        %Check if the link between the points with minimum
                        %distances, is blocked by an obstacle. Conclude if that
                        %link is NLOS/LOS
                        isBlocked = findoutdooruser(2,d2d_tx(k,1),d2d_tx(k,2),coordBlP1,coordBlP2,coordBlP3,coordBlP4,d2d_rx); 
                        if isBlocked 
                           d2d_tx_full(k,4) = 1; %NLOS
                        else 
                           d2d_tx_full(k,4) = 2; %LOS
                        end
                    else
                        continue;
                    end                
                end 
               
                idx = find(d2d_tx_full(:,4) == 0); %Exclude all not usable points. 
                d2d_tx_full(idx,:) = [];
                d2d_rx_full(idx,:) = [];            
                [new_N,~] = size(d2d_tx_full);            

                if new_N <= 10 %For better conclusions. 
                   continue;
                end

                %Check if the interferer is indoor and if he is exclude them
                %from the simulation. 
                for j = 1:num_intf
                    outdoor = findoutdooruser(1,intfs(j,1),intfs(j,2),coordBlP1,coordBlP2,coordBlP3,coordBlP4,d2d_rx_full);
                    if ~outdoor 
                        %If the interferer is not outdoor then it cannot
                        %generate any interference. 
                        continue; 
                    else 
                        intfs_full(j,1) = intfs(j,1);
                        intfs_full(j,2) = intfs(j,2);

                        %Check to see if the hypothetical link of the interferer and every rx is blocked.                     
                        isBlocked = findoutdooruser(2,intfs(j,1),intfs(j,2),coordBlP1,coordBlP2,coordBlP3,coordBlP4,d2d_rx_full);
                        if isBlocked 
                            intfs_full(j,3) = 1; %NLOS
                        else 
                            intfs_full(j,3) = 2; %LOS
                        end 
                    end
                end 
            
                %Delete every point which was skipped and get the new length 
                intfs_full((intfs_full(:,3)==0),:) = [];
                n_intfs = length(intfs_full);

                %Plot the cell after excluding points
                %plot_cell(2,d2d_rx_full,d2d_tx_full,intfs_full,R,coordBlP1,coordBlP2,coordBlP3,coordBlP4);
            
                %Get the distances between the points of the system. 
                [rx_tx_d,~,intf_rx_d,~] = distance(option,new_N,n_intfs,d2d_rx_full,d2d_tx_full,intfs_full);

                d2d_tx_full(:,3) = rx_tx_d(:);
                d2d_pairs = d2d_pairs + new_N;

                %Calculate differently the path loss between the points based on distance. Not using frequency for this metric. 
                [pl_d2d,~,pl_intf_rx,~] = pathloss(option,new_N,n_intfs,d2d_tx_full,d2d_rx_full,intfs_full,intf_rx_d);

                %Channel Coefficient for D2D link and for the link between interferer and Rxs
                h_d2d_link = channel_coefficient(pl_d2d,1,new_N);
                h_intf_rx  = channel_coefficient(pl_intf_rx,new_N,n_intfs); 
            
                %Effective Antenna Gain at the receiver from D2D link.  
                G = db2pow(10); %10dBi
                G_d2d = zeros(1,new_N); 
                G_d2d(:) = G*G; %Assume that the angle of transmission sees the receiver. Therefore the total gain of the antennas is the main lobe 

                %Effective Antenna Gain at the receiver from interferers - Rx link
                G_intf = zeros(new_N,n_intfs);

                %Random angles of transmission for interferers. 
                phi_intf = 2*pi*rand(1,n_intfs);
            
                for k = 1:new_N
                    for j = 1:n_intfs 
                        %Get the antenna gain based on the angle of transmission and the location of the interferer. 
                        G_intf(k,j) = ant_gain(intfs_full(j,1),intfs_full(j,2),phi_intf(j),d2d_rx_full(k,:));                 
                    end
                end 
             
                %POWER ALLOCATION SCHEMES
                power_d2d = zeros(new_N,n_intfs);
                power_intf = zeros(new_N,n_intfs);
                %power_intf(:,:) = PC/n_intfs; 
                switch power_alloc_opt                  
                    case 1 %First Option - Equal Allocation 
                       for k = 1:new_N
                           for j = 1:n_intfs 
                               power_d2d(k,j) = Ptot/new_N;
                               power_intf(k,j) = PC/n_intfs; 
                           end                                              
                        end 
                                 
                    case 2 %Second Option - Random Allocation 
                        rand_source = random_value(new_N);
                        rand_intf_value = random_value(n_intfs);
                        for k = 1:new_N 
                            for j = 1:n_intfs
                                power_d2d(k,j) = Ptot * rand_source(k);  
                                power_intf(k,j) = PC * rand_intf_value(j);
                            end 
                        end                     

                    case 3 %Third Option - Allocation based on path loss. 
                        temp_sum = 0; 
                        temp_intf_sum = 0;

                        %Calculate the total path loss for d2d and intferferers.
                        for k = 1:new_N                        
                            temp_sum = temp_sum + pl_d2d(k);                                                  
                        end                                                           
                        for k = 1:new_N                                                    
                            for j = 1:n_intfs
                                temp_intf_sum = temp_intf_sum + pl_intf_rx(k,j);
                            end    
                        end

                        for k = 1:new_N
                             for j = 1:n_intfs 
                                 power_d2d(k,j) = Ptot*(pl_d2d(k)/temp_sum);
                                 power_intf(k,j) = PC*(pl_intf_rx(k,j)/temp_intf_sum);
                             end 
                        end 

                    otherwise 
                        fprintf("Wrong input for simulations. Use the default options to run the simulatios.");
                        quit 
                end 
                for k = 1:new_N
                    power_vector(i,k) = power_d2d(k,1) + power_vector(i,k);
                end
                %Calculate the total throughput of the system which is based on the SINR of Rxs. No matching is allowed because there is no BS
                [thr,~] = thr_mmw(new_N,n_intfs,power_d2d,power_intf,pl_d2d,pl_intf_rx,h_d2d_link,h_intf_rx,G_d2d,G_intf,No,BW);
                thr_vector(1,i) = thr + thr_vector(1,i); 
            else
                fprintf("Wrong input for simulations. Use the default options to run the simulatios.");
                quit
            end 
        end
        D2D_pairs_matched(i) = d2d_pairs/MC;
    
    end
   
   %Mean Value of throughput 
   thr_vector = thr_vector/MC;
   simul_1 = thr_vector;
   
   %Gather the values into one value.      
   thr_port(1) = mean(thr_vector(1:5));
   thr_port(2) = mean(thr_vector(6:10));
   thr_port(3) = mean(thr_vector(11:15));
   thr_port(4) = mean(thr_vector(16:20));
   thr_port(5) = mean(thr_vector(21:25));
   thr_port(6) = mean(thr_vector(26:30));
   thr_port(7) = mean(thr_vector(31:35));
   thr_port(8) = mean(thr_vector(36:40));
   thr_port(9) = mean(thr_vector(41:45));
   thr_port(10) = mean(thr_vector(46:50)); 
   simul_2 = thr_port;
   
   %Mean value of D2D pairs matched. 
   temp = zeros(1,10);
   D2D_pairs_matched = fix(D2D_pairs_matched);
   temp(1) = mean(D2D_pairs_matched(1:5));
   temp(2) = mean(D2D_pairs_matched(6:10));
   temp(3) = mean(D2D_pairs_matched(11:15));
   temp(4) = mean(D2D_pairs_matched(16:20));
   temp(5) = mean(D2D_pairs_matched(21:25));
   temp(6) = mean(D2D_pairs_matched(26:30));
   temp(7) = mean(D2D_pairs_matched(31:35));
   temp(8) = mean(D2D_pairs_matched(36:40));
   temp(9) = mean(D2D_pairs_matched(41:45));
   temp(10) = mean(D2D_pairs_matched(46:50));
   simul_3 = temp;
   
   %Mean Value of power 
   power_vector= power_vector/MC; 
   simul_4 = power_vector;
     
end

