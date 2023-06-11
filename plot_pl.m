function output = plot_pl(opt,new_N,n_intfs,rx_tx_d,tx_bs_d,intf_bs_d,d2d_intf_d,pl_d2d,pl_tx_bs,pl_intf_bs,pl_d2d_intf,FC)

    %This function is used to plot the path losses for each case during a
    %repetition. To be plotted the simulation must stop before it
    %compelets and it needs to be called by the pathloss function. 

    output = 1; 
    switch opt 
        case 1 %Normal Execution for the system.
            rx_tx_d = sort(rx_tx_d);
            pl_d2d = sort(pl_d2d);
            tx_bs_d = sort(tx_bs_d);           
            pl_tx_bs = sort(pl_tx_bs);
            intf_bs_d = sort(intf_bs_d);
            pl_intf_bs = sort(pl_intf_bs);
            d2d_intf_d = sort(d2d_intf_d(1,:));
            pl_d2d_intf = sort(pl_d2d_intf(1,:));
            
            pl(1:25) = 20*log10(125) + 32.45 + 20*(log10(FC));
            pl_2(1:20) = 20*log10(125) + 32.45 + 20*(log10(FC));
            pl_3 = zeros(1,20);
            pl_3(1,:) = 20*log10(125) + 32.45 + 20*(log10(FC));

            r = 1:new_N;
            j = 1:n_intfs;

            t = tiledlayout(4,1);
            %xlabel(t,'Distance between Points');
            %ylabel(t,'Path Loss in 2GHz');

            nexttile 
            plot(rx_tx_d(r),pl_d2d(r),'b-*',rx_tx_d(r),pl,'g-o','LineWidth',1);           
            title('Path loss between D2D RXs and D2D TXs');
            xlabel('Distance between Points');
            ylabel('Path Loss in 2GHz');
            legend('PL D2D','FSPL 125m')

            nexttile
            plot(tx_bs_d(r),pl_tx_bs(r),'r-.',tx_bs_d(r),pl,'g-o','LineWidth',1);
            title('Path loss between D2D TXs and BS');
            xlabel('Distance between Points');
            ylabel('Path Loss in 2GHz');
            legend('PL Tx-BS','FSPL 125m')
            
            nexttile
            plot(intf_bs_d(j),pl_intf_bs(j),'c-*',intf_bs_d(j),pl_2,'g-o','LineWidth',1);
            title('Path loss between CUE and BS');
            xlabel('Distance between Points');
            ylabel('Path Loss in 2GHz');
            legend('PL CUE-BS','FSPL 125m')

            nexttile
            plot( (d2d_intf_d(1,:)),(pl_d2d_intf(1,:)),'m-.', (d2d_intf_d(1,:)),pl_3(1,:),'g-o','LineWidth',1);
            title('Path loss between D2D RXs and CUE');
            xlabel('Distance between Points');
            ylabel('Path Loss in 2GHz');
            legend('PL Rx-CUE','FSPL 125m')

        case 2 %Abnormal Execution for system. 
            p1_los = zeros(1,new_N);
            p1_nlos = zeros(1,new_N);
            p2_los = zeros(1,n_intfs);           
            p2_nlos = zeros(1,n_intfs);
            
            rx_tx_d = sort(rx_tx_d);
            pl_d2d = sort(pl_d2d);
            pl_intf_bs = sort(pl_intf_bs(1,:));
            d2d_intf_d = sort(d2d_intf_d(1,:));
            
            a_nlos = (72.0 + 75.85)/2;
            b_ple_nlos = (2.92 + 3.73)/2;
            
            p1_los(:) = 20*log10(100) + 60 + intf_bs_d; 
            p1_nlos(:) = b_ple_nlos* 10*log10(100) + a_nlos + tx_bs_d;
            p2_los(:) = 20*log10(100) + intf_bs_d + 60;
            p2_nlos(:) = b_ple_nlos*10*log10(100) + a_nlos + tx_bs_d;
            
            r = 1:new_N;
            j = 1:n_intfs;
            
            t = tiledlayout(2,1);
            xlabel(t,'Distance between Points');
            ylabel(t,'Path Loss in 28GHz');
            
            nexttile 
            plot(rx_tx_d(r),pl_d2d(r),'b-*',rx_tx_d(r),p1_los,'g-o',rx_tx_d(r),p1_nlos,'--m','LineWidth',1);           
            title('Path loss between D2D RXs and D2D TXs');
            legend('PL D2D','LOS PL 100m','NLOS PL 100m');
            
            nexttile
            plot((d2d_intf_d(1,j)),(pl_intf_bs(1,j)),'c-.', (d2d_intf_d(1,j)),p2_los(j),'g-o',(d2d_intf_d(1,j)),p2_nlos(j),'--m','LineWidth',1);
            title('Path loss between D2D RXs and CUE');
            legend('PL INTF','LOS PL 100m','NLOS PL 100m');
            
    end            
end

