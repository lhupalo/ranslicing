clear all;
clc;

hnoma_std = load('./hnoma_setup5/hnoma_std_fixed.mat');
hnoma_ps0515 = load('./hnoma_setup5/simulacao0515-1000.mat');
hnoma_ps0416 = load('./hnoma_setup5/simulacao0416-1000.mat');
hnoma_ps0317 = load('./hnoma_setup5/simulacao0317-1000.mat');
hnoma_ps0218 = load('./hnoma_setup5/simulacao0218-1000.mat');
hnoma_ps0119 = load('./hnoma_setup5/simulacao0119-1000.mat');


rBf_std = hnoma_std.rBf;
lambda_std = hnoma_std.maxdevices;

rBf_0515 = hnoma_ps0515.rBf;
lambda_0515 = hnoma_ps0515.maxdevices;
gmIni0515 = hnoma_ps0515.Gm_max_inicio;
gm0515 = hnoma_ps0515.Gm_max;

rBf_0416 = hnoma_ps0416.rBf;
lambda_0416 = hnoma_ps0416.maxdevices;
gmIni0416 = hnoma_ps0416.Gm_max_inicio;
gm0416 = hnoma_ps0416.Gm_max;

rBf_0317 = hnoma_ps0317.rBf;
lambda_0317 = hnoma_ps0317.maxdevices;
gmIni0317 = hnoma_ps0317.Gm_max_inicio;
gm0317 = hnoma_ps0317.Gm_max;

rBf_0218 = hnoma_ps0218.rBf;
lambda_0218 = hnoma_ps0218.maxdevices;
gmIni0218 = hnoma_ps0218.Gm_max_inicio;
gm0218 = hnoma_ps0218.Gm_max;

rBf_0119 = hnoma_ps0119.rBf;
lambda_0119 = hnoma_ps0119.maxdevices;
gmIni0119 = hnoma_ps0119.Gm_max_inicio;
gm0119 = hnoma_ps0119.Gm_max;

env_lambda = zeros(1,length(lambda_std));
for i = 1:length(lambda_std)
    lst = [lambda_0515(i), lambda_0416(i), lambda_0317(i), lambda_0218(i), lambda_0119(i)];
    env_lambda(i) = max(max(lambda_std(i)),max(lst));
end

figure;
plot(rBf_std,lambda_std,'-or','LineWidth',2);
hold on;
plot(rBf_std,env_lambda,'-db','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4]);
title('H-NOMA envelope for the best clusters')
legend('H-NOMA without clustering','H-NOMA envelope with best clusters','Location','best')
grid on
%matlab2tikz('hnoma_envelope_best_clusters.tex');
setup5 = [rBf_std; env_lambda];
save('./hnoma_setup5/setup5.mat','setup5');

figure;
plot(rBf_std,lambda_std,'-or','LineWidth',2);
hold on
plot(rBf_std,lambda_0515,'color',[0.4660 0.6740 0.1880],'marker','+','LineWidth',2);
hold on
plot(rBf_std,lambda_0416,'+-b','LineWidth',2);
hold on
plot(rBf_std,lambda_0317,'-xm','LineWidth',2);
hold on
plot(rBf_std,lambda_0218,'-sk','LineWidth',2);
hold on
plot(rBf_std,lambda_0119,'color',[0.4940, 0.1840, 0.5560],'marker','^','LineWidth',2);

xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4]);
title('H-NOMA with clustering procedure')
legend('H-NOMA','H-NOMA with [0.5 1.5]','H-NOMA with [0.4 1.6]','H-NOMA with [0.3 1.7]','H-NOMA with [0.2 1.8]', 'H-NOMA with [0.1 1.9]','Location','best')
grid on
%matlab2tikz('hnoma_with_clustering.tex');
%%
figure;
subplot(5,1,1)
h1 = histogram(10*log10(gmIni0515), 'Normalization','pdf');
hold on;
h2 = histogram(10*log10(gm0515), 'Normalization','pdf');
legend('Without scaling','Scaler = [1.5 0.5]','Location','northwest');
title('Scaling schemes')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,2)
h3 = histogram(10*log10(gmIni0416), 'Normalization','pdf'); 
hold on; 
h4 = histogram(10*log10(gm0416), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.6 0.4]','Location','northwest'); 
%title('Scaling with [1.6 0.4]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,3)
h5 = histogram(10*log10(gmIni0317), 'Normalization','pdf'); 
hold on; 
h6 = histogram(10*log10(gm0317), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.7 0.3]','Location','northwest'); 
%title('Scaling with [1.7 0.3]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,4)
h7 = histogram(10*log10(gmIni0218), 'Normalization','pdf'); 
hold on; 
h8 = histogram(10*log10(gm0218), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [1.8 0.2]','Location','northwest');
%title('Scaling with [1.8 0.2]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(5,1,5)
h9 = histogram(10*log10(gmIni0119), 'Normalization','pdf'); 
hold on; 
h10 = histogram(10*log10(gm0119), 'Normalization','pdf'); 
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
