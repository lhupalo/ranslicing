clear all;
clc

alpha = linspace(0,0.99,5);
rBf = zeros(length(alpha));
max_devices = zeros(length(alpha));
outage_mean = zeros(length(alpha));

%% Simulation Parameters
SNR_B_dB = 25;            % Average of SNR of eMBB devices in dB
SNR_B = 10^(SNR_B_dB/10);
eb = 0.001;               % Maximum error accepted for eMBB service
SNR_M_db = 5;             % Average SNR of mMTC devices in dB
SNR_M = 10^(SNR_M_db/10); 
Rm = 0.04;                % Rate for mMTC devices. Fixed to a certain value (in bits/s/Hz)
Em = 0.1;                 % Maximum error accepted for mMTC service
nmax = 200;               % Number of max devices, i.e. start testing 1 device and go to the max of 200 trying to access the BS at the same time
niter = 1e3;              % Number of iterations each time that a certain number of devices is active simultaneously
Fb = [4 8 12 16];                   % Number of channels MMD

results_per_fb = [];
for ch = 1:length(Fb)
    
    for main = 1:length(alpha)  

        %% eMBB - Enhanced Mobile BroadBand 
        
        gammaB_aux = (2^(-1/Fb(ch)))*SNR_B;
        GBf_min = -gammaB_aux*log(1-eb^(1/Fb(ch)));
        %GBf_tar = SNR_B/(expint(GBf_min/SNR_B)); % Target value of SNR
        
        tar_den = 0;
        for t = 1:Fb(ch)
            % Denominador da função (12) usando expint:
            %tar_den = ((-1)^(t-1))*(nchoosek(Fb(ch),t)*t)*(expint((t*GBf_min)/(gammaB_aux)));
            
            % Denominador da função (12) usando gammainc:
            %tar_den_aux = ((-1)^(t-1))*nchoosek(Fb(ch),t)*t*(gammainc(0,(t*GBf_min)/(gammaB_aux)));
            tar_den_aux = ((-1)^(t-1))*nchoosek(Fb(ch),t)*t*(expint((t*GBf_min)/(gammaB_aux)));
            tar_den = tar_den + tar_den_aux;
        end
        
        % Fim cálculo SNR alvo (função (12))
        GBf_tar = (gammaB_aux)/tar_den;

        rBf_orth = log2(1 + GBf_tar); % Maximum eMBB rate for Orthogonal Access
        rBf(main) = alpha(main)*rBf_orth;


        lmax = [];
        noutage = [];
        lambda_max = 0;

        for lambda_m = 1:nmax

            h = [];
            SNR_inst = [];
            SRNsum = 0;
            SINR = [];
            Error = [];
            EDm = [];

            for g = 1:niter % niter iterations for each lambda_m (supposed number of devices mMTC actives at the same time)

                lambda = poissrnd(lambda_m); % The number of active devices simultaneously is Poisson distributed

                for j = 1:lambda
                    h(j,1) = sqrt(0.5)*abs(randn+1i*randn);   % One Rayleigh fading channel for each device
                    SNR_inst(j,1) = SNR_M*h(j)^2;             % Instantaneous SNR seen at the BS for each device
                    instSNRsorted = sort(SNR_inst,'descend'); % Descending instantaneous SNRs seen at the BS to decode properly
                end

                if lambda == 0
                    break;
                elseif lambda <= 1
                    SINR =  instSNRsorted;
                else
                    for k = 1:lambda                                % Decode the devices according to the best inst. SNR to the poor inst. SNR. SIC is implicit
                       SNRsum = sum(instSNRsorted(k+1:lambda,1));   % 
                       SINR(k,1) = instSNRsorted(k,1)/(1+SNRsum);   % SINR of the present device (which is being decoded)
                    end
                end

                if lambda == 0   
                    Error(g) = 0;
                    EDm(g) = 0;
                else
                    Error(g) = mean(log2(1+SINR) < (Rm/(1-alpha(main)))); % Error taken on the g-th iteration to a supposed lambda_m
                    EDm(g) = sum(log2(1+SINR) < (Rm/(1-alpha(main))));    % Number of devices in outage on the g-th iteration to a supposed lambda_m
                end

            end
            if mean(Error) > Em      % If this supposed lambda_m had a error rate higher than the requirement of service
                lmax = [lmax (lambda_m-1)];     % we save the number of devices that the channel supports
                noutage = mean(EDm);   
                break;
            end % Otherwise, increment lambda_m and test the error rate
            
        end
        
        
        max_devices(main) = ceil(mean(lmax));
        outage_mean(main) = ceil(mean(noutage));
        
        results_per_fb = [results_per_fb; max_devices(main) rBf(main) alpha(main) Fb(ch)];

        %fprintf('Iteração %d: ',main)
        %fprintf('rBf = %f, lambda = %d, EDm = %d, alpha = %f \n',rBf(main),max_devices(main),outage_mean(main),alpha(main))
    end
    fprintf('Fb = %d, GBf_min = %f, GBf_tar = %f \n',Fb(ch),GBf_min, GBf_tar)
  
end

%%
lambdas_homa_mmd = reshape(results_per_fb(:,1),length(alpha),[]);
rates_homa_mmd = reshape(results_per_fb(:,2),length(alpha),[]);

save('homa_mmd.mat','lambdas_homa_mmd','rates_homa_mmd','alpha');

% figure;
% plot(rBf,max_devices,'r','LineWidth',2);
% xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
% ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
% title('H-OMA, eMBB and mMTC sharing')
% grid on