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
Am = 150; % Numero de devices mMTC
SNR_M = 5; % Coeficiente de canal mMTC
Rm = 0.04; % Taxa de transmissão mMTC
Em = 0.1; % Requisito de erro para mMTC

iter = 10e3;

% Inicializa variaveis
n_outage = [];


for i = 1:iter

    H = sqrt(10^(SNR_M/10))*((randn(Am,1))+1i*randn(Am,1))/sqrt(2); % Gera vetor H de canais para cada usuário mMTC
    %H = normrnd(0,sqrt(Gamma_M),Am)+i*normrnd(0,sqrt(Gamma_M),Am);
    H_index = [1:1:Am];
    G = abs(H).^2;
    
    
    ok = 0;
    Dm = 0;
    for j = 1:Am

        G_sorted = sort(G,'descend');

        Gsum = sum(G_sorted(j+1:Am,1));
        SINR = G_sorted(j,1)/(1+Gsum);
        
        if log2(1 + SINR) <= Rm
            ok = ok + 1;
        else
            Dm = Am - ok;
            break;
        end
        
    end
    
end
