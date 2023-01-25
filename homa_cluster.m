clear all;
clc

alpha = linspace(0,0.99,11);
rBf = zeros(length(alpha));
max_devices = zeros(length(alpha));
outage_mean = zeros(length(alpha));

% Fazer com: 
% Gama_B {15}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04
% Gama_B {25}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04 OK, JÁ TEM!
% Gama_B {35}, eb = 10e-3, em = 10e-1, Gama_M = 5, rm = 0.04

% Gama_B {25}, eb {10e-2}, Gama_M = 5, rm = 0.04
% Gama_B {25}, eb {10e-3}, Gama_M = 5, rm = 0.04 OK, JÁ TEM!
% Gama_B {25}, eb {10e-4}, Gama_M = 5, rm = 0.04


%% Simulation Parameters
SNR_B_dB = 15;            % Average of SNR of eMBB devices in dB
SNR_B = 10^(SNR_B_dB/10);
eb = 0.001;               % Maximum error accepted for eMBB service
SNR_M_db = 5;             % Average SNR of mMTC devices in dB
SNR_M = 10^(SNR_M_db/10); 
Rm = 0.04;                % Rate for mMTC devices. Fixed to a certain value (in bits/s/Hz)
Em = 0.1;                 % Maximum error accepted for mMTC service
nmax = 300;               % Number of max devices, i.e. start testing 1 device and go to the max of 200 trying to access the BS at the same time
niter = 1e3;              % Number of iterations each time that a certain number of devices is active simultaneously

for main = 1:length(alpha)  

    %% eMBB - Enhanced Mobile BroadBand 

    GBf_min = SNR_B*log(1/(1-eb)); % Minimum value of SNR that allow the device to transmit
    GBf_tar = SNR_B/(expint(GBf_min/SNR_B)); % Target value of SNR
    rBf_orth = log2(1 + GBf_tar); % Maximum eMBB rate for Orthogonal Access
    rBf(main) = alpha(main)*rBf_orth;


    lmax = [];
    noutage = [];
    lambda_max = 0;
   
    scaling = [0.5 1.5];

    retry = 0;
    for lambda_m = 1:nmax

        h = [];
        SRNsum = 0;
        SINR = [];
        Error = [];
        EDm = [];
        SNR_inst = [];
        SNR_inst_inicio = [];
        
        scaling = [1];
        
        
        Hm_max = raylrnd(1/sqrt(2),nmax,niter);         % Channel coefficients of the mMTC Devices
        Gm_max_inicio = SNR_M*(Hm_max.^2);                   % Channel Gains of the mMTC Devices

        Gm_max = zeros(nmax,niter);

        for linha=1:nmax

            for coluna=1:niter

                index = randi(length(scaling));
                scale_factor = scaling(index);

                Gm_max(linha,coluna) = Gm_max_inicio(linha,coluna)*scale_factor;

            end
        end

        for g = 1:niter % niter iterations for each lambda_m (supposed number of devices mMTC actives at the same time)

            lambda = poissrnd(lambda_m); % The number of active devices simultaneously is Poisson distributed
            
            %{
            for j = 1:lambda
                h(j,1) = sqrt(0.5)*abs(randn+1i*randn);   % One Rayleigh fading channel for each device
                SNR_inst_inicio(j,1) = SNR_M*h(j)^2;             % Instantaneous SNR seen at the BS for each device
            end
            
            for linha=1:lambda

                index = randi(length(scaling));
                scale_factor = scaling(index);

                SNR_inst(linha,1) = SNR_inst_inicio(linha,1)*scale_factor;
            end
            %}
            %SNR_inst = Gm_max(1:lambda,g);
            instSNRsorted = sort(SNR_inst,'descend'); % Descending instantaneous SNRs seen at the BS to decode properly

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
            
            if lambda_m < 30
                fprintf("Lambda equal %d, retrying \n", lambda_m)
                retry = retry + 1;
                if retry > 5
                    break;
                end
            end
        end % Otherwise, increment lambda_m and test the error rate

    end

    max_devices(main) = ceil(mean(lmax));
    outage_mean(main) = ceil(mean(noutage));

    fprintf('Iteração %d: ',main)
    fprintf('rBf = %f, lambda = %d, EDm = %d, alpha = %f \n',rBf(main),max_devices(main),outage_mean(main),alpha(main))

end

%save('homa_std.mat','rBf','max_devices')

%%
figure;
plot(rBf,max_devices,'r','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda_M$ [number of active devices]','Interpreter','latex','fontsize',12)
title('H-OMA, eMBB and mMTC sharing')
grid on