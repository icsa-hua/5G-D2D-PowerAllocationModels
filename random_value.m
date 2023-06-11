function output = random_value(num)

    %This function creates a vector of size (1,num) of random numbers, which their sum is 
    %equal to 1. If the sum for some reason is indifferent to 1 then call
    %the function again with recursion.

    var = rand(1,num);
    var = var/sum(var);
    theSum = sum(var); 
    if theSum == 1        
        output = var;
    else
        output = random_value(num);
    end   
end
