clear all;
clc

%homa_std = load('novahomanormal.mat');
homa_std = load('homa_std.mat');
homa_0119 = load('novahoma0119.mat');
homa_0218 = load('novahoma0218.mat');
homa_0317 = load('novahoma0317.mat');
homa_0416 = load('novahoma0416.mat');
homa_0515 = load('novahoma0515.mat');

env_lambda = zeros(1,length(homa_std.alpha));
for i = 1:length(homa_std.alpha)
    lst = [homa_0119.maxdevices(i), homa_0218.maxdevices(i), homa_0317.maxdevices(i), homa_0416.maxdevices(i), homa_0515.maxdevices(i)];
    env_lambda(i) = max(lst);
end

figure;
plot(homa_std.rBf(:,1),homa_std.max_devices(:,1),'-or','LineWidth',2);
hold on;
plot(homa_std.rBf(:,1),env_lambda,'+-b','LineWidth',2);
%xlabel('$\alpha$','Interpreter','latex','fontsize',12)
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 6]);
title('H-OMA envelope for the best clusters')
legend('H-OMA without clustering','H-OMA envelope with best clusters','Location','northeast')
grid on
%matlab2tikz('homa_envelope_best_clusters.tex');

figure;
plot(homa_std.alpha,homa_std.max_devices(:,1),'-or','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0119.maxdevices,'+-b','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0218.maxdevices,'-xm','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0317.maxdevices,'-sk','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0416.maxdevices,'-dg','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0515.maxdevices,'color',[0.4940, 0.1840, 0.5560],'marker','^','LineWidth',2);
xlabel('$\alpha$','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
title('H-OMA with clustering procedure')
legend('H-OMA','H-OMA with [1.9 0.1]','H-OMA with [1.8 0.2]','H-OMA with [1.7 0.3]','H-OMA with [1.6 0.4]', 'H-OMA with [1.5 0.5]','Location','Best')
grid on
%matlab2tikz('homa_with_clustering.tex');

figure;
plot(homa_std.alpha,homa_std.rBf(:,1),'-or','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0515.rBf,'+-b','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0416.rBf,'-xm','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0317.rBf,'-sk','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0218.rBf,'-dg','LineWidth',2);
hold on
plot(homa_std.alpha,homa_0119.rBf,'c','LineWidth',2);
xlabel('$\alpha$','Interpreter','latex','fontsize',12)
ylabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
title('H-OMA with MMD, eMBB Rates vs. Alpha')
legend('H-OMA','H-OMA with MMD, F_b = 4','H-OMA with MMD, F_b = 8','H-OMA with MMD, F_b = 12','H-OMA with MMD, F_b = 16','Location','northwest')
grid on