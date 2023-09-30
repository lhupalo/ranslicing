clear all
clc


%% Variando SNR

snr10 = load('./hnoma_setup1/setup1.mat');
snr25 = load('./hnoma_setup2/setup2.mat');

figure;
plot(snr15.setup1(1,:),snr15.setup1(2,:),'-or','LineWidth',2);
hold on
plot(snr25.setup2(1,:),snr25.setup2(2,:),'+-b','LineWidth',2);
hold on
plot(snr35.setup3(1,:),snr35.setup3(2,:),'-sk','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4]);
% title('H-OMA envelope for the best clusters')
legend('\Gamma_B=15 dB','\Gamma_B=25 dB','\Gamma_B=35 dB','Location','northeast')
grid on
matlab2tikz('hnoma_snr_variation.tex');

%% Variando erro


eb102 = load('./hnoma_setup4/setup4.mat');
eb103 = load('./hnoma_setup2/setup2.mat');
eb104 = load('./hnoma_setup6/setup6.mat');
% % 

figure;
plot(eb102.setup4(1,:),eb102.setup4(2,:),'-or','LineWidth',2);
hold on
plot(eb103.setup2(1,:),eb103.setup2(2,:),'+-b','LineWidth',2);
hold on
plot(eb104.setup6(1,:),eb104.setup6(2,:),'-sk','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 4]);
% title('H-OMA envelope for the best clusters')
legend('\epsilon_B=10^{-2}','\epsilon_B=10^{-3}','\epsilon_B=10^{-4}','Location','northeast')
grid on
matlab2tikz('hnoma_error_variation.tex');