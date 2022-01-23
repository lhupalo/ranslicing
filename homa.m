clear
clc

%% eMBB

SNR_B_dB = 25;
eb = 0.001;

SNR_B = 10^(SNR_B_dB/10);
GBf_min = SNR_B*log(1/(1-eb)); % SNR mínima para transmissão

GBf_tar = SNR_B/(expint(GBf_min/SNR_B)); % SNR alvo de transmissão

rBf = log2(1 + GBf_tar); % Taxa eMBB ortogonal

%% mMTC
clear all;
clc;

% Inicializa parâmetros da simulação
SNR_M_db = 5; % Coeficiente de canal mMTC em dB
SNR_M = 10^(SNR_M_db/10); 
Rm = 0.04; % Taxa de transmissão mMTC
Em = 0.1; % Requisito de erro para mMTC

nmax = 200; % Número máximo de iterações (inicia em 1 device até quantos suportarem o requisito de erro mMTC)


h = [];
SNR_inst = [];
SRNsum = 0;
for lambda_m = 1:nmax
    
    lambda = poissrnd(lambda_m); % Sorteio do suposto número de devices ativos neste momento
    
    for j = 1:lambda
        h(j,1) = sqrt(0.5)*abs(randn+1i*randn); % Representações de canais Rayleigh para cada device supostamente ativo
        SNR_inst(j,1) = SNR_M*h(j)^2; % Calculo da SNR instantânea vista na BS para cada device
        instSNRsorted = sort(SNR_inst,'descend'); % Ordenação das SNR instantâneas vistas pela BS, da melhor para a pior, para a decodificação
    end
    
    if lambda <= 1 % Condiçao para 1 device ativo apenas (muda um pouco o fluxo, mas nesse caso nunca dá outage)
        
    else
        for k = 1:lambda                                % Loop de decodificação conforme ordem de qualidade das SNR instantâneas de cada device
           SNRsum = sum(instSNRsorted(k+1:lambda,1));   % Soma das SNRs instantâneas dos devices que ainda faltam ser decodificados e que causam interferência
           SINR(k,1) = instSNRsorted(k,1)/(1+SNRsum);   % Cálculo da SINR do device atual que está sendo decodificado
        end
        Error = mean(log2(1+SINR) < Rm);                % 
        EDm = sum(log2(1+SINR) < Rm);
        
        if Error > Em
            lambda_max = lambda;
            break;
        end
    end
end
fprintf('lambda = %d, EDm = %d \n\n',lambda_max,EDm)
