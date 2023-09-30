clear all
close all
clc

tic
%% Parameters
N = 500;                          % Number of Monte Carlo runs
SNR_M_dB = 5;                     % Average received SNR of the mMTC devices [dB]
SNR_M = 10^(SNR_M_dB/10);         % Average received SNR of the mMTC devices
SNR_B_dB = 20;                    % Average received SNR of the eMBB devices [dB]
SNR_B = 10^(SNR_B_dB/10);         % Average received SNR of the eMBB devices
Em = 1e-1;                        % Reliability requirement for mMTC
Eb = 1e-3;                        % Reliability requirement for eMBB
rm = 0.04;                        % Data rate of the mMTC devices [bits/s/Hz]
Am_max = 200;                     % Maximum number of mMTC devices
rb_HNOMA = 0:0.2:4;               % Data rate of the eMBB devices [bits/s/Hz]
%% eMBB
Gb_min = SNR_B*log(1/(1-Eb));                   % Threshold SNR
Gb_tar_max = SNR_B/expint(Gb_min/SNR_B);        % Target SNR
rb_max = log2(1+Gb_tar_max);                    % Maximum allowed eMBB rate

%% Channel realizations
Hm_max = raylrnd(1/sqrt(2),Am_max,N);         % Channel coefficients of the mMTC Devices
Gm_max_inicio = SNR_M*(Hm_max.^2);                   % Channel Gains of the mMTC Devices
% Gm_max = SNR_M*(Hm_max.^2);                   % Channel Gains of the mMTC Devices

Gm_max = zeros(Am_max,N);

scaling = [1.9 0.1]; % Scaling vector

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
Lambda_m_non=zeros(1,length(rb_HNOMA));
for x=1:length(rb_HNOMA)
    
    Gb_tar_min=0;
    for Am_it = 1:Am_max % Number of active mMTC devices
      
        
        flag=0;
        
        for Gb_tar=Gb_tar_min:0.2:Gb_tar_max
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
                Am_aux(j) = Am;
                Gm = sort(Gm_max(1:Am,:),'descend');
                
                count1=count1+1;
                
                for m0=1:Am
                    
                    if Db(j)==0
                        if Am==1
                            Sigma_m=Gm(m0,j)/(1+Gb_tar);         % SINR - mMTC Device
                        else
                            Sigma_m=Gm(m0,j)/(1+Gb_tar+sum(Gm(m0+1:Am,j)));         % SINR - mMTC Device
                        end
                        if log2(1+Sigma_m)>=rm
                            Dm(j)=m0;          % Number of corrected decoded mMTC devices
                        else
                            Sigma_b=Gb_tar/(1+sum(Gm(m0:Am,j)));                       
                            if log2(1+Sigma_b)>=rb_HNOMA(x)
                                Db(j)=1;
                                count2=count2+1;

                                Sigma_m=Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));   % SINR - mMTC Device
                                if log2(1+Sigma_m)>=rm
                                    Dm(j)=m0;    % Number of corrected decoded mMTC devices
                                else
                                   break; 
                                end

                            else
                                break;
                            end
                        end                            
                    else
                        if Am == 1
                            Sigma_m = Gm(m0,j);
                        else
                            Sigma_m = Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));
                        end
                        if log2(1+Sigma_m) >= rm
                            Dm(j)=m0;
                        else
                            break;
                        end
                    end
                end

                if m0 == Am && Db(j) == 0
                    Sigma_b = Gb_tar;
                    if log2(1+Sigma_b) >= rb_HNOMA(x)
                       Db(j) = 1;
                       count2= count2 + 1;
                    end
                end
                %fprintf('Mean(Am_aux) = %f \n',Am_aux)
            end
            Pr_Em = 1-mean(Dm)/mean(Am_aux);  % Error Probability - mMTC Devices            
            Pr_Eb = 1-count2/count1;
            
            %fprintf('Am_it = %d, Am = %d, mean(Dm) = %f, Pr_Em = %f, Pr_Eb = %f \n',Am_it,Am,mean(Dm),Pr_Em, Pr_Eb);
            %fprintf('********************************** \n')
            if Pr_Em <= Em
                if Pr_Eb <= Eb
                    Lambda_m_non(x) = Am_it;
                    flag = 1;
                    break;
                end
            else
                break;
            end
        end
        if flag == 0
            break
        end
    end
    fprintf('Iteração %d \t',x);
    fprintf('Lambda = %d \n',Lambda_m_non(x));
end

rBf = rb_HNOMA;
maxdevices = Lambda_m_non;
%%
figure
plot(rBf,maxdevices,'-+b','LineWidth',2)
xlabel('r_b')
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
legend('[1.9 0.1]')
title('H-NOMA, eMBB and mMTC sharing')
grid on
toc