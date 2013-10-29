%fid = fopen('Gyro and Accelerometer\GyroTransform1\20130917143052_report.log');
fid = fopen('Scrap\20130919003647_report.log');
C = textscan(fid, '%s %s %*s %*s %*s %n, %f, %f %*s %*s %f, %f, %f %*s %*s %*s (%f, %f, %f, %f, %f, %f, %f, %f, %f) %*s %*s %*s %*s %*s %*s %f, %f, %f %*s %*s %*s %*s %f, %f, %f %*s %*s %*s %*s %*s %f, %f, %f %*s %*s %*s %*s %*s %*s %f, %f, %f', 'delimiter', ' ');
fclose(fid); %s
clear data;
j=3;
data.roll = C{j}; j=j+1;
data.tilt = C{j}; j=j+1;
data.pan = C{j}; j=j+1;
data.RPY = [C{j},C{j+1},C{j+2}]; j=j+3;
data.R = [C{j},C{j+1},C{j+2}, C{j+3},C{j+4},C{j+5}, C{j+6},C{j+7},C{j+8}]; j=j+9;
data.rotationRate = [C{j},C{j+1},C{j+2}]; j=j+3;
data.gravity = [C{j},C{j+1},C{j+2}]; j=j+3;
data.userAcceleration = [C{j},C{j+1},C{j+2}]; j=j+3;
data.magneticField = [C{j},C{j+1},C{j+2}]; j=j+3;

v=cumsum(data.userAcceleration*0.05)*9.81;
x=cumsum(v*0.05);