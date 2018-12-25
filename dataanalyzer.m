clear;clc;close all;
% [ref,temp] = xlsread('./leach-orig/MHLeach_orig_Results.xlsx','Results');
% ref(1:end,5)=datenum(temp(2:end,5));
% 
% 
% comp = xlsread('./leach-orig/MHLeach_orig_Results.xlsx','Compute');
% save ( 'orig.mat','comp', 'ref');
% clear;clc;
MINUTEUNIT=datenum(2001,01,01,12,01,00)-datenum(2001,01,01,12,00,00);
HOURUNIT=datenum(2001,01,01,13,00,00)-datenum(2001,01,01,12,00,00);
load('orig1'); 

timespan = 24*day(ref(end,5)-ref(1,5))+hour(ref(end,5)-ref(1,5));
% for i=1:length(comp(:,2))       
%     simple=zeros(timespan+1,8);
%     if comp(i,2)==412||comp(i,2)==436||comp(i,2)==429
%         load('orig');
%         flag=0;
%         onenode = ref(ref(:,2)==comp(i,2),:);%412,436 
%         for j=1:length(onenode(:,1))            
%             if flag==1||day(onenode(j,5))==4&&hour(onenode(j-1,5))==12&&hour(onenode(j,5))==1
%                 flag=1;
%                 onenode(j,5)=onenode(j,5)+datenum(0,0,0,12,0,0);
%             end
%             if day(onenode(j,5))==3
%                 onenode(j,5)=onenode(j,5)+datenum(0,0,0,12,0,0);
%             end
%         end
%         load('orig1');
%     end
%     load('orig1');
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
%     if i~=1&&i~=16&&i~=11
%         simple1=zeros(timespan+1,8);
%         simple1(1,:)=simple(1,:);
%         for n=2:length(simple(:,2))
%             simple1(1+24*day(simple(n,5))+hour(simple(n,5))-(24*day(simple(1,5))+hour(simple(1,5))),:)=simple(n,:);
%         end
%         n=length(simple1(:,1));
%         while(n)
%             if sum(simple1(n,:))~=0
%                 break;
%             else
%                 simple1(n,:)=[];   
%             end
%             n=n-1;
%         end
%         simple=simple1;
%     end
%     
%     simple=[simple;onenode(end,:)];    
%     simples(i).nodeID=simple;
% end
% save ( 'orig_simpled1.mat','comp', 'ref','simples');

% 


clear;
load('orig_simpled1.mat');


figure('NumberTitle', 'off', 'Name', '单个节点电压变化');
msY=0;
tend=[];
for i=1:length(simples)
    [m,~]=size(simples(i).nodeID);
    x=linspace(1,m,m)'-1;
    y=simples(i).nodeID(:,6);    
    x(all(y==0,2),:)=[];
    x(end)=x(end-1)+minute(simples(i).nodeID(end,5))/60;
    y(all(y==0,2),:)=[];
    y=sort(y,'descend');
%     z=interp1(x,y,x1);    
%     b=polyfit(x,y,2);
%     yy=polyval(b,x);
    
    tend=[tend;simples(i).nodeID(1,2),x(end)];
    plot(x,y);
    hold on;
    if msY<length(y)
        msY=length(y);        
    end
end
xlabel('时间/h');
ylabel('电压/V');
grid on;
hold off;


Ematrix=[];
counts=[];
for i=1:length(simples)
    Ematrix=[Ematrix,[simples(i).nodeID(:,6);zeros(msY-length(simples(i).nodeID(:,6)),1)]];
end
for i=1:length(Ematrix)
    counts=[counts;sum((Ematrix(i,:)~=0))];
end






[xend,I]=sort(tend(:,2));
yend=linspace(length(xend),1,length(xend))';
AvgEn=sum(Ematrix,2)./counts;
figure('NumberTitle', 'off', 'Name', 'energytrend2');
x=linspace(1,length(AvgEn),length(AvgEn))'-1;
AvgEn=sort(AvgEn,'descend');
b=polyfit(x,AvgEn,3);% 3 or 4进行次拟合，b是多项式前面的值。就如2次拟合中y=ax+b,a,b的值。
% b=polyfit(x,interp1(x,y,x),7);
yy=polyval(b,x);%得到拟合后y的新值
plot(x,[AvgEn(1:12);yy(13:end)],'b-');%画拟合图
% plot(x,AvgEn,'b-');%画拟合图
hold on;
title('平均电压趋势');
xlabel('时间/h');
ylabel('平均电压/V');
grid on;
hold off;


figure('NumberTitle', 'off', 'Name', 'sustainNode');
plot(xend,yend,'b-',xend,yend,'rx');
hold on;
for i=1:length(xend)
    text(xend(i),yend(i)+0.5,char(['0x0',dec2hex(tend(I(i),1))]));
end
title('死亡时间/h');
xlabel('时间/h');
ylabel('剩余节点数/个');
grid on;
hold off;




% 统计消息数量，运行时间
packetnum=[];
dur=[];
temp=[];
for i=1:length(comp)    
    if comp(i,2)==412||comp(i,2)==436||comp(i,2)==429
        load('orig');
        flag=0;
        onenode = ref(ref(:,2)==comp(i,2),:);%412,436 
        for j=1:length(onenode(:,1))            
            if flag==1||day(onenode(j,5))==4&&hour(onenode(j-1,5))==12&&hour(onenode(j,5))==1
                flag=1;
                onenode(j,5)=onenode(j,5)+datenum(0,0,0,12,0,0);
            end
            if day(onenode(j,5))==3
                onenode(j,5)=onenode(j,5)+datenum(0,0,0,12,0,0);
            end
        end
        load('orig1');
    else
        load('orig1');
        onenode = ref(ref(:,2)==comp(i,2),:);
    end
    packetnum=[packetnum;length(onenode(:,1))*34];%byte
    dur=[dur;onenode(end,5)-onenode(1,5)];
    temp=[temp;strcat('0x0',dec2hex(comp(i,2)))];
end

xtick=mat2cell(temp,ones(length(comp),1),6);
x=linspace(1,length(comp),length(comp))*10;

figure('NumberTitle', 'off', 'Name', 'bytepackets');
barh(x,packetnum,0.6,'b');
hold on;
ylim([5 210]);
set(gca,'ytick',x);
set(gca,'yticklabel',xtick);
title('组网数据包数');
xlabel('消息量/byte');
ylabel('节点ID');
grid on;
hold off;

% load firstlast;
runningdur=60.*(24.*day(dur)+hour(dur))+minute(dur); 


figure('NumberTitle', 'off', 'Name', 'sustaindur');
barh(x,runningdur,0.6,'b');
hold on;
ylim([0 210]);
set(gca,'ytick',x);
set(gca,'yticklabel',xtick);
title('节点生存时间统计');
ylabel('节点ID');
xlabel('生存时间/mins');
hold off;

