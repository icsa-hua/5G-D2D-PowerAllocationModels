function h_sd = channel_coefficient(pl,x,y)

    %This function creates the channel coefficient values based on the path loss it is given. Then that value 
    %is followed by a Rayleigh fading random distribution. Rayleigh is the worst type of fading.
    %The path loss is given in dB. After the calculation of channel coefficient, the gain of the links is produced. 

    chan_coef = zeros(x,y);
    for i = 1:x
        for j = 1:y
            variance_of_channel_db = -pl(i,j); 
            variance_of_channel = 10^(variance_of_channel_db * 0.1); 
            sigma = sqrt(2/(4-pi))*sqrt(variance_of_channel);
            chan_coef(i,j) = random('rayl',sigma); 
        end                
    end
    
    h_sd = abs(chan_coef).^2; 
end

