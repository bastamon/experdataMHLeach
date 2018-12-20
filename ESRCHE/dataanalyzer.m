clear;clc;close all;
% [ref,temp] = xlsread('./WSN_20181215_225523.xlsx','Results');
% ref(1:end,5)=datenum(temp(2:end,5));
% 
% 
% comp = xlsread('./WSN_20181215_225523.xlsx','Compute');
% save ( 'ESRCHE.mat','comp', 'ref');
% clear;clc;
MINUTEUNIT=datenum(2001,01,01,12,01,00)-datenum(2001,01,01,12,00,00);
HOURUNIT=datenum(2001,01,01,13,00,00)-datenum(2001,01,01,12,00,00);
load('ESRCHE'); 

timespan = 24*day(ref(end,5)-ref(1,5))+hour(ref(end,5)-ref(1,5));
% for i=1:length(comp(:,2))       
%     simple=zeros(timespan+1,8);
% 
%     onenode = ref(ref(:,2)==comp(i,2),:);
%     simple(1,:)=onenode(1,:);
%     lasttime=onenode(1,5);
%     start=2;
%     for j=2:timespan
%         for k=start:length(onenode(:,2))
%             if abs(hour(onenode(k,5))-hour(lasttime))>=1
%                 simple(j,:)=onenode(k,:);
%                 lasttime=onenode(k,5);
%                 start=k+1;
%                 break;   
%             end
%         end
%     end   
%     j=length(simple(:,2));
%     while(j)
%         if sum(simple(j,:))~=0
%             break;
%         else
%             simple(j,:)=[];   
%         end
%         j=j-1;
%     end
% %     if i~=1&&i~=16
%     simple1=zeros(timespan+1,8);
%     simple1(1,:)=simple(1,:);
%     for n=2:length(simple(:,2))
%         simple1(1+24*day(simple(n,5))+hour(simple(n,5))-(24*day(simple(1,5))+hour(simple(1,5))),:)=simple(n,:);
%     end
%     n=length(simple1(:,1));
%     while(n)
%         if sum(simple1(n,:))~=0
%             break;
%         else
%             simple1(n,:)=[];   
%         end
%         n=n-1;
%     end
%     simple=simple1;
% %     end
%     
%     simple=[simple;onenode(end,:)];    
%     simples(i).nodeID=simple;
% end
% 
% 
% 
% 
% save ( 'ESRCHE_simpled.mat','comp', 'ref','simples');
% clear;
load('ESRCHE_simpled.mat');

xend=[];
yend=[];
figure(1)
% simples(16)=[];%去除异常
msY=0;
for i=1:length(simples)
    [m,~]=size(simples(i).nodeID);
    x=linspace(1,m,m)'-1;
%     x1=linspace(1,m,m)';
    y=simples(i).nodeID(:,6);    
    x(all(y==0,2),:)=[];
    x(end)=x(end-1)+minute(simples(i).nodeID(end,5))/60;
    y(all(y==0,2),:)=[];
    y=sort(y,'descend');
%     z=interp1(x,y,x1);    
%     b=polyfit(x,y,2);
%     yy=polyval(b,x);
    
    xend=[xend;x(end)];
    yend=[yend;y(end)];
    plot(x,y);
    hold on;
    if msY<m
        msY=m;        
    end
end
xlim([0 25]);
xlabel('时间');
ylabel('电压');
grid on;
hold off;


Ematrix=[];
counts=[];
for i=1:length(simples)
    Ematrix=[Ematrix,[simples(i).nodeID(:,6);zeros(msY-length(simples(i).nodeID(:,6)),1)]];
end
for i=1:length(Ematrix(:,1))
    counts=[counts;sum((Ematrix(i,:)~=0))];
end


AvgEn=sum(Ematrix,2)./counts;
AvgEn(isnan(AvgEn))=0;
figure(2)
x=linspace(1,length(AvgEn),length(AvgEn))'-1;
AvgEn=sort(AvgEn,'descend');
x(all(AvgEn==0,2),:)=[];
AvgEn(all(AvgEn==0,2),:)=[];
% b=polyfit(x,AvgEn,4);% 3 or 4进行6次拟合，b是多项式前面的值。就如2次拟合中y=ax+b,a,b的值。
% b=polyfit(x,interp1(x,y,x),6);
% yy=polyval(b,x);%得到拟合后y的新值

plot(x,AvgEn,'b-')%画拟合图 
xlim([0 25]);
title('平均电压趋势');
xlabel('时间');
ylabel('平均电压');
grid on;
hold off;

% 统计消息数量，运行时间
packetnum=[];
firsttime=[];
lasttime=[];
for i=1:length(comp)
    onenode = ref(ref(:,2)==comp(i,2),:);
    packetnum=[packetnum;length(onenode)*34];%byte
    firsttime=[firsttime;onenode(1,5)];
    lasttime=[lasttime;onenode(end,5)];
end
figure(3)
bar(packetnum);


runningdur=60.*hour(lasttime-firsttime)+minute(lasttime-firsttime); 

