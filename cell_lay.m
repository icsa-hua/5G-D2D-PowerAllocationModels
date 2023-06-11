function cell = cell_lay(R)
    
    %This function creates the shape of the cell given the radius. 
    
    %Create a disk-like shaped cell. 
    radius = R; 
    t = linspace(0,2*pi,1000);
    x1 = 0 + radius*cos(t);  
    y1 = 0 + radius*sin(t); 
    cell(1,:)=x1; %Pass the coordinates for x axis 
    cell(2,:)=y1; %Pass the coordinates for y axis
    
    %Create a hexagonal cell theoretical approach.
    %{
    scale = R+50; 
    N_sides = 6; 
    t=(1/(N_sides*2):1/N_sides:1)'*2*pi;
    x=sin(t);
    y=cos(t);
    x=scale*[x; x(1)];
    y=scale*[y; y(1)];
    cell(1,:) = x;
    cell(2,:) = y; 
    %}
   
end


