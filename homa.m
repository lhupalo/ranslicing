clear
clc

Am = 150;
Gamma_M = 5;
Rm = 0.04;
Em = 0.1;

n_iter = 1;

n_outage = [];
num_bits = 1e2;

for w = 1:n_iter
    
H = sqrt(Gamma_M/2)*(randn(Am,1))+1i*randn(Am,1);
%H = normrnd(0,sqrt(Gamma_M),Am)+i*normrnd(0,sqrt(Gamma_M),Am);
H_index = [1:1:Am];
G = abs(H).^2;
[G_sorted, user_id] = sort(G,'descend');

y = [];
x = zeros(Am,num_bits);

for i = 1:Am
    z = complex(randn(1,num_bits),randn(1,num_bits));
    x(i,:) = round(rand(1,num_bits));
    y(i,:) = H(i)'*x(i,:) + z;
end

Dm = 0;
ok = 0;
for j = 1:Am
    
    G_sum = sum(G_sorted(j+1:Am,1));
    SINR(j) = G_sorted(j)/(1+G_sum);
    
    
    if log2(1 + SINR(j)) >= Rm
       ok = ok + 1; 
    else
        Dm = Am - ok;
        break;
    end
end

n_outage = [n_outage Dm];

end

lambda_m = mean(n_outage)/Em