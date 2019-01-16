clear;clc;close all;
load('orig1.mat');
% orig_sim = xlsread('./newhopcount.xlsx','origin');
% ESRCHE_sim=xlsread('./newhopcount.xlsx','ESRCHE');
% y1=orig_sim(:,6)';
% y2=ESRCHE_sim(:,6)';
for i=1:length(comp(:,2))
    simple(i).nodeID=ref(ref(:,2)==comp(i,2),:);
end
A=[];
G=[];
xtick=[];
for i=10:length(simple)-1
    a = simple(i).nodeID(:,7);
    a(a==0) = []; 
    A=[A a'];
    G=[G i.*ones(size(a))'];
    xtick=[xtick; strcat('0x0',dec2hex(simple(i).nodeID(1,2)))];
end
subplot(2,1,1);
boxplot(A,G);
set(gca,'xticklabel',xtick);
title('MHLeach');
ylim([0 10]);
ylabel('跳数');
xlabel('节点');





load('ELQECHE2.mat');
for i=1:length(comp(:,2))
    simple(i).nodeID=ref(ref(:,2)==comp(i,2),:);
end
A=[];
G=[];
xtick=[];
for i=12:length(simple)-1
    a = simple(i).nodeID(:,7);
    a(a==0) = []; 
    A=[A a'];
    G=[G i.*ones(size(a))'];
    xtick=[xtick; strcat('0x0',dec2hex(simple(i).nodeID(1,2)))];
end
subplot(2,1,2);
boxplot(A,G);
set(gca,'xticklabel',xtick);
title('ELQECHE');
ylim([0 10]);
ylabel('跳数');
xlabel('节点');
