H = [3 0 15;
     0 3 20;
     0 0 1];
P1 = [0 0;1 0;1 1;0 1]';
P2 = H*[P1;[1 1 1 1]];
P2 = P2(1:2,:);

H1 = SolveTranslationScale(P1,P2);