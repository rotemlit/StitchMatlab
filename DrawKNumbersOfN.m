function drawn = DrawKNumbersOfN(N,K)
% draw K random different number between 1 and N

pool = 1:N;
drawn = zeros(1,K);
for i=1:K
    n = randi(N-i+1,1) + i - 1;
    drawn(i) = pool(n);
    
    %swap indices n and i of pool;
    temp = pool(n);
    pool(n) = pool(i);
    pool(i) = temp;
    clear temp;
end
    
    
    