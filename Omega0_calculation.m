data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary back and forth 2.log',[],4);
data.pan = data.pan(1:13600);
data.t = data.t(1:13600);
prediction = PredictW0(data.pan,data.t-data.t(1),0.15,0.999);
wCorrection = data.pan-prediction;
wDiff = data.pan(51:end)-data.pan(1:end-50);
wCorrectionDiff = wCorrection(51:end)-wCorrection(1:end-50);

figure
subplot(2,1,1);
plot(data.t-data.t(1),data.pan,data.t-data.t(1),prediction);
legend('Measured \omega','Estimated \omega_0');
title('Measures omega vs Estimated \omega_0');
grid on
xlabel('t [sec]');
ylabel('\omega, \omega_0 [deg]');

subplot(2,1,2);
plot(data.t-data.t(1),wCorrection);
title('Correction to \omega_0');
grid on
xlabel('t [sec]');
ylabel('\omega-\omega_0 [deg]');

figure
subplot(2,1,1);
plot(data.t(1:end-50)-data.t(1),wDiff,data.t(1:end-50)-data.t(1),wCorrectionDiff);
title('\delta\omega between consecutive images (0.5sec)')
legend('Measured \omega','Correction to \omega_0');
grid on
xlabel('t [sec]');
ylabel('\Delta\omega @0.5sec');

subplot(2,1,2);
plot(data.t(1:end-50)-data.t(1),wDiff-wCorrectionDiff);
title('Error in \Delta\omega');
grid on
xlabel('t [sec]');
ylabel('diff of \Delta\omega @0.5sec');
