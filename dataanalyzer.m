clear;clc;close all;
% [ref,temp] = xlsread('./leach-orig/MHLeach_orig_Results.xlsx','Results');
% for i=1:length(ref)
%     ref(i,5)=datenum(temp(i+1,5));
% end
% 
% comp = xlsread('./leach-orig/MHLeach_orig_Results.xlsx','Compute');
% save ( 'orig.mat','comp', 'ref');
% clear;clc;
% MINUTEUNIT=datenum(2001,01,01,12,01,00)-datenum(2001,01,01,12,00,00);
% HOURUNIT=datenum(2001,01,01,13,00,00)-datenum(2001,01,01,12,00,00);
% load('orig');
% 
% for i=1:length(comp)
%     onenode = ref(ref(:,2)==comp(i,2),:);
%     timespan = round((onenode(end,5)-onenode(1,5))/HOURUNIT);
% %     idx=round(linspace(onenode(1,4),onenode(end,4),timespan));
% %     idx=round(linspace(1,length(onenode),timespan));
%     simple=onenode(1,:);
%     lasttime=onenode(1,5);
%     start=1;
%     for j=1:timespan
%         for k=start:length(onenode)
%             if abs(hour(onenode(k,5))-hour(lasttime))>=hour(HOURUNIT)
%                 simple=[simple;onenode(k,:)];
%                 lasttime=onenode(k,5);
%                 start=k+1;
%                 break;   
%             end
%         end
%     end
%     simple=[simple;onenode(end,:)];
%     simples(i).nodeID=simple;
% end
% save ( 'orig_simpled.mat','comp', 'ref','simples');
% clear;
load('orig_simpled.mat');


figure(1)
simples(16)=[];
msY=0;
for i=1:length(simples)
    [m,~]=size(simples(i).nodeID);
    x=linspace(1,m,m)';
    y=simples(i).nodeID(:,6);
    plot(x,y);
    hold on;
    if msY<length(y)
        msY=length(y);        
    end
end
xlabel('时间');
ylabel('电压');
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


AvgEn=sum(Ematrix,2)./counts;
AvgEn=sort(AvgEn,'descend');
figure(2)
b=polyfit(x,AvgEn,6);%进行6次拟合，b是多项式前面的值。就如2次拟合中y=ax+b,a,b的值。
yy=polyval(b,x);%得到拟合后y的新值
plot(x,yy,'b-')%画拟合图 
title('平均电压趋势');
xlabel('时间');
ylabel('平均电压');
grid on;
hold off;




