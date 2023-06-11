function rho = rho_mat(new_N,n_intfs,h_d2d_link,h_d2d_bs,h_intf_bs,h_d2d_intf,No)
    
    %This function creates a matrix with the positions of the applicable pairs, by comparing power values based on channel gains.
    %This could theoretically be a matrix of optimal RBs assignment for CUE and DUE,
    %(As it is referred in mmW E-band D2D communication 5G-Underlay Networks).
    
    rho = zeros(n_intfs,new_N);  
    min_sinr = 10^(13/10); 
    min_sinr_bs = 10.^(linspace(15,20,50)/10); 
    
    for j = 1:n_intfs
        for i = 1:new_N 
            max_p1 = (min_sinr_bs(1,j))*(h_d2d_bs(1,i) / h_intf_bs(1,j));
            min_p1 = ((min_sinr_bs(1,j))*No)/h_intf_bs(1,j);
            max_p2 = h_d2d_link(1,i) / (min_sinr*h_d2d_intf(i,j));
            min_p2 = -No/h_d2d_intf(i,j); 
            A = cross_pt(max_p1,max_p2,min_p1,min_p2); 
            if (A(1,1) >= 0 && A(1,2) >=0 && max_p2>max_p1)
                rho(j,i) = 1;
            else 
                rho(j,i) = 0; 
            end 
        end 
    end 
    
end

