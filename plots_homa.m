clear all;
clc;

homa_std = load('results_homa.mat');
homa_mmd = load('results_homa_mmd.mat');


rBf_std = homa_std.rBf(:,1);
lambda_std = homa_std.max_devices(:,1);

rBf_mmd = homa_mmd.rBf(:,1);
lambda_mmd = homa_mmd.max_devices(:,1);


figure;
plot(rBf_std,lambda_std,'-r*','LineWidth',2);
hold on
plot(rBf_mmd,lambda_mmd,'-bs','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
legend('H-OMA','H-OMA with MMD')
title('H-OMA, eMBB and mMTC sharing')
grid on