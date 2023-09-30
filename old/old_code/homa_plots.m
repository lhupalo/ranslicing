clear all;
clc

homa_std = load('homa_std.mat');
homa_mmd = load('homa_mmd.mat');

figure;
plot(homa_mmd.alpha,homa_std.max_devices(:,1),'-or','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.lambdas_homa_mmd(:,1),'+-b','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.lambdas_homa_mmd(:,2),'-xm','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.lambdas_homa_mmd(:,3),'-sk','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.lambdas_homa_mmd(:,4),'-dg','LineWidth',2);
xlabel('$\alpha$','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
title('H-OMA with MMD, Number of mMTC Devices vs. Alpha')
legend('H-OMA','H-OMA with MMD, F_b = 4','H-OMA with MMD, F_b = 8','H-OMA with MMD, F_b = 12','H-OMA with MMD, F_b = 16')
grid on

figure;
plot(homa_mmd.alpha,homa_std.rBf(:,1),'-or','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.rates_homa_mmd(:,1),'+-b','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.rates_homa_mmd(:,2),'-xm','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.rates_homa_mmd(:,3),'-sk','LineWidth',2);
hold on
plot(homa_mmd.alpha,homa_mmd.rates_homa_mmd(:,4),'-dg','LineWidth',2);
xlabel('$\alpha$','Interpreter','latex','fontsize',12)
ylabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
title('H-OMA with MMD, eMBB Rates vs. Alpha')
legend('H-OMA','H-OMA with MMD, F_b = 4','H-OMA with MMD, F_b = 8','H-OMA with MMD, F_b = 12','H-OMA with MMD, F_b = 16','Location','northwest')
grid on