clear all;
clc;

homa_std = load('results_homa.mat');
homa_mmd4 = load('results_homa_mmd_FB4.mat');
homa_mmd8 = load('results_homa_mmd_FB8.mat');
homa_mmd6 = load('results_homa_mmd_FB6.mat');
homa_mmd10 = load('results_homa_mmd_FB10.mat');
homa_mmd12 = load('results_homa_mmd_FB12.mat');


rBf_std = homa_std.rBf(:,1);
lambda_std = homa_std.max_devices(:,1);

rBf_mmd4 = homa_mmd4.rBf(:,1);
lambda_mmd4 = homa_mmd4.max_devices(:,1);

rBf_mmd6 = homa_mmd6.rBf(:,1);
lambda_mmd6 = homa_mmd6.max_devices(:,1);

rBf_mmd8 = homa_mmd8.rBf(:,1);
lambda_mmd8 = homa_mmd8.max_devices(:,1);

rBf_mmd10 = homa_mmd10.rBf(:,1);
lambda_mmd10 = homa_mmd10.max_devices(:,1);

rBf_mmd12 = homa_mmd12.rBf(:,1);
lambda_mmd12 = homa_mmd12.max_devices(:,1);


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
legend('H-OMA','MMD H-OMA, F_B = 4','MMD H-OMA, F_B = 6','MMD H-OMA, F_B = 8','MMD H-OMA, F_B = 10','MMD H-OMA, F_B = 12')
title('H-OMA, eMBB and mMTC sharing')
grid on

%% 

clear all;
clc;

homa_mmdEb104 = load('results_homa_mmd_FB8_e104.mat');
homa_mmdEb103 = load('results_homa_mmd_FB8_e103.mat');
homa_mmdEb102 = load('results_homa_mmd_FB8_e102.mat');
homa_mmdEb101 = load('results_homa_mmd_FB8_e101.mat');


rbf_mmdEb104 = homa_mmdEb104.rBf(:,1);
lambda_mmdEb104= homa_mmdEb104.max_devices(:,1);

rbf_mmdEb103 = homa_mmdEb103.rBf(:,1);
lambda_mmdEb103= homa_mmdEb103.max_devices(:,1);

rbf_mmdEb102 = homa_mmdEb102.rBf(:,1);
lambda_mmdEb102= homa_mmdEb102.max_devices(:,1);

rbf_mmdEb101 = homa_mmdEb101.rBf(:,1);
lambda_mmdEb101= homa_mmdEb101.max_devices(:,1);


figure;
plot(rbf_mmdEb101,lambda_mmdEb101,'-r*','LineWidth',2);
hold on
plot(rbf_mmdEb102,lambda_mmdEb102,'-bs','LineWidth',2);
hold on
plot(rbf_mmdEb103,lambda_mmdEb103,'-hy','LineWidth',2);
hold on
plot(rbf_mmdEb104,lambda_mmdEb104,'-xm','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
legend('E_b=10e-1','E_b=10e-2','E_b=10e-3','E_b=10e-4')
title('MMD H-OMA, eMBB and mMTC sharing. F_B = 8')
grid on