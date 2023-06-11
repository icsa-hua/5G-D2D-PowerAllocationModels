                                                            %5G Device - to - Device Simulation%
%This script initializes the simulation for D2D communication in systems refering to the following scenarios. 

num_rep = 50; %Number of repetitions. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Scenario 1 - Normal Execution of D2D Communications in 5G System. %%%%%%%%
%   THR,        Mean THR,       D2D pairs,      Mean Power

[simulation_1,simulation_1_1,simulation_1_1_1,simulation_1_1_1_1] = simulation(num_rep,1,1,0.1); %Equality Power Allocation 
fprintf("Done Simulation 1!\n");
[simulation_2,simulation_2_2,simulation_2_2_2,simulation_2_2_2_2] = simulation(num_rep,1,2,0.1); %Random Power Allocation 
fprintf("Done Simulation 2!\n");
[simulation_3,simulation_3_3,simulation_3_3_3,simulation_3_3_3_3] = simulation(num_rep,1,3,0.1); %Path Loss Power Allocation 
fprintf("Done Simulation 3!\n");
[simulation_4,simulation_4_4,simulation_4_4_4,simulation_4_4_4_4] = simulation(num_rep,1,4,0.1); %Power Allocation Based on Throughput
fprintf("Done Simulation 4!\n");
position = 1:50; 
position_2 = [5,10,15,20,25,30,35,40,45,50];
%}
%%%%%%%%Plot the mean throughput extracted for each repetition.%%%%%%%%  

t = tiledlayout(3,1);
title(t,'Different Power Control Schemes');
xlabel(t,'Number of Repetition','fontsize',14,'fontname','calibri');
%ylabel(t,'Total Throughput of System (Mbps)','fontsize',14,'fontname','calibri');

