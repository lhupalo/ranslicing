clear all
close all
clc

tic
%% Parameters
N = 1e2;                          % Número de iterações Monte Carlo
SNR_M_dB = 5;                     % SNR média dos dispositivos mMTC [dB]
SNR_M = 10^(SNR_M_dB/10);         % SNR média dos dispositivos mMTC
SNR_B_dB = 25;                    % SNR média dos dispositivos eMBB [dB]
SNR_B = 10^(SNR_B_dB/10);         % SNR média dos dispositivos mMTC
Em = 1e-1;                        % Requisito de erro mMTC
Eb = 1e-3;                        % Requisito de erro eMBB
rm = 0.04;                        % Taxa de dados para mMTC [bits/s/Hz]
Am_max = 200;                     % Número máximo de dispositivos mMTC a serem testados
rb_HNOMA = 0:0.2:5;               % Taxa dos dispositivos eMBB [bits/s/Hz]
rb_aux = zeros(length(rb_HNOMA));
Fb = [4 8 12 16];                   % Número de canais MMD
%Fb = 10;
results_per_fb = [];

% Neste for loop serão destados os valores distintos de canais MMD
for ch = 1:length(Fb)
    %% eMBB
    Gb_min = -(2^(-1/Fb(ch))*SNR_B)*log(1-Eb^(1/Fb(ch)));    % Threshold SNR
    Gb_tar_max = SNR_B/expint(Gb_min/SNR_B);                 % SNR alvo
    rb_max = log2(1+Gb_tar_max);                             % Máxima taxa eMBB permitida

    %% Realizações de canal
    Hm_max = raylrnd(1/sqrt(2),Am_max,N);         % Coeficientes de canal mMTC
    Gm_max = SNR_M*(Hm_max.^2);                   % Ganhos dispositivos mMTC
    Hb = raylrnd(1/sqrt(2),1,N);                  % Coeficientes de canal eMBB
    Gb = SNR_B*Hb.^2;                             % Ganhos dispositivos eMBB

    %% Iterações

    Lambda_m_non=zeros(1,length(rb_HNOMA));
    lmbdanon=zeros(1,length(rb_HNOMA));
    
    % Busca pelos valores pré definidos das taxas rB.
    % Esse vetor das taxas é inicializado com valores espaçados igualmente
    % e para cada valor a ideia é obter qual o lambda suportado pelo
    % sistema (quantidade de dispositivos mMTC online ao mesmo tempo)
    for x=1:length(rb_HNOMA)
        
        % Início cálculos MMD
        
        %Gb_tar_min=(2^rb_HNOMA(x))-1; % Pelo teorema de Shannon, essa é a SNR mínima necessária para atingir a taxa que está sendo testada
        Gb_tar_min=0;
        gammaB_aux = (2^(-1/Fb(ch)))*SNR_B;

        tar_den = 0;
        for t = 1:Fb(ch)
            % Denominador da equação (12) (dissertação Elço) usando gammainc
            tar_den_aux = ((-1)^(t-1))*nchoosek(Fb(ch),t)*t*(expint((t*Gb_min)/(gammaB_aux)));
            tar_den = tar_den + tar_den_aux;
        end

        % Fim cálculo SNR alvo com MMD (equação (12)).
        % Essa é a SNR alvo para transmissão do serviço eMBB
        GBf_tar = (gammaB_aux)/tar_den;

        % Neste for loop, vai sendo testado cada valor de lambda iniciando
        % do 1. Se o valor é suportado sem os requisitos de erro serem
        % descumpridos, é incrementado um dispositivo. No início, quando a
        % taxa rB é próxima a 0 e os recursos são usados quase que
        % inteiramente pelo serviço mMTC, o valor de lambda está entre 90 e
        % 85.
        for Am_it = 1:Am_max

            % Reseta flag para novo teste de Am
            flag = 0;
            
            % Como a ideia é conseguir transmitir na menor SNR possível
            % (por isso o uso do MMD, em que consegue-se diminuir esse
            % valor por meio dessa diversidade na frequência), começa-se
            % testando a SNR mínima teórica para a taxa rB relacionada até
            % chegar na SNR alvo com uso do MMD.
            for Gb_tar = Gb_tar_min:0.2:GBf_tar
                
                Db = zeros(1,N);
                Dm = zeros(1,N);
                count1 = 0; % Contagem total de iterações Monte Carlo
                count2 = 0; % Contagem de dispositivos eMBB decodificados com sucesso
                Am_aux = zeros(1,N);
                
                for j=1:N
                    
                    % Modelagem Poisson para estimação de chegada dos
                    % dispositivos mMTC
                    Am = poissrnd(Am_it);
                    while Am == 0 
                        Am = poissrnd(Am_it);
                    end 
                    Am_aux(j) = Am;
                    
                    % Ordenação dos dispositivos mMTC pelo ganho em ordem
                    % decrescente
                    Gm = sort(Gm_max(1:Am,:),'descend');
                    
                    % Cada iteração Monte Carlo adiciona uma unidade em
                    % count1.
                    count1 = count1 + 1;
                    
                    % Para cada dispositivo mMTC, realiza os procedimentos
                    % de decodificação
                    for m0 = 1:Am
                        
                        % Se na iteração anterior o dispositivo eMBB NÃO
                        % foi decodificado, entra neste if
                        if Db(j) == 0
                            
                            % Faz o cálculo dos ganhos e interferências
                            % entre os dispositivos mMTC
                            if Am == 1
                                Sigma_m = Gm(m0,j)/(1+Gb_tar);
                            else
                                Sigma_m = Gm(m0,j)/(1+Gb_tar+sum(Gm(m0+1:Am,j)));
                            end
                            
                            % Inicia decodificação do mMTC
                            if log2(1+Sigma_m) >= rm
                                
                                % Se decodificar corretamente, atualiza a variavel Dm
                                % com o número de dispositivos mMTC
                                % decodificados com sucesso 
                                Dm(j) = m0;    
                            else
                                % Senão, calcula o ganho do dispositivo
                                % eMBB e sua interferência e tenta
                                % decodificá-lo
                                Sigma_b = Gb_tar/(1+sum(Gm(m0:Am,j)));                       
                                
                                if log2(1+Sigma_b) >= rb_HNOMA(x)
                                    
                                    % Se eMBB decodificado com sucesso,
                                    % atualiza Db e adiciona contagem de
                                    % dispositivo decodificado em count2
                                    Db(j) = 1;
                                    count2 = count2 + 1;
                                    
                                    % Então, calcula o ganho do próximo
                                    % dispositivo mMTC e sua interferência
                                    % e tenta decodificar
                                    Sigma_m = Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));
                                    
                                    if log2(1+Sigma_m)>=rm
                                        
                                        % Se não ocorrer outage, atualiza
                                        % Dm com o número de dispositivos
                                        % mMTC decodificados com sucesso
                                        Dm(j) = m0;
                                    else
                                        % Se ocorrer outage, break
                                       break; 
                                    end

                                else
                                    % Se tiver dado outage na primeira
                                    % decodificação mMTC (linha 122) e
                                    % também outage na tentativa de
                                    % decodificação do próximo dispositivo
                                    % eMBB da fila (linha 134), break.
                                    break;
                                end
                            end                            
                        else
                            % Se na iteração anterior o dispositivo eMBB
                            % tiver sido decodificado, o if entrará aqui.
                            if Am == 1
                                Sigma_m = Gm(m0,j);
                            else
                                Sigma_m = Gm(m0,j)/(1+sum(Gm(m0+1:Am,j)));
                            end
                            
                            % Após calcular o ganho e interferências do dispositivo mMTC, é tentado decodificar 
                            if log2(1+Sigma_m) >= rm
                                % Decodificando com sucesso, atualiza Dm
                                % com o número de dispositivos mMTC online
                                Dm(j) = m0;
                            else
                                % Outage, break
                                break;
                            end
                        end
                    end
                    
                    % Este if aqui vai entrar quando conseguir decodificar
                    % todos os dispositivos mMTC
                    if m0 == Am && Db(j) == 0
                        Sigma_b = Gb_tar;
                        
                        % Tentativa de decodificação eMBB
                        if log2(1+Sigma_b) >= rb_HNOMA(x)
                           Db(j) = 1;
                           count2 = count2 + 1;
                        end
                    end
                end
                
                Pr_Em = 1-mean(Dm)/mean(Am_aux);  % Probabilidade de erro mMTC          
                Pr_Eb = 1-count2/count1;          % Probabilidade de erro eMBB
                
                if Pr_Em <= Em
                    if Pr_Eb <= Eb
                        
                        % Se as duas condições forem satisfeitas, salva o
                        % número de dispositivos mMTC que conseguiram ficar
                        % online ao mesmo tempo neste for loop e testa para
                        % o próximo valor de Am (for loop linha 69)
                        Lambda_m_non(x) = Am_it;
                        flag = 1;
                        break;
                    end
                else
                    % Se não, break
                    break;
                end
            end
            % Se os requisitos de erro não forem satisfeitos, a flag não
            % vai ser setada em 1 e vai entrar nesse if para dar break
            if flag == 0
                break
            end
        end
        
        % Salva valores do lambda
        lmbdanon(x) = log2(1+Gb_tar);
        fprintf('Iteração %d \t',x);
        fprintf('Lambda = %d \t',Lambda_m_non(x));
        fprintf('GB_tar_min = %f \t',Gb_tar_min);
        fprintf('GBf_tar (outage) = %f \t',Gb_tar);
        fprintf('GBf_tar (caculadoMMD) = %f \t',GBf_tar);
        fprintf('Rb_f = %f \n',log2(1+Gb_tar));
    end

    rBf = rb_HNOMA;
    maxdevices = Lambda_m_non;
    %save('Results_1_Non.mat','rBf','maxdevices')
    results_per_fb = [results_per_fb; maxdevices rBf Fb(ch)];
