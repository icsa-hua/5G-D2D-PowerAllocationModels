function pairs_rx_tx = dist(temp_rx,temp_tx,d2d_rx,d2d_tx,pairs,num_d2d,matched_nums,count)    
    
    %This function is used to create the minimum distance pairs for rx and
    %tx devices.

    pos = count;
    
    %Get the minimum distances with the pdist2 function. 
    [distances,Ind] = pdist2(temp_rx,temp_tx, 'euclidean','Smallest',1);
  
    for i = 1:num_d2d
        if distances(i) == 0 %The values of x,y are very big. 
            continue;
        end 
        index = find(Ind == Ind(i));  
        if length(index) > 1 
                %Get the minimum distance between the points that are considering the same point as their partner.
                min_dist = find(distances == (min(distances(index)))); 
                index = min_dist;
        end 
        
        %Check if the points have already been matched. 
        if (any(matched_nums(:,2) == Ind(i)))          
            continue;
        elseif (any(matched_nums(:,1)==index))
            continue;
        else
            matched_nums(count,1) = index;
            matched_nums(count,2) = Ind(i);
            Ind(index) = 0;                                    
            count = count + 1; 
        end
    end
    
    for j = pos:count-1   
        tmp = matched_nums(j,2);
        tmp_s = matched_nums(j,1);
        pairs(j,1) = temp_rx(tmp,1);
        pairs(j,2) = temp_rx(tmp,2);
        pairs(j,3) = temp_tx(tmp_s,1);
        pairs(j,4) = temp_tx(tmp_s,2);
        temp_rx(tmp,1) = 500;
        temp_rx(tmp,2) = 500;
        temp_tx(tmp_s,1) = 500;
        temp_tx(tmp_s,2) = 500;        
    end 
    
    tmp_pairs = pairs(1:count-1,:);
    [len,~] = size(tmp_pairs); 
    if len >= 25 
        %Return maximum 25 pairs
        pairs_rx_tx = pairs(1:25,:);
    elseif pos == count
        %If the recursion cannot fin anymore pairs it becomes stuck in a loop that is imperative to be stopped. 
        pairs_rx_tx = pairs;
    else 
        %Use recursion to find at maximum 25 pairs with as minimum distances as they are able to.
        pairs_rx_tx = dist(temp_rx,temp_tx,d2d_rx,d2d_tx,pairs,num_d2d,matched_nums,count);
    end

end
    


