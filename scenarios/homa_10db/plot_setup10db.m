clear all;
clc

% Load H-OMA 10db
homa_std_25db = load('./homa_25db/homa_std.mat');
homa_0119_25db = load('./homa_25db/homa_0119.mat');
homa_0218_25db = load('./homa_25db/homa_0218.mat');
homa_0317_25db = load('./homa_25db/homa_0317.mat');
homa_0416_25db = load('./homa_25db/homa_0416.mat');
homa_0515_25db = load('./homa_25db/homa_0515.mat');

env_lambda_25db = zeros(1,length(homa_0515_25db.alpha));
for i = 1:length(homa_0515_25db.alpha)
    lst = [homa_0119_25db.max_devices(i), homa_0218_25db.max_devices(i), homa_0317_25db.max_devices(i), homa_0416_25db.max_devices(i), homa_0515_25db.max_devices(i), homa_std_25db.max_devices(i,1)];
    env_lambda_25db(i) = max(lst);
end

env_lambda_25db(end)=0;
homa_std_25db.max_devices(end,1) = 0;


figure;
plot(homa_std_25db.rBf(:,1),smooth(homa_std_25db.max_devices(:,1)),'r','LineWidth',2);
hold on;
plot(homa_0515_25db.rBf(:,1),smooth(env_lambda_25db),'b','LineWidth',2);
%xlabel('$\alpha$','Interpreter','latex','fontsize',12)
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 6]);
title('H-OMA envelope for the best clusters')
legend('H-OMA without clustering','H-OMA envelope with best clusters','Location','northeast')
grid on
matlab2tikz('homa_envelope_best_clusters.tex');

% setup1 = [homa_0515_25db.rBf; env_lambda_25db];
% save('./homa_10db/setup1.mat','setup1');
