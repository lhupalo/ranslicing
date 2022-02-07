clear all;
clc

rBf = [];
max_devices = [];
outage_mean = [];

%% eMBB

SNR_B_dB = 25;  % Average of SNR in dB
eb = 0.001;     % Maximum error accepted for eMBB service

SNR_B = 10^(SNR_B_dB/10);
GBf_min = SNR_B*log(1/(1-eb)); % Minimum value of SNR that allow the device to transmit

GBf_tar_max = SNR_B/(expint(GBf_min/SNR_B)); % Target value of SNR
GBf_tar = linspace(0,GBf_tar_max,11);

% Simulation parameters
SNR_M_db = 5; % Average SNR for mMTC in dB
SNR_M = 10^(SNR_M_db/10); 
Rm = 0.04; % Rate for mMTC devices. Fixed to a certain value
Em = 0.1;  % Maximum error accepted for mMTC service
Eb = 10e-3;

nmax = 200;  % Number of max iterations, i.e. start testing 1 device and go to the max of 200 trying to access the BS at the same time
niter = 1; % Number of iterations each time that a certain number of devices is active simultaneously

for main = 1:length(GBf_tar)


rBf(main) = log2(1 + GBf_tar(main));

lmax = [];
noutage = [];
lambda_max = [];

for lambda_m = 1:nmax
    
    h = [];
    SNR_inst = [];
    SRNsum = 0;
    SINR = [];
    Error = [];
    EDm = [];
    EDm = [];
    EDb = [];
    EDm_it = [];
    EDb_it = [];
    
    for g = 1:niter % niter iterations for each lambda_m (supposed number of devices mMTC actives at the same time)
    
        lambda = poissrnd(lambda_m); % The number of active devices simultaneously is Poisson distributed

        for j = 1:lambda
            h(j,1) = sqrt(0.5)*abs(randn+1i*randn);   % One Rayleigh fading channel for each device
            SNR_inst(j,1) = SNR_M*h(j)^2;             % Instantaneous SNR seen at the BS for each device
            instSNRsorted = sort(SNR_inst,'descend'); % Descending instantaneous SNRs seen at the BS to decode properly
        end
        
        if lambda == 0  % if lambda = 0, there are no devices online
            EDm_it = 0;
            EDb_it = 0;
            break;
        elseif lambda <= 1 % if lambda = 1, there is 1 mmtc device online
            SINR =  instSNRsorted;
            EDm_it = 1; % 1 success decoded
            EDb_it = 0;
        else
            for k = 1:lambda                                % Decode the devices according to the best inst. SNR to the poor inst. SNR. SIC is implicit
               SNRsum = sum(instSNRsorted(k+1:lambda,1));   % 
               SINR(k,1) = instSNRsorted(k,1)/(1+GBf_tar(main)+SNRsum);
               
               % if occurs outage in mmtc, try decode embb user
               
               if log2(1+SINR(k,1)) < Rm
                   
                   SNRsum_embb = sum(instSNRsorted(k:lambda,1));
                   SINR_B = GBf_tar(main)/(1+SNRsum_embb);
                   EDm_it(k) = 0; % outage, dont count as decoded
                   
                   if log2(1+SINR_B) < rBf(main) % if occurs outage to embb user, stop process
                       EDb_it(k) = 0; % outage, dont count as decoded
                       break;
                   else
                       EDb_it(k) = 1; % not in outage, count as decoded
                   end
               else
                   EDm_it(k) = 1; % not in outage, count as decoded
               end
            end
        end
        
        if lambda == 0   
            EDb(g) = 0;
            EDm(g) = 0;
        else
            EDm(g) = sum(EDm_it); % number of mmtc devices decoded of each iteration is the sum of successfully decoded mmtc devices
            EDb(g) = mean(EDb_it); % mean of embb devices decoded (there is only 1 embb device) for each iteration
        end

        if (mean(EDm)/(lambda_m)) >= (1-Em) && mean(EDb) >= (1-eb)
            lmax = [lmax (lambda_m-1)];
            embb = mean(EDb);
            mmtc = mean(EDm);
            break;
        end
   
end
    end
end


max_devices(main) = ceil(mean(lmax));
outage_mean(main) = ceil(mean(noutage));

