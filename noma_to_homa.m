clear all
close all
clc

tic

% Fazer com: 
% Gama_B {15}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04 OK, JÁ TEM!
% Gama_B {25}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04 OK, JÁ TEM!
% Gama_B {35}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04 OK, JÁ TEM!

% Gama_B {25}, eb {10e-2}, Gama_M = 5, rm = 0.04 OK, JÁ TEM!
% Gama_B {25}, eb {10e-3}, Gama_M = 5, rm = 0.04 OK, JÁ TEM!
% Gama_B {25}, eb {10e-4}, Gama_M = 5, rm = 0.04 OK, JÁ TEM!


%% Parameters
N = 1000;                          % Number of Monte Carlo runs
SNR_M_dB = 5;                     % Average received SNR of the mMTC devices [dB]
SNR_M = 10^(SNR_M_dB/10);         % Average received SNR of the mMTC devices
SNR_B_dB = 25;                    % Average received SNR of the eMBB devices [dB]
SNR_B = 10^(SNR_B_dB/10);         % Average received SNR of the eMBB devices
Em = 1e-1;                        % Reliability requirement for mMTC
Eb = 1e-4;                        % Reliability requirement for eMBB
rm = 0.04;                        % Data rate of the mMTC devices [bits/s/Hz]
Am_max = 300;                     % Maximum number of mMTC devices

alpha = linspace(0,0.99,11);
rBf = zeros(1,length(alpha));

%% Channel realizations
Hm_max = raylrnd(1/sqrt(2),Am_max,N);         % Channel coefficients of the mMTC Devices
Gm_max_inicio = SNR_M*(Hm_max.^2);                   % Channel Gains of the mMTC Devices

Gm_max = zeros(Am_max,N);

%scaling = 1;
%scaling = [1];
scaling = [0.5 1.5];

for linha=1:Am_max
    
    for coluna=1:N

        index = randi(length(scaling));
        scale_factor = scaling(index);
        
        Gm_max(linha,coluna) = Gm_max_inicio(linha,coluna)*scale_factor;
        
    end
end


Hb = raylrnd(1/sqrt(2),1,N);                  % Channel coefficients of the eMBB Device
Gb = SNR_B*Hb.^2;                             % Channel Gain of the eMBB Device

%% Monte Carlo simulations

Lambda_m = zeros(1,length(alpha));
for x=1:length(alpha)

    
    GBf_min = SNR_B*log(1/(1-Eb)); % Minimum value of SNR that allow the device to transmit
    Gb_tar = SNR_B/(expint(GBf_min/SNR_B)); % Target value of SNR
    rBf_orth = log2(1 + Gb_tar); % Maximum eMBB rate for Orthogonal Access
    rBf(x) = alpha(x)*rBf_orth;
    
    for Am_it = 1:Am_max % Number of active mMTC devices
      
        
        Db=zeros(1,N);
        Dm=zeros(1,N);
        count1=0;
        count2=0;
        Am_aux = zeros(1,N);
        for j=1:N   % eMBB device is active
            Am = poissrnd(Am_it);
            while Am == 0 
                Am = poissrnd(Am_it);
            end 
            Am_aux(j) = Am_it;
            Gm = sort(Gm_max(1:Am,:),'descend');

            count1=count1+1;

            for m0=1:Am

                if Am == 1
                    Sigma_m=Gm(m0,j);
                else
                    Sigma_m=Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));         % SINR - mMTC Device
                end
                
                if log2(1+Sigma_m) < (rm/(1-alpha(x)))
                    Dm(j) = Dm(j) + 1;          % Number of mMTC devices in outage
                    %fprintf('64 - Decodificou primeiro mMTC com Am = %d, Am_it = %d \n',Am,Am_it)
                end
   
            end


            %fprintf('Mean(Am_aux) = %f \n',Am_aux)
        end
        %fprintf('Mean(Am_aux) = %f \n',Am_aux);
        Pr_Em = mean(Dm)/mean(Am_aux);  % Error Probability - mMTC Devices            

        %fprintf('Am_it = %d, Am = %d, mean(Dm) = %f, Pr_Em = %f \n',Am_it,Am,mean(Dm),Pr_Em);
        %fprintf('********************************** \n')
        if Pr_Em > Em
            Lambda_m(x) = Am_it - 1;
            break;
        end
    end
fprintf('Iteração %d \t',x);
fprintf('Lambda = %d \n',Lambda_m(x));    
end

maxdevices = Lambda_m;
%save('Results_1_Non.mat','rBf','maxdevices')
%%
figure
plot(rBf,maxdevices,'-+b','LineWidth',2)
%xlim([0 5.5])
%ylim([0 105])
xlabel('r_b')
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
legend('[1.9 0.1]')
title('H-NOMA, eMBB and mMTC sharing')
grid on

toc