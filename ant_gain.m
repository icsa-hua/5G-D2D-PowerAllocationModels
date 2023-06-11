function antenna_gain = ant_gain(xcoord,ycoord,phi,d2d_rx)

    %This function calculates the total immediate gain of the interference received by
    %the D2D Rx. 

    hpBW = 30*pi/180; %Antenna Half Power Beamwdith
    G = db2pow(10); %Antenna Main Lobe Gain
    g = db2pow(-10); %Antenna Side Lobe Gain
    % phi -> random angle of transmission. 

    G1=0; G2=0;
    if (xcoord >= d2d_rx(1) && ycoord >= d2d_rx(2))
        if (ycoord<= xcoord*tan(hpBW))
            G1=G;
            if (sin(phi)<0 && cos(phi)<0)
                xIntersecty_0 = xcoord-ycoord/tan(phi+hpBW/2);
                yIntersectx_0 = ycoord-xcoord*tan(phi-hpBW/2);
                if (xIntersecty_0 > d2d_rx(1) && yIntersectx_0 > d2d_rx(2))
                    G2=G;
                else
                    G1=g;
                end
            else 
                G2=g;
            end
        else
            G1=g;
            if (sin(phi)<0 && cos(phi)<0)
                xIntersecty_0 = xcoord-ycoord/tan(phi+hpBW/2);           
                yIntersectx_0 = ycoord-xcoord*tan(phi-hpBW/2);
                if (xIntersecty_0 > d2d_rx(1) && yIntersectx_0 > d2d_rx(2))
                    G2=G;
                else
                    G2=g;
                end
            else
                G2=g;
            end
        end
    elseif (xcoord <=d2d_rx(1) && ycoord>d2d_rx(2))
            G1=g;
            if (cos(phi)>0 && sin(phi)<0)
                yIntersectx_0 = ycoord- xcoord * tan(phi+hpBW/2);
                xIntersecty_0 = xcoord- ycoord/tan(phi-hpBW/2);
                if (yIntersectx_0 > d2d_rx(2) && xIntersecty_0 < d2d_rx(1))
                    G2=G;
                else
                    G2=g;
                end
            else
                G2=g;
            end
    elseif (xcoord<d2d_rx(1) && ycoord<=d2d_rx(2))
        G1=g;
        if (cos(phi)>0 && sin(phi)>0)
            yIntersectx_0 = ycoord- xcoord * tan(phi-hpBW/2);
            xIntersecty_0 = xcoord- ycoord/tan(phi+hpBW/2);
            if (yIntersectx_0 < d2d_rx(2) && xIntersecty_0 < d2d_rx(1) )
                G2=G;
            else
                G2=g;
            end
         else
             G2=g;
        end
    elseif (xcoord>d2d_rx(1)&& ycoord<d2d_rx(2))
        G1=g;
        if (cos(phi)<0 && sin(phi)>0)
            yIntersectx_0 = ycoord- xcoord * tan(phi+hpBW/2);
            xIntersecty_0 = xcoord- ycoord/tan(phi-hpBW/2);
            if (yIntersectx_0 < d2d_rx(2) && xIntersecty_0 > d2d_rx(1))
                G2=G;
            else
                G2=g;
            end
        else
            G2=g;
        end
    else
        G1 = g; 
        G2 = g; 
    end

    antenna_gain = G1*G2;
end

