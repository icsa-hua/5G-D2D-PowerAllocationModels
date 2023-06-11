function ptr = match_pairs(new_N,n_intfs,rho,power_d2d,power_intf,h_d2d_link,h_intf_bs,No,BW,sum_bs,interference)
    

    %This function prepares the pairs, to then be given into the Gale-Shapley algorithm based on throughput. 

    thr_d = zeros(n_intfs,new_N); rand_d = rand(n_intfs,new_N);
    thr_bs = zeros(n_intfs,new_N); rand_bs = rand(n_intfs,new_N);
    
    for k = 1:new_N
        for j = 1:n_intfs
            thr_d(j,k) = throughput(2,power_d2d(k,j),power_intf(k,j),rho(j,k),h_d2d_link(1,k),h_intf_bs(1,j),No,BW,0,interference(k)); 
            thr_bs(j,k) = throughput(1,power_d2d(k,j),power_intf(k,j),rho(j,k),h_d2d_link(1,k),h_intf_bs(1,j),No,BW,sum_bs,0); 
        end 
    end 
 
    pair_intf = ones(n_intfs,new_N); 
    pair_d2d = ones(new_N,n_intfs); 
    
    for i = 1:n_intfs 
        for j = 1:new_N 
          for k = 1:new_N
              if thr_bs(i,j)<thr_bs(i,k)
                  pair_intf(i,j) = pair_intf(i,j) +1; 
              elseif (thr_bs(i,j) == thr_bs(i,k) && rand_bs(i,j)>rand_bs(i,k))
                  pair_intf(i,j) = pair_intf(i,j) +1;
              end
          end 
          
          for p = 1:n_intfs 
              if (rho(i,j)==1 && (thr_d(i,j)<thr_d(p,j)) && rho(p,j)==1)
                  pair_d2d(j,i) = pair_d2d(j,i) + 1;
              elseif (rho(i,j)==1 && (thr_d(i,j)==thr_d(p,j)) && rho(p,j)==1 && rand_d(i,j)>rand_d(p,j))
                  pair_d2d(j,i) = pair_d2d(j,i) + 1;
              end 
          end 
          
          if rho(i,j) == 0
              pair_d2d(j,i) = -1; 
          end          
        end 
    end     
    ptr = galeshapley(n_intfs,new_N,pair_d2d,pair_intf);
end

