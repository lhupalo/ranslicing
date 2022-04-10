%% Reset
clear all
close all
clc

%% Parameters
N=1e2;                          % Number of Monte Carlo runs
Gamma_m_dB=5;                   % Average received SNR of the mMTC devices [dB]
Gamma_m=10^(Gamma_m_dB/10);     % Average received SNR of the mMTC devices
Gamma_B_dB=25;                  % Average received SNR of the eMBB devices [dB]
Gamma_B=10^(Gamma_B_dB/10);     % Average received SNR of the eMBB devices
Em=1e-1;                        % Reliability requirement for mMTC
Eb=1e-3;                        % Reliability requirement for eMBB
rm=0.04;                        % Data rate of the mMTC devices [bits/s/Hz]
Am_max=110;                     % Maximum number of mMTC devices
rb_HNOMA=0:0.1:5;              % Data rate of the eMBB devices [bits/s/Hz]

%% eMBB
Gb_min=Gamma_B*log(1/(1-Eb));                   % Threshold SNR
Gb_tar_max=Gamma_B/expint(Gb_min/Gamma_B);      % Target SNR
rb_max=log2(1+Gb_tar_max);                      % Maximum allowed eMBB rate

%% Channel realizations
Hm_max=raylrnd(1/sqrt(2),Am_max,N);         % Channel coefficients of the mMTC Devices
Gm_max=Gamma_m*(Hm_max.^2);                 % Channel Gains of the mMTC Devices
Hb=raylrnd(1/sqrt(2),1,N);                  % Channel coefficients of the eMBB Device
Gb=Gamma_B*Hb.^2;                           % Channel Gain of the eMBB Device

%% Monte Carlo simulations
Lambda_m_non=zeros(1,length(rb_HNOMA));
parfor x=1:length(rb_HNOMA)
    Gb_tar_min=(2^rb_HNOMA(x))-1;                            % SNR target - eMBB device
    for Am=1:Am_max % Number of active mMTC devices
        
%         Am = poissrnd(Am_it);
%         while Am == 0 
%             Am = poissrnd(Am_it);
%         end
        Gm=Gm_max(1:Am,:);
        if Am~=1
            Gm=sort(Gm,'descend');               % Sort channel gains of the mMTC devices in descending order
        end
        flag=0;
        for Gb_tar=Gb_tar_min:0.25:Gb_tar_max
            Db=zeros(1,N);
            Dm=zeros(1,N);
            count1=0;
            count2=0;
            for j=1:N
%                 if Gb(j)<Gb_min                                                         % If the eMBB device is inactive because of insufficient SNR
%                     for m0=1:Am
%                        Sigma_m=Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));                   % SINR - mMTC device
%                        if log2(1+Sigma_m)>=rm
%                            Dm(j)=m0;                                             % Number of corrected decoded mMTC devices
%                        else
%                            break;
%                        end
%                     end               
%                 else                                                                    % eMBB device is active
                    count1=count1+1;
                    for m0=1:Am
                        if Db(j)==0
                            if Am==1
                                Sigma_m=Gm(m0,j)/(1+Gb_tar);         % SINR - mMTC Device
                            else
                                Sigma_m=Gm(m0,j)/(1+Gb_tar+sum(Gm(m0+1:Am,j)));         % SINR - mMTC Device
                            end
                            if log2(1+Sigma_m)>=rm
                                Dm(j)=m0;                                                        % Number of corrected decoded mMTC devices
                            else
                                Sigma_b=Gb_tar/(1+sum(Gm(m0:Am,j)));                       
                                if log2(1+Sigma_b)>=rb_HNOMA(x)
                                    Db(j)=1;
                                    count2=count2+1;
                                    
                                    Sigma_m=Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));         % SINR - mMTC Device
                                    if log2(1+Sigma_m)>=rm
                                        Dm(j)=m0;                                           % Number of corrected decoded mMTC devices
                                    else
                                       break; 
                                    end
                                    
                                else
                                    break;
                                end
                            end                            
                        else
                            if Am==1
                                Sigma_m=Gm(m0,j);
                            else
                                Sigma_m=Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));         % SINR - mMTC Device
                            end
                            if log2(1+Sigma_m)>=rm
                                Dm(j)=m0;                                             % Number of corrected decoded mMTC devices
                            else
                                break;
                            end
                        end
                    end

                    if m0==Am && Db(j)==0
                        Sigma_b=Gb_tar;
                        if log2(1+Sigma_b)>=rb_HNOMA(x)
                           Db(j)=1;
                           count2=count2+1;
                        end
                    end

%                 end
            end
            Pr_Em=1-mean(Dm)/Am;           % Error Probability - mMTC Devices            
%             Pr_Eb=1-mean(Db);
            Pr_Eb=1-count2/count1;
            if Pr_Em<=Em
                if Pr_Eb<=Eb
                    Lambda_m_non(x)=Am;
                    flag=1;
                    break;
                end
            else
                break;
            end
        end
        if flag==0
            break
        end
    end
end

%% Saving the results
rb_HNOMA_1=rb_HNOMA;
Lambda_m_non_1=Lambda_m_non;
%save('Results_1_Non.mat','rb_HNOMA_1','Lambda_m_non_1')

%% Plotting the curves
figure(1)
    plot(rb_HNOMA_1,Lambda_m_non_1,'LineWidth',1.5)
    xlim([0 5.5])
    ylim([0 105])
    xlabel('r_b')
    xlabel('$r_B$','Interpreter','latex','fontsize',12)
    ylabel('$\lambda_M$','Interpreter','latex','fontsize',12)
    title('$\epsilon_B = 0.001$, $\epsilon_M = 0.1$, $\Gamma_B = 25$ dB, $\Gamma_M = 5$ dB','Interpreter','latex','fontsize',14)
    grid on