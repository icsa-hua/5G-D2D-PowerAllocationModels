function [rx_temp,tx_temp,new_N] = rec_dist(d2d_tx,d2d_rx,num_d2d)

   %This function is used to call the dist function and create the two matrices
   %containing the distance matched pairs. 

   get_pairs = zeros(num_d2d,4);
   matched_nums = zeros(num_d2d,2);
   temp_rx = d2d_rx;
   temp_tx = d2d_tx;
   pairs = dist(temp_rx,temp_tx,d2d_rx,d2d_tx,get_pairs,num_d2d,matched_nums,1);
 
   [new_N,~] = size(pairs);
   rx_temp = zeros(new_N,2);
   tx_temp = zeros(new_N,2);
   rx_temp(:,1) = pairs(:,1);
   rx_temp(:,2) = pairs(:,2);
   tx_temp(:,1) = pairs(:,3);
   tx_temp(:,2) = pairs(:,4);
   
end

