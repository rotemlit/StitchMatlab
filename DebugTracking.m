function DebugTracking(im1,im2,p1,p2)
P1 = zeros(length(p1),2);
P2 = zeros(length(p2),2);
for i=1:length(p1)
    P1(i,:) = p1{i};
    P2(i,:) = p2{i};
end

figure;
subplot(1,2,1);
imshow(im1);
hold on
for i=1:size(P1,1)
    plot(P1(i,1),P1(i,2),'.');
    plot([P1(i,1),P2(i,1)],[P1(i,2),P2(i,2)]);
end
subplot(1,2,2);
imshow(im2);
hold on
for i=1:length(p1)
    plot(p2{i}(1),p2{i}(2),'.');
end



