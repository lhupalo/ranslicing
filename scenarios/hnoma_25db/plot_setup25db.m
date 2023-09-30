clear all;
clc;

hnoma_std_25db = load('./hnoma_20db/hnoma_std.mat');
hnoma_ps0515_25db = load('./hnoma_20db/hnoma_0515.mat');
hnoma_ps0416_25db = load('./hnoma_20db/hnoma_0416.mat');
hnoma_ps0317_25db = load('./hnoma_20db/hnoma_0317.mat');
hnoma_ps0218_25db = load('./hnoma_20db/hnoma_0218.mat');
hnoma_ps0119_25db = load('./hnoma_20db/hnoma_0119.mat');

lambda_std_25db = hnoma_std_25db.Lambda_m_non;
rBf_std_25db = hnoma_std_25db.rBf;


rBf_0515_25db = hnoma_ps0515_25db.rBf;
lambda_0515_25db = hnoma_ps0515_25db.maxdevices;
gmIni0515_25db = hnoma_ps0515_25db.Gm_max_inicio;
gm0515_25db = hnoma_ps0515_25db.Gm_max;

rBf_0416_25db = hnoma_ps0416_25db.rBf;
lambda_0416_25db = hnoma_ps0416_25db.maxdevices;
gmIni0416_25db = hnoma_ps0416_25db.Gm_max_inicio;
gm0416_25db = hnoma_ps0416_25db.Gm_max;

rBf_0317_25db = hnoma_ps0317_25db.rBf;
lambda_0317_25db = hnoma_ps0317_25db.maxdevices;
gmIni0317_25db = hnoma_ps0317_25db.Gm_max_inicio;
gm0317_25db = hnoma_ps0317_25db.Gm_max;

rBf_0218_25db = hnoma_ps0218_25db.rBf;
lambda_0218_25db = hnoma_ps0218_25db.maxdevices;
gmIni0218_25db = hnoma_ps0218_25db.Gm_max_inicio;
gm0218_25db = hnoma_ps0218_25db.Gm_max;

rBf_0119_25db = hnoma_ps0119_25db.rBf;
lambda_0119_25db = hnoma_ps0119_25db.maxdevices;
gmIni0119_25db = hnoma_ps0119_25db.Gm_max_inicio;
gm0119_25db = hnoma_ps0119_25db.Gm_max;

env_lambda_25db = zeros(1,length(hnoma_ps0515_25db.rBf));
for i = 1:length(lambda_std_25db)
    lst = [lambda_0515_25db(i), lambda_0416_25db(i), lambda_0317_25db(i), lambda_0218_25db(i), lambda_0119_25db(i)];
    env_lambda_25db(i) = max(max(lambda_std_25db(i)),max(lst));
end

figure;
plot(rBf_std_25db,smooth(lambda_std_25db),'r','LineWidth',2);
hold on;
plot(rBf_std_25db,smooth(env_lambda_25db),'b','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4]);
% title('H-NOMA envelope for the best clusters')
legend('H-NOMA without clustering','H-NOMA envelope with best clusters','Location','best')
grid on
matlab2tikz('hnoma_envelope_best_allocations.tex');
setup1 = [rBf_std_25db; env_lambda_25db];
save('./hnoma_25db/setup1.mat','setup1');

figure;
plot(rBf_std_25db,smooth(lambda_std_25db),'r','LineWidth',2);
hold on
plot(rBf_std_25db,smooth(lambda_0515_25db),'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(rBf_std_25db,smooth(lambda_0416_25db),'b','LineWidth',2);
hold on
plot(rBf_std_25db,smooth(lambda_0317_25db),'m','LineWidth',2);
hold on
plot(rBf_std_25db,smooth(lambda_0218_25db),'k','LineWidth',2);
hold on
plot(rBf_std_25db,smooth(lambda_0119_25db),'color',[0.4940, 0.1840, 0.5560],'LineWidth',2);

xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4]);
% title('H-NOMA with clustering procedure')
legend('H-NOMA','H-NOMA with [0.5 1.5]','H-NOMA with [0.4 1.6]','H-NOMA with [0.3 1.7]','H-NOMA with [0.2 1.8]', 'H-NOMA with [0.1 1.9]','Location','best')
grid on
matlab2tikz('hnoma_with_allocation.tex');
%%

fig = figure;
subplot(2,2,1)
h1 = histogram(10*log10(gmIni0515_25db), 'Normalization','pdf');
hold on;
h2 = histogram(10*log10(gm0515_25db), 'Normalization','pdf');
legend('\beta= \left\{1 \right\}','\beta= \left\{0.5\;1.5 \right\}','Location','northwest');
% title('Scaling schemes')
xlim([-30, 20])
% xlabel('dB')
grid on

% subplot(5,1,2)
% h3 = histogram(10*log10(gmIni0416_25db), 'Normalization','pdf'); 
% hold on; 
% h4 = histogram(10*log10(gm0416_25db), 'Normalization','pdf'); 
% legend('$\beta= \left\{1 \right\}$','$\beta= \left\{0.4\;1.6 \right\}$','Location','northwest'); 
% %title('Scaling with [1.6 0.4]')
% xlim([-30, 20])
% % xlabel('dB')
% grid on

subplot(2,2,2)
h5 = histogram(10*log10(gmIni0317_25db), 'Normalization','pdf'); 
hold on; 
h6 = histogram(10*log10(gm0317_25db), 'Normalization','pdf'); 
legend('\beta= \left\{1 \right\}','\beta= \left\{0.3\;1.7 \right\}','Location','northwest'); 
%title('Scaling with [1.7 0.3]')
xlim([-30, 20])
% xlabel('dB')
grid on

subplot(2,2,3)
h7 = histogram(10*log10(gmIni0218_25db), 'Normalization','pdf'); 
hold on; 
h8 = histogram(10*log10(gm0218_25db), 'Normalization','pdf'); 
legend('\beta= \left\{1 \right\}','\beta= \left\{0.2\;1.8 \right\}','Location','northwest');
%title('Scaling with [1.8 0.2]')
xlim([-30, 20])
% xlabel('dB')
grid on

subplot(2,2,4)
h9 = histogram(10*log10(gmIni0119_25db), 'Normalization','pdf'); 
hold on; 
h10 = histogram(10*log10(gm0119_25db), 'Normalization','pdf'); 
legend('\beta= \left\{1 \right\}','\beta= \left\{0.1\;1.9 \right\}','Location','northwest');
%title('Scaling with [1.9 0.1]')
xlim([-30, 20])
% xlabel('dB')
grid on


x0=10;
y0=10;
width=1200;
height=500;
set(gcf,'position',[x0,y0,width,height])



% han=axes(fig,'visible','off'); 
% han.Title.Visible='off';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Normalized PDF');
% xlabel(han,'dB');
% 
% ylabelHandle = get(gca,'ylabel');
% ylabelPos = get(ylabelHandle,'Position');
% ylabelPos(1) = ylabelPos(1) - 0.05;
% set(ylabelHandle,'Position',ylabelPos)

matlab2tikz('hnoma_histograms.tex');
