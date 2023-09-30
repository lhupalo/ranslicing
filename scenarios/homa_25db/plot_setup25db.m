clear all;
clc;

% Load H-OMA 25db
homa_std_25db = load('./homa_20db/homa_std.mat');
homa_0119_25db = load('./homa_20db/homa_0119.mat');
homa_0218_25db = load('./homa_20db/homa_0218.mat');
homa_0317_25db = load('./homa_20db/homa_0317.mat');
homa_0416_25db = load('./homa_20db/homa_0416.mat');
homa_0515_25db = load('./homa_20db/homa_0515.mat');

homaenv_lambda_25db = zeros(1,length(homa_0515_25db.alpha));
for i = 1:length(homa_0515_25db.alpha)
    lst = [homa_0119_25db.max_devices(i,1), homa_0218_25db.max_devices(i,1), homa_0317_25db.max_devices(i,1), homa_0416_25db.max_devices(i,1), homa_0515_25db.max_devices(i,1), homa_std_25db.max_devices(i,1)];
    homaenv_lambda_25db(i) = max(lst);
end

homaenv_lambda_25db(end)=0;
homa_std_25db.max_devices(end,1) = 0;
homa_0119_25db.max_devices(end,1) = 0;
homa_0218_25db.max_devices(end,1) = 0;
homa_0317_25db.max_devices(end,1) = 0;
homa_0416_25db.max_devices(end,1) = 0;
homa_0515_25db.max_devices(end,1) = 0;

figure;
plot(homa_std_25db.rBf(:,1),smooth(homa_std_25db.max_devices(:,1)),'r','LineWidth',2);
hold on;
plot(homa_std_25db.rBf(:,1),smooth(homaenv_lambda_25db),'b','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4.2]);
% title('H-NOMA envelope for the best clusters')
legend('Standard H-OMA','H-OMA with best clusters','Location','best')
grid on
matlab2tikz('homa_envelope_best_allocations.tex');
% setup1 = [rBf_std_25db; env_lambda_25db];
% save('./hnoma_25db/setup1.mat','setup1');

figure;
plot(homa_std_25db.rBf(:,1),smooth(homa_std_25db.max_devices(:,1)),'r','LineWidth',2);
hold on
plot(homa_std_25db.rBf(:,1),smooth(homa_0515_25db.max_devices(:,1)),'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(homa_std_25db.rBf(:,1),smooth(homa_0416_25db.max_devices(:,1)),'b','LineWidth',2);
hold on
plot(homa_std_25db.rBf(:,1),smooth(homa_0317_25db.max_devices(:,1)),'m','LineWidth',2);
hold on
plot(homa_std_25db.rBf(:,1),smooth(homa_0218_25db.max_devices(:,1)),'k','LineWidth',2);
hold on
plot(homa_std_25db.rBf(:,1),smooth(homa_0119_25db.max_devices(:,1)),'color',[0.4940, 0.1840, 0.5560],'LineWidth',2);

xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4.2]);
% title('H-NOMA with clustering procedure')
legend('Standard H-OMA','H-OMA with [0.5 1.5]','H-OMA with [0.4 1.6]','H-OMA with [0.3 1.7]','H-OMA with [0.2 1.8]', 'H-OMA with [0.1 1.9]','Location','best')
grid on
% matlab2tikz('homa_with_allocation.tex');
%%

% Load H-OMA 25db
hist_25db = load('./hnoma_10db/hnoma_std.mat');

gm_ini = hist_25db.Gm_max;

scaling_1 = gm_ini;
scaling_2 = gm_ini;
scaling_3 = gm_ini;

scaling1 = [0.1 0.5 1.5 1.9];
scaling2 = [0.1 0.2 1.8 1.9];
scaling3 = [0.4 0.9 1.2 1.5];

for i = 1:200
    for j = 1:500
        index1 = randi(length(scaling1));
        scale_factor1 = scaling1(index1);
        
        index2 = randi(length(scaling2));
        scale_factor2 = scaling1(index2);
        
        index3 = randi(length(scaling3));
        scale_factor3 = scaling3(index3);
        
        scaling_1(i,j) = scale_factor1*scaling_1(i,j);
        scaling_2(i,j) = scale_factor2*scaling_2(i,j);
        scaling_3(i,j) = scale_factor3*scaling_3(i,j);
    end
end

figure;
subplot(3,1,1)
h1 = histogram(10*log10(gm_ini), 'Normalization','pdf');
hold on;
h2 = histogram(10*log10(scaling_1), 'Normalization','pdf');
legend('Without scaling','Scaler = [0.1 0.5 1.5 1.9]','Location','northwest');
% title('Scaling schemes')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(3,1,2)
h3 = histogram(10*log10(gm_ini), 'Normalization','pdf'); 
hold on; 
h4 = histogram(10*log10(scaling_2), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [0.1 0.2 1.8 1.9]','Location','northwest'); 
%title('Scaling with [1.6 0.4]')
xlim([-30, 20])
xlabel('dB')
grid on

subplot(3,1,3)
h5 = histogram(10*log10(gm_ini), 'Normalization','pdf'); 
hold on; 
h6 = histogram(10*log10(scaling_3), 'Normalization','pdf'); 
legend('Without scaling','Scaler = [0.4 0.9 1.2 1.5]','Location','northwest'); 
%title('Scaling with [1.7 0.3]')
xlim([-30, 20])
xlabel('dB')
grid on
% 
% subplot(5,1,4)
% h7 = histogram(10*log10(gmIni0218_25db), 'Normalization','pdf'); 
% hold on; 
% h8 = histogram(10*log10(gm0218_25db), 'Normalization','pdf'); 
% legend('Without scaling','Scaler = [1.8 0.2]','Location','northwest');
% %title('Scaling with [1.8 0.2]')
% xlim([-30, 20])
% xlabel('dB')
% grid on
% 
% subplot(5,1,5)
% h9 = histogram(10*log10(gmIni0119_25db), 'Normalization','pdf'); 
% hold on; 
% h10 = histogram(10*log10(gm0119_25db), 'Normalization','pdf'); 
% legend('Without scaling','Scaler = [1.9 0.1]','Location','northwest');
% %title('Scaling with [1.9 0.1]')
% xlim([-30, 20])
% xlabel('dB')
% grid on

x0=10;
y0=10;
width=500;
height=1000;
set(gcf,'position',[x0,y0,width,height])
matlab2tikz('other_hnoma_histograms.tex');
