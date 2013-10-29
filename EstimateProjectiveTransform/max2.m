function [Res, X, Y] = max2(A)
Res = max(max(A));
[Y X] = find(A == Res);