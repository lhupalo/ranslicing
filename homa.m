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
niter = 1e3;
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
    
    for g = 1:niter % Roda niter iterações para cada suposto valor de lambda_m
    
        lambda = poissrnd(lambda_m); % Sorteio do suposto número de devices ativos neste momento

        for j = 1:lambda
            h(j,1) = sqrt(0.5)*abs(randn+1i*randn); % Representações de canais Rayleigh para cada device supostamente ativo
            SNR_inst(j,1) = SNR_M*h(j)^2; % Calculo da SNR instantânea vista na BS para cada device
            instSNRsorted = sort(SNR_inst,'descend'); % Ordenação das SNR instantâneas vistas pela BS, da melhor para a pior, para a decodificação
        end
        
        if lambda == 0
            break;
        elseif lambda <= 1 % Condiçao para 1 device ativo apenas (só pra não dar erro, nesse caso nunca dá outage. Não consegui bolar algo diferente disso)
            SINR =  instSNRsorted;
        else
            for k = 1:lambda                                % Loop de decodificação conforme ordem de qualidade das SNR instantâneas de cada device
               SNRsum = sum(instSNRsorted(k+1:lambda,1));   % Soma das SNRs instantâneas dos devices que ainda faltam ser decodificados e que causam interferência
               SINR(k,1) = instSNRsorted(k,1)/(1+SNRsum);   % Cálculo da SINR do device atual que está sendo decodificado
            end
        end
        
        if lambda == 0 % Condição para não dar erro no fluxo de execução
            Error(g) = 0;
            EDm(g) = 0;
        else
            Error(g) = mean(log2(1+SINR) < Rm); % Valor de erro para g-ésima iteração de um mesmo suposto lambda_m
            EDm(g) = sum(log2(1+SINR) < Rm); % Valor de devices em outage para a g-ésima iteração de um mesmo suposto lambda_m
        end
    
    end
    if mean(Error) > Em   % Testa a média do erro de todas as iterações para um suposto lambda_m
        lmax = lambda_m;     % Se o erro exceder o valor do requisito de serviço, salva o lambda_m e a quantidade
        noutage = mean(EDm); % de devices em outage máximas que o canal suporta
        break;
    end % caso negativo, segue o fluxo e para o próximo valor de lambda_m suposto
   
end

max_devices = lmax;
outage_mean = ceil(mean(noutage));

fprintf('lambda = %d, EDm = %d \n\n',max_devices,outage_mean)
