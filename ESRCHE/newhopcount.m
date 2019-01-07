clear;clc;close all;
load('orig_simpled2.mat');
% orig_sim = xlsread('./newhopcount.xlsx','origin');
% ESRCHE_sim=xlsread('./newhopcount.xlsx','ESRCHE');
% y1=orig_sim(:,6)';
% y2=ESRCHE_sim(:,6)';
A=[];
G=[];
xtick=[];
for i=10:length(simples)-1
    A=[A simples(i).nodeID(:,6)'];
    G=[G i.*ones(size(simples(i).nodeID(:,6)))'];
    xtick=[xtick; strcat('0x0',dec2hex(simples(i).nodeID(1,2)))];
end
subplot(2,1,1);
boxplot(A,G);
set(gca,'xticklabel',xtick);
title('MHLeach');
ylim([1 4]);
ylabel('跳数');
xlabel('节点');





load('ESRCHE_simpled.mat');
A=[];
G=[];
xtick=[];
for i=10:length(simples)-1
    A=[A simples(i).nodeID(:,6)'];
    G=[G i.*ones(size(simples(i).nodeID(:,6)))'];
    xtick=[xtick; strcat('0x0',dec2hex(simples(i).nodeID(1,2)))];
end
subplot(2,1,2);
boxplot(A,G);
set(gca,'xticklabel',xtick);
title('ESRCHE');
ylim([1 4]);
ylabel('跳数');
xlabel('节点');
