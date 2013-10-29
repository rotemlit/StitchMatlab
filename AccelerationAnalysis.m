clear;
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary Portrait_still 2.log',[],4);
n0=round(length(data.t)/2);
a = data.a(n0:end,:)*9.81;
t=data.t(n0:end)-data.t(n0);
%t=0:length(t)-1;
%t=t/100;
figure
subplot(3,1,1);
plot(t,DoubleIntegration(t,a(:,1)'));%,t,DoubleIntegration(t,a(:,2)'*9.81),t,DoubleIntegration(t,a(:,3)'*9.81))
%legend('x','y','z');
title('Device portrait still, double integration on raw User Acceleration');
ylabel('translation [m]');
xlabel('time [sec]');
grid on
subplot(3,1,2);
a1Drift = mean(a(1:1000,:));
a1 = a - ones(size(a,1),1)*a1Drift;
plot(t,DoubleIntegration(t,a1(:,1)'));%,t,DoubleIntegration(t,a1(:,2)'*9.81),t,DoubleIntegration(t,a1(:,3)'*9.81))
%legend('x','y','z');
title('Device portrait still, double integration after bias(1) correction');
ylabel('translation [m]');
xlabel('time [sec]');
grid on
subplot(3,1,3);
a2Drift = mean(a(end-1000:end,:));
a2 = a - ones(size(a,1),1)*a2Drift;
% R = data.R(n0:end);
% for i=1:length(R)
%     a2(i,:) = (R{i}*a2(i,:)')';
% end
plot(t,DoubleIntegration(t,a2(:,1)'));%,t,DoubleIntegration(t,a2(:,2)'*9.81),t,DoubleIntegration(t,a2(:,3)'*9.81))
%legend('x','y','z');
title('Device portrait still, double integration after bias(2) correction');
ylabel('translation [m]');
xlabel('time [sec]');
grid on

clear;
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary Portrait_still 2.log',[],4);
a = data.a*9.81;
t = data.t-data.t(1);
%t=0:length(t)-1;
%t=t/100;
figure
subplot(3,1,1);
plot(t,DoubleIntegration(t,a(:,1)'));%,t,DoubleIntegration(t,a(:,2)'*9.81),t,DoubleIntegration(t,a(:,3)'*9.81))
%legend('x','y','z');
title('Device portrait still, double integration on raw User Acceleration');
ylabel('translation [m]');
xlabel('time [sec]');
grid on
subplot(3,1,2);
a1Drift = mean(a(1:1000,:));
a1 = a - ones(size(a,1),1)*a1Drift;
plot(t,DoubleIntegration(t,a1(:,1)'));%,t,DoubleIntegration(t,a1(:,2)'*9.81),t,DoubleIntegration(t,a1(:,3)'*9.81))
%legend('x','y','z');
title('Device portrait still, double integration after bias(1) correction');
ylabel('translation [m]');
xlabel('time [sec]');
grid on
subplot(3,1,3);
a2Drift = mean(a(end-1000:end,:));
a2 = a - ones(size(a,1),1)*a2Drift;
plot(t,DoubleIntegration(t,a2(:,1)'));%,t,DoubleIntegration(t,a2(:,2)'*9.81),t,DoubleIntegration(t,a2(:,3)'*9.81))
%legend('x','y','z');
title('Device portrait still, double integration after bias(2) correction');
ylabel('translation [m]');
xlabel('time [sec]');
grid on

%data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary back and forth 3.log',[],4);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary back and forth smooth v2.0.log',[],4);
a = data.a*9.81;
t=data.t-data.t(1);
%clear data;
figure
% subplot(2,1,1);
% plot(t,DoubleIntegration(t,a(:,1)'));%,t,DoubleIntegration(t,a(:,2)'*9.81),t,DoubleIntegration(t,a(:,3)'*9.81))
% %legend('x','y','z');
% title('Device back and forth, double integration on raw User Acceleration');
% ylabel('translation [m]');
% xlabel('time [sec]');
% grid on
subplot(2,1,1);
%a1Drift = mean(a(1:1000,:));
a1 = a - ones(size(a,1),1)*a1Drift;
for i=1:length(data.R)
    a1(i,:) = (data.R{i}*a1(i,:)')';
end
plot(t,DoubleIntegration(t,a1(:,1)'));%,t,DoubleIntegration(t,a1(:,2)'*9.81),t,DoubleIntegration(t,a1(:,3)'*9.81))
%legend('x','y','z');
title('Device back and forth, double integration on bias (1) corrected User Acceleration');
ylabel('translation [m]');
xlabel('time [sec]');
grid on
subplot(2,1,2);
a2Drift = mean(a(5200:6200,:));
a2 = a - ones(size(a,1),1)*a2Drift;
for i=1:length(data.R)
    a2(i,:) = (data.R{i}*a2(i,:)')';
end
plot(t,DoubleIntegration(t,a2(:,1)'));%,t,DoubleIntegration(t,a2(:,2)'*9.81),t,DoubleIntegration(t,a2(:,3)'*9.81))
%legend('x','y','z');
title('Device back and forth, double integration on bias (2) corrected User Acceleration');
ylabel('translation [m]');
xlabel('time [sec]');
grid on