end

%% Só um plot


fb4 = reshape(results_per_fb(1,1:2*length(rb_HNOMA)),length(rb_HNOMA),2);
fb8 = reshape(results_per_fb(2,1:2*length(rb_HNOMA)),length(rb_HNOMA),2);
fb12 = reshape(results_per_fb(3,1:2*length(rb_HNOMA)),length(rb_HNOMA),2);
fb16 = reshape(results_per_fb(4,1:2*length(rb_HNOMA)),length(rb_HNOMA),2);

figure;
plot(fb4(:,2),fb4(:,1),'-or','LineWidth',2);
hold on
plot(fb4(:,2),fb8(:,1),'+-b','LineWidth',2);
hold on
plot(fb4(:,2),fb12(:,1),'-xm','LineWidth',2);
hold on
plot(fb4(:,2),fb16(:,1),'-sk','LineWidth',2);
xlabel('$r_B$ [bits/s/Hz]','Interpreter','latex','fontsize',12)
ylabel('$\lambda$','Interpreter','latex','fontsize',12)
title('H-OMA with MMD, eMBB Rates vs. R_b')
legend('H-NOMA with MMD, F_b = 4','H-NOMA with MMD, F_b = 8','H-NOMA with MMD, F_b = 12','H-NOMA with MMD, F_b = 16','Location','northeast')
grid on

toc