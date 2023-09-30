clear all
clc

% Setup 1) Gama_B {15}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04
% Setup 2) Gama_B {25}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04
% Setup 3) Gama_B {35}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04

% Setup 4) Gama_B {25}, eb {10e-2}, Gama_M = 5, rm = 0.04
% Setup 2) Gama_B {25}, eb {10e-3}, Gama_M = 5, rm = 0.04
% Setup 6) Gama_B {25}, eb {10e-4}, Gama_M = 5, rm = 0.04

%% Variando SNR

snr15 = load('./homa_setup1/setup1.mat');
snr25 = load('./homa_setup2/setup2.mat');
snr35 = load('./homa_setup3/setup3.mat');
% % 

figure;
plot(snr15.setup1(1,:),snr15.setup1(2,:),'-or','LineWidth',2);
hold on
plot(snr25.setup2(1,:),snr25.setup2(2,:),'+-b','LineWidth',2);
hold on
plot(snr35.setup3(1,:),snr35.setup3(2,:),'-sk','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 10]);
% title('H-OMA envelope for the best clusters')
legend('\Gamma_B=15 dB','\Gamma_B=25 dB','\Gamma_B=35 dB','Location','northeast')
grid on
%matlab2tikz('homa_snr_variation.tex');

%% Variando erro


eb102 = load('./homa_setup4/setup4.mat');
eb103 = load('./homa_setup2/setup2.mat');
eb104 = load('./homa_setup6/setup6.mat');
% % 

figure;
plot(eb102.setup4(1,:),eb102.setup4(2,:),'-or','LineWidth',2);
hold on
plot(eb103.setup2(1,:),eb103.setup2(2,:),'+-b','LineWidth',2);
hold on
plot(eb104.setup6(1,:),eb104.setup6(2,:),'-sk','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
xlim([0 7]);
% title('H-OMA envelope for the best clusters')
legend('\epsilon_B=10^{-2}','\epsilon_B=10^{-3}','\epsilon_B=10^{-4}','Location','northeast')
grid on
%matlab2tikz('homa_error_variation.tex');