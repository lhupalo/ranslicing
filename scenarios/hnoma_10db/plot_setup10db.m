clear all;
clc;

% Load H-NOMA 10 db
hnoma_std_10db = load('./hnoma_10db/hnoma_std.mat');
hnoma_ps0515_10db = load('./hnoma_10db/hnoma_0515.mat');
hnoma_ps0416_10db = load('./hnoma_10db/hnoma_0416.mat');
hnoma_ps0317_10db = load('./hnoma_10db/hnoma_0317.mat');
hnoma_ps0218_10db = load('./hnoma_10db/hnoma_0218.mat');
hnoma_ps0119_10db = load('./hnoma_10db/hnoma_0119.mat');

lambda_std_10db = hnoma_std_10db.Lambda_m_non;
rBf_std_10db = hnoma_std_10db.rBf;


rBf_0515_10db = hnoma_ps0515_10db.rBf;
lambda_0515_10db = hnoma_ps0515_10db.maxdevices;
gmIni0515_10db = hnoma_ps0515_10db.Gm_max_inicio;
gm0515_10db = hnoma_ps0515_10db.Gm_max;

rBf_0416_10db = hnoma_ps0416_10db.rBf;
lambda_0416_10db = hnoma_ps0416_10db.maxdevices;
gmIni0416_10db = hnoma_ps0416_10db.Gm_max_inicio;
gm0416_10db = hnoma_ps0416_10db.Gm_max;

rBf_0317_10db = hnoma_ps0317_10db.rBf;
lambda_0317_10db = hnoma_ps0317_10db.maxdevices;
gmIni0317_10db = hnoma_ps0317_10db.Gm_max_inicio;
gm0317_10db = hnoma_ps0317_10db.Gm_max;

rBf_0218_10db = hnoma_ps0218_10db.rBf;
lambda_0218_10db = hnoma_ps0218_10db.maxdevices;
gmIni0218_10db = hnoma_ps0218_10db.Gm_max_inicio;
gm0218_10db = hnoma_ps0218_10db.Gm_max;

rBf_0119_10db = hnoma_ps0119_10db.rBf;
lambda_0119_10db = hnoma_ps0119_10db.maxdevices;
gmIni0119_10db = hnoma_ps0119_10db.Gm_max_inicio;
gm0119_10db = hnoma_ps0119_10db.Gm_max;

env_lambda_noma10db = zeros(1,length(hnoma_ps0515_10db.rBf));
for i = 1:length(lambda_std_10db)
    lst = [lambda_0515_10db(i), lambda_0416_10db(i), lambda_0317_10db(i), lambda_0218_10db(i), lambda_0119_10db(i)];
    env_lambda_noma10db(i) = max(max(lambda_std_10db(i)),max(lst));
end

figure;
plot(rBf_std_10db,smooth(lambda_std_10db),'r','LineWidth',2);
hold on;
plot(rBf_std_10db,smooth(env_lambda_noma10db),'b','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 2]);
title('H-NOMA envelope for the best clusters')
legend('H-NOMA without clustering','H-NOMA envelope with best clusters','Location','best')
grid on
%matlab2tikz('hnoma_envelope_best_clusters.tex');
% setup1 = [rBf_std_10db; env_lambda_noma10db];
% save('./hnoma_10db/setup1.mat','setup1');

figure;
plot(rBf_std_10db,smooth(lambda_std_10db),'r','LineWidth',2);
hold on
plot(rBf_std_10db,smooth(lambda_0515_10db),'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(rBf_std_10db,smooth(lambda_0416_10db),'b','LineWidth',2);
hold on
plot(rBf_std_10db,smooth(lambda_0317_10db),'m','LineWidth',2);
hold on
plot(rBf_std_10db,smooth(lambda_0218_10db),'k','LineWidth',2);
hold on
plot(rBf_std_10db,smooth(lambda_0119_10db),'color',[0.4940, 0.1840, 0.5560],'LineWidth',2);

xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 2]);
title('H-NOMA with clustering procedure')
legend('H-NOMA','H-NOMA with [0.5 1.5]','H-NOMA with [0.4 1.6]','H-NOMA with [0.3 1.7]','H-NOMA with [0.2 1.8]', 'H-NOMA with [0.1 1.9]','Location','best')
grid on
% matlab2tikz('hnoma_with_clustering2.tex');
%%
figure;
subplot(5,1,1)
h1 = histogram(10*log10(gmIni0515_10db), 'Normalization','pdf');
hold on;
h2 = histogram(10*log10(gm0515_10db), 'Normalization','pdf');
legend('Without scaling','Scaler = [1.5 0.5]','Location','northwest');
title('Scaling schemes')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,2)
h3 = histogram(10*log10(gmIni0416_10db), 'Normalization','pdf'); 
hold on; 
h4 = histogram(10*log10(gm0416_10db), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.6 0.4]','Location','northwest'); 
%title('Scaling with [1.6 0.4]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,3)
h5 = histogram(10*log10(gmIni0317_10db), 'Normalization','pdf'); 
hold on; 
h6 = histogram(10*log10(gm0317_10db), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.7 0.3]','Location','northwest'); 
%title('Scaling with [1.7 0.3]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,4)
h7 = histogram(10*log10(gmIni0218_10db), 'Normalization','pdf'); 
hold on; 
h8 = histogram(10*log10(gm0218_10db), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.8 0.2]','Location','northwest');
%title('Scaling with [1.8 0.2]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,5)
h9 = histogram(10*log10(gmIni0119_10db), 'Normalization','pdf'); 
hold on; 
h10 = histogram(10*log10(gm0119_10db), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.9 0.1]','Location','northwest');
%title('Scaling with [1.9 0.1]')
xlim([-30, 20])
xlabel('dB')
grid on

x0=10;
y0=10;
width=500;
height=1000;
set(gcf,'position',[x0,y0,width,height])
%matlab2tikz('hnoma_histograms.tex');
