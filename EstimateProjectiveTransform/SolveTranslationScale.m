function H = SolveTranslationScale(P1,P2)
separateXY = false;
if (~separateXY)
    M = [P1(:) repmat(eye(2),size(P1,2),1)];
    b = P2(:);
    [U,S,V] = svd(M);
    S(S~=0)=1./S(S~=0);
    A = V*S'*U';
    C = A*b;
    
    s = C(1);
    a = C(2);
    b = C(3);
else
    
    M = [P1(2,:)' ones(size(P1,2),1)];
    b = P2(2,:)';
    [U,S,V] = svd(M);
    S(S~=0)=1./S(S~=0);
    A = V*S'*U';
    C = A*b;
    s = C(1);
    b = C(2);
    
    a = mean(P2(1,:)-s*P1(1,:));
end

H = [s 0 a;
     0 s b;
     0 0 1];
