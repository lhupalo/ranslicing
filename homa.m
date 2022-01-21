clear
clc

% Inicializa parâmetros da simulação
Am = 150; % Numero de devices mMTC
Gamma_M = 5; % Coeficiente de canal mMTC
Rm = 0.04; % Taxa de transmissão mMTC
Em = 0.1; % Requisito de erro para mMTC

% Numero de iterações/realizações
n_iter = 1;

% Inicializa variaveis
n_outage = [];
num_bits = 1e2;

for w = 1:n_iter
    
H = sqrt(Gamma_M/2)*(randn(Am,1))+1i*randn(Am,1); % Gera vetor H de canais para cada usuário mMTC
%H = normrnd(0,sqrt(Gamma_M),Am)+i*normrnd(0,sqrt(Gamma_M),Am);
H_index = [1:1:Am];
G = abs(H).^2;
[G_sorted, user_id] = sort(G,'descend'); % Ordena do melhor canal para pior e mantém índices

y = [];
x = zeros(Am,num_bits);

for i = 1:Am
    z = complex(randn(1,num_bits),randn(1,num_bits)); % Gera vetor de ruído gaussiano
    x(i,:) = round(rand(1,num_bits)); % Gera vetor de sinal transmitido para cada device mMTC
    y(i,:) = H(i)'*x(i,:) + z; % Sinal recebido
end

Dm = 0; % Numero de devices em outage
ok = 0;
for j = 1:Am
    
    G_sum = sum(G_sorted(j+1:Am,1));
    SINR(j) = G_sorted(j)/(1+G_sum); % Cálculo da SINR pra cada device
    
    
    if log2(1 + SINR(j)) >= Rm % Caso condição aconteça = decodificado normalmente
       ok = ok + 1; 
    else
        Dm = Am - ok; % Caso negativo, outage
        break;
    end
end

n_outage = [n_outage Dm];

end

lambda_m = mean(n_outage)/Em % Média das realizações
