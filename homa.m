clear
clc

% Inicializa parâmetros da simulação
Am = 150; % Numero de devices mMTC
Gamma_M = 5; % Coeficiente de canal mMTC
Rm = 0.04; % Taxa de transmissão mMTC
Em = 0.1; % Requisito de erro para mMTC

% Inicializa variaveis
n_outage = [];
num_bits = 1e4;

H = sqrt((10^(Gamma_M/10)))*(randn(Am,num_bits))+1i*randn(Am,num_bits); % Gera vetor H de canais para cada usuário mMTC
%H = normrnd(0,sqrt(Gamma_M),Am)+i*normrnd(0,sqrt(Gamma_M),Am);
H_index = [1:1:Am];
G = abs(H).^2;
[G_sorted, user_id] = sort(G,'descend'); % Ordena do melhor canal para pior e mantém índices

y = [];
x = zeros(Am,num_bits);

for i = 1:Am
    z = complex(randn(1,num_bits),randn(1,num_bits)); % Gera vetor de ruído gaussiano
    x(i,:) = round(rand(1,num_bits)); % Gera vetor de sinal transmitido para cada device mMTC
    y(i,:) = H(i,:).*x(i,:) + z; % Sinal recebido
end

n_ok = [];
    for b = 1:num_bits
         
            G_sorted = sort(G(:,b),'descend');
        
            Dm = 0; % Numero de devices em outage
            ok = 0;
            for j = 1:Am
                
                G_sum = sum(G_sorted(j+1:Am,1));
                SINR(j,b) = G_sorted(j)/(1+G_sum); % Para a lista de Am devices, decodificar realização do melhor canal para pior
                
                if log2(1 + SINR(j,b)) >= Rm
                    ok = ok + 1;
                else
                    Dm = Dm + 1;
                end
            end
            n_ok = [n_ok ok];
            n_outage = [n_outage Dm];
    end

lambda_m = ok
