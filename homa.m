clear
clc

%% eMBB

SNR_B_dB = 25;
eb = 0.001;

SNR_B = 10^(SNR_B_dB/10);
GBf_min = SNR_B*log(1/(1-eb));

GBf_tar = SNR_B/(expint(GBf_min/SNR_B));

rBf = log2(1 + GBf_tar);

%% mMTC

% Inicializa parâmetros da simulação
SNR_M_db = 5; % Coeficiente de canal mMTC em dB
SNR_M = 10^(SNR_M_db/10); 
Rm = 0.04; % Taxa de transmissão mMTC
Em = 0.1; % Requisito de erro para mMTC

nmax = 200;


h = [];
SNR_inst = [];
SRNsum = 0;
for lambda = 1:nmax
    
    for j = 1:lambda
        h(j,1) = sqrt(0.5)*abs(randn+1i*randn);
        SNR_inst(j,1) = SNR_M*h(j)^2;
        instSNRsorted = sort(SNR_inst,'descend');
    end
    
    if lambda <= 1
        SINR = instSNRsorted(lambda,1)/(1+instSNRsorted(lambda,1));
        
        if log2(1 + SINR) < Rm
           break
           lambda_max = lambda;
       end
    else
        for k = 1:lambda
           SNRsum = sum(instSNRsorted(k+1:lambda,1));
           SINR(k,1) = instSNRsorted(k,1)/(1+SNRsum);
        end
        Error = mean(log2(1+SINR) < Rm);
        EDm = sum(log2(1+SINR) < Rm);
        
        if Error > Em
            lambda_max = lambda;
            break;
        end
        
    end
    
end