clear all;
clc

% Load H-OMA 10 dB
homa_std_10db = load('./homa_10db/homa_std.mat');
homa_0119_10db = load('./homa_10db/homa_0119.mat');
homa_0218_10db = load('./homa_10db/homa_0218.mat');
homa_0317_10db = load('./homa_10db/homa_0317.mat');
homa_0416_10db = load('./homa_10db/homa_0416.mat');
homa_0515_10db = load('./homa_10db/homa_0515.mat');

homaenv_lambda_10db = zeros(1,length(homa_0515_10db.alpha));
for i = 1:length(homa_0515_10db.alpha)
    lst = [homa_0119_10db.max_devices(i), homa_0218_10db.max_devices(i), homa_0317_10db.max_devices(i), homa_0416_10db.max_devices(i), homa_0515_10db.max_devices(i), homa_std_10db.max_devices(i,1)];
    homaenv_lambda_10db(i) = max(lst);
end

homaenv_lambda_10db(end)=0;
homa_std_10db.max_devices(end,1) = 0;

% Load H-OMA 20db
homa_std_25db = load('./homa_20db/homa_std.mat');
homa_0119_25db = load('./homa_20db/homa_0119.mat');
homa_0218_25db = load('./homa_20db/homa_0218.mat');
homa_0317_25db = load('./homa_20db/homa_0317.mat');
homa_0416_25db = load('./homa_20db/homa_0416.mat');
homa_0515_25db = load('./homa_20db/homa_0515.mat');

homaenv_lambda_25db = zeros(1,length(homa_0515_25db.alpha));
for i = 1:length(homa_0515_25db.alpha)
    lst = [homa_0119_25db.max_devices(i), homa_0218_25db.max_devices(i), homa_0317_25db.max_devices(i), homa_0416_25db.max_devices(i), homa_0515_25db.max_devices(i), homa_std_25db.max_devices(i,1)];
    homaenv_lambda_25db(i) = max(lst);
end

homaenv_lambda_25db(end)=0;
homa_std_25db.max_devices(end,1) = 0;

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

% Load H-NOMA 25 dB
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

env_lambda_25db_noma = zeros(1,length(hnoma_ps0515_25db.rBf));
for i = 1:length(lambda_std_25db)
    lst = [lambda_0515_25db(i), lambda_0416_25db(i), lambda_0317_25db(i), lambda_0218_25db(i), lambda_0119_25db(i)];
    env_lambda_25db_noma(i) = max(max(lambda_std_25db(i)),max(lst));
end

figure;
plot(homa_0515_10db.rBf(:,1),smooth(homaenv_lambda_10db),'--b','LineWidth',2);
hold on;
% plot(homa_std_25db.rBf(:,1),smooth(homa_std_25db.max_devices(:,1)),'--','Color', [0.9290 0.6940 0.1250],'LineWidth',2);
% hold on;
plot(rBf_std_10db,smooth(env_lambda_noma10db),'b','LineWidth',2);
hold on;
plot(homa_0515_25db.rBf(:,1),smooth(homaenv_lambda_25db),'--r','LineWidth',2);
% plot(rBf_std_25db,smooth(lambda_std_25db),'r','LineWidth',2);
hold on;
plot(rBf_std_25db,smooth(env_lambda_25db_noma),'r','LineWidth',2);
% plot(rBf_std_10db,smooth(lambda_std_10db),'r','LineWidth',2);
% plot(homa_std_10db.rBf(:,1),smooth(homa_std_10db.max_devices(:,1)),'--r','LineWidth',2);
%xlabel('$\alpha$','Interpreter','latex','fontsize',12)
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4.2]);
title('')
legend('H-OMA best \beta 10dB','H-NOMA best \beta 10dB', 'H-OMA best \beta 25dB','H-NOMA best \beta 25dB','Location','northeast')
grid on
matlab2tikz('all_comparison.tex');

% setup1 = [homa_0515_10db.rBf; env_lambda_10db];
% save('./homa_10db/setup1.mat','setup1');

