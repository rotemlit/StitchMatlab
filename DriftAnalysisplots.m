close all

i=0;

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary back and forth 2.log',[],4);
%subplot(3,1,2);
plot(data.t(1:13600)-data.t(1),data.pan(1:13600))
title('\omega_0 Arbitrary Run 1 (Back and forth)');

i=i+1;figure(i);
plot(data.t(1:13600)-data.t(1),data.tilt(1:13600),data.t(1:13600)-data.t(1),data.roll(1:13600));
grid on
title('\theta and \phi, Back and forth Run 1');
xlabel('time [sec]');
ylabel('roll [deg]');
legend('\theta (tilt)','\phi (roll)');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary back and forth 3.log',[],4);
%subplot(3,1,3);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary Run 2 (Back and forth)');

i=i+1;figure(i);
plot(data.t-data.t(1),data.tilt,data.t-data.t(1),data.roll);
grid on
title('\theta and \phi, Back and forth Run 2');
xlabel('time [sec]');
ylabel('roll [deg]');
legend('\theta (tilt)','\phi (roll)');

figure;
plot(data.t-data.t(1),DoubleIntegration(data.t,data.a(:,1)'),data.t-data.t(1),DoubleIntegration(data.t,data.a(:,2)'),data.t-data.t(1),DoubleIntegration(data.t,data.a(:,3)'))
legend('x','y','z')

i=i+1;figure(i);
f

figure;
plot(data.t-data.t(1),DoubleIntegration(data.t,data.a(:,1)'),data.t-data.t(1),DoubleIntegration(data.t,data.a(:,2)'),data.t-data.t(1),DoubleIntegration(data.t,data.a(:,3)'))
legenfigud('x','y','z')

i=i+1;figure(i);
plot(data.t(1:end-50)-data.t(1),data.pan(51:end)-data.pan(1:end-50))
grid on
xlabel('t [sec]');
ylabel('Omega Diff @0.5s [deg]');
title('\omega_0 Arbitrary - diff @0.5sec (Back and forth smooth)')


i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary Portrait_still 1.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary, device still portrait Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary Portrait_still 2.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary, device still portrait Run 2');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary landscape still 1.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary, device still landscape Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary landscape still 2.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary, device still landscape Run 2');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary flat still 1.log',[],4);
%subplot(3,1,1);
plot(data.t(1:6600)-data.t(1),data.yaw(1:6600))
title('\omega_0 Arbitrary, device still flat Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary flat still 2.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.yaw)
title('\omega_0 Arbitrary, device still flat Run 2');
i=i+1;figure(i);
plot(data.t-data.t(1),data.tilt,data.t-data.t(1),data.roll);
grid on
title('\theta and \phi, device still flat Run 2');
xlabel('time [sec]');
ylabel('roll [deg]');
legend('\theta (tilt)','\phi (roll)');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary tilt arbitrary still 1.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary, device tilted, still, Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary tilt arbitrary still 2.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary, device tilted, still, Run 2');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XArbitrary tilt arbitrary still 3 long v2.0.log',[],4);
%subplot(3,1,3);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Arbitrary tilt arbitrary Run 3 (long)');

% Corrected RESULTS

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XStabilized portrait still 1.log',[],5);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Device Portrait Still');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XStabilized tilt arbitrary still 5 long v1.8.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Device tilted, still, Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\Xstabilized back and forth 1.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\Xstabilized back and forth 2, one deliberate error near the end.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 2');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\Xstabilized back and forth 3.log',[],4);
%subplot(3,1,1);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 3');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\Xstabilized back and forth 4 magnetFlag.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 4');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\Xstabilized back and forth 5 v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 5');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XStabilized back and forth 6 smooth v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 6 (Back and forth along a smooth track)');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XStabilized back and forth 7 smooth v1.8.log',[],4);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 7 (Back and forth along a smooth track)');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XStabilized back and forth 9 smooth location 2 v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 9 (Back and forth along a smooth track, location 2)');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\Xstabilized back and forth 8 v1.8.log',[],4);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized Run 8');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XStabilized move between 2 modes v1.8.log',[],4);
%subplot(3,1,3);
plot(data.t-data.t(1),data.pan)
title('\omega_0 Stabilized move between 2 modes');

% NORTH RESULTS

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XNorth tilt arbitrary still 1 v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 relative to north, device tilted, still, Run 1');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XNorth tilt arbitrary still 2 v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 relative to north, device tilted, still, Run 2');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XNorth back and forth smooth 1 v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 relative to north, back and forth, smooth');

i=i+1;figure(i);
data = LoadData('Gyro and Accelerometer\omega tests\XNorth back and forth 2 v2.1.log',[],5);
plot(data.t-data.t(1),data.pan)
title('\omega_0 relative to north, back and forth, smooth');

for j=1:i
    figure(j)
    xlabel('t [sec]');
    ylabel('Omega [deg]');
    grid on;
end

data = LoadData('Gyro and Accelerometer\test\XArbitrary v2.2.log',[],5);
