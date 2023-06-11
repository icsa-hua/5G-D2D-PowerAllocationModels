function output = plot_cell(opt,d2d_rx,d2d_tx,intfs,R,coordBlP1,coordBlP2,coordBlP3,coordBlP4)
    
    %This function is ised to plot the cell for each scenario. 

    output = 1; 
    if opt == 1 %Normal cell 
        cell = cell_lay(R);
        hold on; 
        plot(cell(1,:),cell(2,:),'--k'); 
        plot(d2d_rx(:,1),d2d_rx(:,2),'g^','MarkerFaceColor','g');
        plot(d2d_tx(:,1),d2d_tx(:,2),'bo','MarkerFaceColor','c');
        plot(intfs(:,1),intfs(:,2),'r*');
        plot(0,0,'kh','MarkerSize',20);
        title("Normal Cell Layout")
        xlabel('Matched D2D Points')
        legend('Layout','D2D Rx','D2D Tx','CUE','BS'); 
    elseif opt == 2 %Cell with blockages and the BS is absent because it is not included for communications.
        cell = cell_lay(R);
        hold on; 
        plot(cell(1,:),cell(2,:),'--k'); 
        plot(d2d_rx(:,1),d2d_rx(:,2),'g^','MarkerFaceColor','g');
        plot(d2d_tx(:,1),d2d_tx(:,2),'bo','MarkerFaceColor','c');
        plot(intfs(:,1),intfs(:,2),'r*'); 
        for i = 1:1:size(coordBlP1,1)
            if (coordBlP1(i,1)<-145 && coordBlP1(i,2)<-145) || (coordBlP1(i,1)>R || coordBlP1(i,2)>R)
                continue;
            end
            if (coordBlP2(i,1)>145 && coordBlP2(i,2)<-145) || (coordBlP2(i,1)>R || coordBlP2(i,2)>R)
                continue;
            end            
            if (coordBlP3(i,1)<-145 && coordBlP3(i,2)>145) || (coordBlP3(i,1)>R || coordBlP3(i,2)>R)
                continue;
            end                
            if (coordBlP4(i,1)>145 && coordBlP4(i,2)>145) || (coordBlP4(i,1)>R || coordBlP4(i,2)>R)
                continue;
            end            
            hold on;
            plot([coordBlP1(i,1),coordBlP2(i,1)],[coordBlP1(i,2),coordBlP2(i,2)],'-.k',[coordBlP2(i,1),coordBlP4(i,1)],[coordBlP2(i,2),coordBlP4(i,2)],'-.k'...
            ,[coordBlP4(i,1),coordBlP3(i,1)],[coordBlP4(i,2),coordBlP3(i,2)],'-.k',[coordBlP3(i,1),coordBlP1(i,1)],[coordBlP3(i,2),coordBlP1(i,2)],'-.k');     
        end
        title("Cell Layout after Emergency Event")
        legend('Layout','D2D Rx','D2D Tx','Intfs','Blockages');
    end
end

