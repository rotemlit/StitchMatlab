function res = UnHomog(p)
assert(size(p,1)==3,'p height must be 3');
res = zeros(2,size(p,2));
res(1,:) = p(1,:)./p(3,:);
res(2,:) = p(2,:)./p(3,:);