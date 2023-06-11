function [power_d2d,power_intf,rho] = admiss_control(new_N,n_intfs,h_d2d_link,h_tx_bs,h_intf_bs,h_d2d_intf,No,d2d_maxPower,BW)
    
    %This functions considers the admission control problem by MINLP.
    %MINLP - Non convex mixed integer non-linear programming problems
    %Function also makes the optimized power pairs for CUE-DUE
    
    
    %Base station considers the power levels depending on the channel
    %coefficients, then it compares the throughput of those powers and 
    %produces the better power pairs for both the CUE and the DUE.
    rho = zeros(n_intfs,new_N);
    power_intf = zeros(n_intfs,new_N); 
    power_d2d = zeros(n_intfs,new_N);
    
    min_sinr = 10^(13/10);  %Min sinr for D2D communications
    min_sinr_bs = 10.^(linspace(15,20,50)/10); %Min sinr for cellular communications.

    D = zeros(1,2);
    E = zeros(1,2);
       
    for i = 1:n_intfs
        for j = 1:new_N
           
            %Considering the selection of BS by CUE 
            max_p1 = (min_sinr_bs(1,i))*(h_tx_bs(1,j) / h_intf_bs(1,i));
            min_p1 = (min_sinr_bs(1,i))*No/h_intf_bs(1,i); 
            max_p2 = h_d2d_link(1,j) / (min_sinr*h_d2d_intf(j,i));
            min_p2 = -No/h_d2d_intf(j,i); 
            
            A = cross_pt(max_p1,max_p2,min_p1,min_p2);                   
            B = cross_pt(0,max_p2,d2d_maxPower,min_p2);
            C = cross_pt(0,max_p1,d2d_maxPower,min_p1);
            
            D(1,1) = d2d_maxPower; 
            D(1,2) = max_p2*D(1,1)+min_p2; 
            E(1,1) = d2d_maxPower; 
            E(1,2) = max_p1*E(1,1)+min_p1;
            
            if (A(1,1) >= 0 && A(1,2) >=0 && max_p2 >max_p1)
                rho(i,j) = 1;
                if (B(1,1)>= 0 && B(1,1) < C(1,1) && C(1,1) <= d2d_maxPower)
                    power_intf(i,j) = d2d_maxPower;
                    thr_B = throughput(2,d2d_maxPower,B(1,1),rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,0,B(1,1)*h_d2d_intf(j,i)) + throughput(1,d2d_maxPower,B(1,1),rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,(rho(i,j)*d2d_maxPower*h_tx_bs(j)),0);
                    thr_C = throughput(2,d2d_maxPower,C(1,1),rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,0,C(1,1)*h_d2d_intf(j,i)) + throughput(1,d2d_maxPower,C(1,1),rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,(rho(i,j)*d2d_maxPower*h_tx_bs(j)),0); 
                    if thr_B > thr_C 
                        power_d2d(i,j) = B(1,1); 
                    else 
                        power_d2d(i,j) = C(1,1);
                    end
                elseif (D(1,2) <= d2d_maxPower && E(1,2) < D(1,2) && E(1,2) >= 0)
                    power_d2d(i,j) = d2d_maxPower;
                    thr_D = throughput(2,D(1,2),d2d_maxPower,rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,0,d2d_maxPower*h_d2d_intf(j,i)) + throughput(1,D(1,2),d2d_maxPower,rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,(rho(i,j)*D(1,2)*h_tx_bs(j)),0);                   
                    thr_E = throughput(2,E(1,2),d2d_maxPower,rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,0,d2d_maxPower*h_d2d_intf(j,i)) + throughput(1,E(1,2),d2d_maxPower,rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,(rho(i,j)*E(1,2)*h_tx_bs(j)),0);
                    
                    if thr_D > thr_E 
                        power_intf(i,j) = D(1,2); 
                    else 
                        power_intf(i,j) = E(1,2); 
                    end                                                           
                elseif (B(1,1) < d2d_maxPower && B(1,1) >=0 && E(1,2) >= 0 && E(1,2) < d2d_maxPower)
                    temp = zeros(2,2); 
                    thr_CF = zeros(1,100); 
                    thr_FE = zeros(1,100); 
                    temp(1,2) = d2d_maxPower;
                    div_P_d = linspace(B(1,1),d2d_maxPower,100);
                    for k = 1:100 
                        thr_CF(1,k) = throughput(2,div_P_d(1,k),d2d_maxPower,rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,0,d2d_maxPower*h_d2d_intf(j,i)) + throughput(1,div_P_d(1,k),d2d_maxPower,rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,(rho(i,j)*div_P_d(1,k)*h_tx_bs(j)),0);
                        t1 = find(thr_CF == max(max(thr_CF)));
                        temp(1,1) = div_P_d(1,t1(1,1));                         
                    end 
                    
                    temp(2,1) = d2d_maxPower; 
                    div_P_intf = linspace(E(1,1),d2d_maxPower,100);
                    for k = 1:100 
                        thr_FE(1,k) = throughput(2,d2d_maxPower,div_P_intf(1,k),rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,0,div_P_intf(1,k)*h_d2d_intf(j,i)) + throughput(1,d2d_maxPower,div_P_intf(1,k),rho(i,j),h_d2d_link(1,j),h_intf_bs(1,i),No,BW,(rho(i,j)*d2d_maxPower*h_tx_bs(j)),0);
                        t2 = find(thr_FE == max(max(thr_FE)));
                        temp(2,2) = div_P_intf(1,t2(1,1));                        
                    end 
                    
                    if max(thr_FE) < max(thr_CF) 
                        power_intf(i,j) = temp(1,2); 
                        power_d2d(i,j) = temp(1,1); 
                    else 
                        power_intf(i,j) = temp(2,2); 
                        power_d2d(i,j) = temp(2,1); 
                    end 
                    
                end
            else
                rho(i,j) = 0; 
                P_d_min = No * min_sinr / h_d2d_link(1,j); 
                power_d2d(i,j) = P_d_min + rand * (d2d_maxPower - P_d_min); 
                power_intf(i,j) = min_p1 + rand * (d2d_maxPower - min_p1);                 
            end                                  
        end 
    end     
end