nexttile 
plot(position,simulation_1(1,position),'-om',position,simulation_2(1,position),'--b',position,simulation_3(1,position),'g-*',position,simulation_4(1,position),'c-s');
ylabel('Total Thr (Mbps)','fontsize',14,'fontname','calibri');
legend('Equ PA','Ran PA','PL PA','Thr PA');
nexttile
plot(position_2,simulation_1_1(1,:),'-om',position_2,simulation_2_2(1,:),'--b',position_2,simulation_3_3(1,:),'g-*',position_2,simulation_4_4(1,:),'c-s');
ylabel('Total Thr (Mbps)','fontsize',14,'fontname','calibri');
legend('Equ PA','Ran PA','PL PA','Thr PA');
nexttile
plot(position_2,simulation_1_1_1(1,:),'-om',position_2,simulation_2_2_2(1,:),'--b',position_2,simulation_3_3_3(1,:),'g-*',position_2,simulation_4_4_4(1,:),'c-s');
ylabel('Matched Pairs','fontsize',14,'fontname','calibri');
legend('Sim 1','Sim 2','Sim 3','Sim 4');
%}
%%%%%%%%Plot the power extracred for each repetition for each pair.%%%%%%%%
%{
d2d_minPower = 10^(20/10-3);
d2d_maxPower = 10^(24/10-3);
mind2d(1:25)  = d2d_minPower;
maxd2d(1:25) = d2d_maxPower;
position_4 = 1:25;
t_2 = tiledlayout(2,1); 
title(t_2,'Power Allocation Schemes');
ylabel(t_2,'Power level (Watts)'); 
xlabel(t_2,'Number of pair'); 

nexttile
plot(position_4,simulation_1_1_1_1(1,position_4),'-om',position_4,simulation_2_2_2_2(1,position_4),'--b',position_4,simulation_3_3_3_3(1,position_4),'g-*',position_4,simulation_4_4_4_4(1,position_4),'c-s',position_4,mind2d,'r',position_4,maxd2d,'r');
title("First Repetition");
legend('Equ PA','Ran PA','PL PA','Thr PA','Min Power','Max Power');
nexttile
plot(position_4,simulation_1_1_1_1(50,position_4),'-om',position_4,simulation_2_2_2_2(50,position_4),'--b',position_4,simulation_3_3_3_3(50,position_4),'g-*',position_4,simulation_4_4_4_4(50,position_4),'c-s',position_4,mind2d,'r',position_4,maxd2d,'r');
title("Last repetition");
legend('Equ PA','Ran PA','PL PA','Thr PA','Min Power','Max Power');
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% Scenario 2 Execution of a 5G mmW D2D system %%%%%%%%
%{
[simulation_1,simulation_1_1,simulation_1_1_1,simulation_1_1_1_1] = simulation(num_rep,2,1,0.8); %Equality Power Allocation 
fprintf("Done Simulation 1!\n");
[simulation_2,simulation_2_2,simulation_2_2_2,simulation_2_2_2_2] = simulation(num_rep,2,2,0.8); %Random Power Allocation 
fprintf("Done Simulation 2!\n");
[simulation_3,simulation_3_3,simulation_3_3_3,simulation_3_3_3_3] = simulation(num_rep,2,3,0.8); %Path Loss Power Allocation 
fprintf("Done Simulation 3!\n");
position = 1:50;
position_2 = [5,10,15,20,25,30,35,40,45,50];
%}
%%%%%%%%Plot the mean throughput extracted for each repetition.%%%%%%%% 
%{
t = tiledlayout(3,1);
title(t,'Different Power Control Schemes');
xlabel(t,'Number of Repetition','fontsize',14,'fontname','calibri');
%ylabel(t,'Total Throughput of System (Mbps)','fontsize',14,'fontname','calibri');

nexttile
plot(position,simulation_1(1,position),'-om',position,simulation_2(1,position),'--b',position,simulation_3(1,position),'g-*');
ylabel('Total Thr (Mbps)','fontsize',14,'fontname','calibri');
legend('Equ PA','Ran PA','PL PA');
nexttile
plot(position_2,simulation_1_1(1,:),'-om',position_2,simulation_2_2(1,:),'--b',position_2,simulation_3_3(1,:),'g-*');
ylabel('Total Thr (Mbps)','fontsize',14,'fontname','calibri');
legend('Equ PA','Ran PA','PL PA');
nexttile
plot(position_2,simulation_1_1_1(1,:),'-om',position_2,simulation_2_2_2(1,:),'--b',position_2,simulation_3_3_3(1,:),'g-*');
ylabel('Matched Pairs','fontsize',14,'fontname','calibri');
legend('Sim 1','Sim 2','Sim 3');
%}
%%%%%%%%Plot the power extracred for each repetition for each pair.%%%%%%%%
%{
d2d_minPower = 10^(20/10-3);
d2d_maxPower = 10^(24/10-3);
mind2d(1:25)  = d2d_minPower;
maxd2d(1:25) = d2d_maxPower;
position_4 = 1:25;
t_2 = tiledlayout(2,1); 
title(t_2,'Power Allocation Schemes');
ylabel(t_2,'Power level (Watts)'); 
xlabel(t_2,'Number of pair'); 

nexttile
plot(position_4,simulation_1_1_1_1(1,position_4),'-om',position_4,simulation_2_2_2_2(1,position_4),'--b',position_4,simulation_3_3_3_3(1,position_4),'g-*',position_4,mind2d,'r',position_4,maxd2d,'r');
title("First Repetition");
legend('Equ PA','Ran PA','PL PA','Min Power','Max Power');
nexttile
plot(position_4,simulation_1_1_1_1(50,position_4),'-om',position_4,simulation_2_2_2_2(50,position_4),'--b',position_4,simulation_3_3_3_3(50,position_4),'g-*',position_4,mind2d,'r',position_4,maxd2d,'r');
title("Last repetition");
legend('Equ PA','Ran PA','PL PA','Min Power','Max Power');
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
