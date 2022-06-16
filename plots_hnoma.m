clear all;
clc;

hnoma_std = load('results_hnoma.mat');
hnoma_mmd4 = load('results_hnoma_mmd_FB4.mat');
hnoma_mmd8 = load('results_hnoma_mmd_FB8.mat');
hnoma_mmd6 = load('results_hnoma_mmd_FB6.mat');
hnoma_mmd10 = load('results_hnoma_mmd_FB10.mat');
hnoma_mmd12 = load('results_hnoma_mmd_FB12.mat');


rBf_std = hnoma_std.rBf;
lambda_std = hnoma_std.maxdevices;

rBf_mmd4 = hnoma_mmd4.rBf;
lambda_mmd4 = hnoma_mmd4.maxdevices;

rBf_mmd6 = hnoma_mmd6.rBf;
lambda_mmd6 = hnoma_mmd6.maxdevices;

rBf_mmd8 = hnoma_mmd8.rBf;
lambda_mmd8 = hnoma_mmd8.maxdevices;

rBf_mmd10 = hnoma_mmd10.rBf;
lambda_mmd10 = hnoma_mmd10.maxdevices;

rBf_mmd12 = hnoma_mmd12.rBf;
lambda_mmd12 = hnoma_mmd12.maxdevices;


figure;
plot(rBf_std,lambda_std,'-r*','LineWidth',2);
hold on
plot(rBf_mmd4,lambda_mmd4,'-bs','LineWidth',2);
hold on
plot(rBf_mmd6,lambda_mmd6,'-hy','LineWidth',2);
hold on
plot(rBf_mmd8,lambda_mmd8,'-xm','LineWidth',2);
hold on
plot(rBf_mmd10,lambda_mmd10,'-kp','LineWidth',2);
hold on
plot(rBf_mmd12,lambda_mmd12,'-+g','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
legend('H-NOMA','MMD H-NOMA, F_B = 4','MMD H-NOMA, F_B = 6','MMD H-NOMA, F_B = 8','MMD H-NOMA, F_B = 10','MMD H-NOMA, F_B = 12')
title('H-OMA, eMBB and mMTC sharing')
grid on