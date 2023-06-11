function [coordBlP1,coordBlP2, coordBlP3, coordBlP4] = rand_blockage(Len, Wid,numBuilding, areaLen)
    
    %This function generates randomly blockages for the second scenario
    %The shape of these is square because it is easy to then find out if a
    %potential user is inside them or the link created is then blocked.

    coordBlP1 = zeros(numBuilding,2); 
    coordBlP2 = zeros(numBuilding,2); 
    coordBlP3 = zeros(numBuilding,2); 
    coordBlP4 = zeros(numBuilding,2); 

    for i = 1:numBuilding
        deltaL = randi(Len); 
        deltaW = randi(Wid); 
        coordBlP1(i,:) = randi([-areaLen,areaLen],1,2);
        coordBlP2(i,1) = coordBlP1(i,1) + deltaL; 
        coordBlP2(i,2) = coordBlP1(i,2); 
        coordBlP3(i,1) = coordBlP1(i,1); 
        coordBlP3(i,2) = coordBlP1(i,2) + deltaW; 
        coordBlP4(i,1) = coordBlP2(i,1); 
        coordBlP4(i,2) = coordBlP2(i,2) + deltaW;                
    end    
end