function data = ParseLogFileV4(filename,version)
data = {};
data.R = {};

fid = fopen(filename);
tline = fgetl(fid);
iLine = 1;
i=1;
t0 = 0;

if (nargin < 2)
    version = 5;
end
while ischar(tline)
    n1 = strfind(tline,'Attitude');
    sensorsEntry = ~isempty(n1);
    if (sensorsEntry)
        if (version==4)
            [t,pan,tilt,roll,yaw,pitch,roll2,R,a,gyro,gravity,magnet] = ParseLineV4(tline);
        elseif (version==5)
            n2 = strfind(tline,'CMLogItemTimestamp');
            if (~isempty(n2))
                [t,pan,tilt,roll,yaw,pitch,roll2,R,a,gyro,gravity,magnet,MAccuracy,CMLogItemTimeStamp] = ParseLineV5_1(tline);
            else
                [t,pan,tilt,roll,yaw,pitch,roll2,R,a,gyro,gravity,magnet,MAccuracy] = ParseLineV5(tline);
            end
 
        else
            error ('incorrect parsing version');
        end
        if (isempty(t))
            disp(['Bad time stamp on line ',num2str(iLine,'%d'),'!']);
        else
            data.t(i) = t;
            data.pan(i) = pan;
            data.tilt(i) = tilt;
            data.roll(i) = roll;
            data.yaw(i) = yaw;
            data.pitch(i) = pitch;
            data.roll2(i) = roll2;
            data.R{i} = R;
            data.a(i,1:3)=a;
            data.gyro = gyro;
            data.gravity(i,1:3)=gravity;
            data.magnet(i,1:3)=magnet;
            if (version==5)
                data.MAccuracy(i) = MAccuracy;
            end
            if (exist('CMLogItemTimeStamp'))
                data.CMLogItemTimeStamp(i) = CMLogItemTimeStamp;
            end
            i=i+1;
        end
    else
        n2 = strfind(tline,'begin');
        beginFlag = ~isempty(n2);
        endFlag = false;
        if (~beginFlag)
            n2 = strfind(tline,'end');
            endFlag = ~isempty(n2);
            if (~endFlag)
                continue;
            end
        end
        [t,imgTag,imgNum] = ParseImgTagLine(tline);
        if (endFlag)
            imgNum = imgNum - 10000;
        end
        data.images.imgNum(imgNum+1) = imgNum;
        if (beginFlag)
            data.images.beginI(imgNum+1) = i+1;
            data.images.beginTag(imgNum+1) = imgTag;
            data.images.tBegin(imgNum+1) = t;
        else
            data.images.endI(imgNum+1) = i-1;
            data.images.endTag(imgNum+1) = imgTag;
            data.images.tEnd(imgNum+1) = t;
        end
    end
    iLine = iLine + 1;
    tline = fgetl(fid);
end

data.magnetHeading = zeros(1,length(data.t));
for i=1:length(data.t)
    data.magnetHeading(i) = CalcMagneticHeading(data.magnet(i,:),data.gravity(i,:),data.tilt(i),data.roll(i));
end

fclose(fid);

% figure
% plot(data.t-data.t(1),data.roll)
% hold on
% plot(data.images.tBegin-data.t(1),ones(1,length(data.images.tEnd))*2,'*')
% plot(data.images.tEnd-data.t(1),ones(1,length(data.images.tEnd))*2,'o')
end

function [t,pan,tilt,roll,yaw,pitch,roll2,R,a,gyro,gravity,magnet,CMaccuracy] = ParseLineV4(tline)
    data = textscan(tline,'%s %s %s %s %f, %f, %f %s %s %s %f, %f, %f %s %s %s %s (%f, %f, %f, %f, %f, %f, %f, %f, %f) %s %s %s %s %s %s %f, %f, %f %s %s %s %s %f, %f, %f %s %s %s %s %s %f, %f, %f %s %s %s %s %s %s %f, %f, %f');
    %strfind;
    t = data{2};
    timeData = textscan(t{1},'%d:%d:%f');
    t = double(timeData{1}*3600+timeData{2}*60)+timeData{3};
    roll = data{5};
    tilt = data{6};
    pan = data{7};
    roll2 = data{11}*180/pi;
    pitch = data{12}*180/pi;
    yaw = data{13}*180/pi;
    R = [data{18},data{19},data{20};data{21},data{22},data{23};data{24},data{25},data{26}];
    a = [data{48},data{49},data{50}];
    gyro = [data{33},data{34},data{35}];
    gravity = [data{40},data{41},data{42}];
    magnet = [data{57},data{58},data{59}];
end
function [t,pan,tilt,roll,yaw,pitch,roll2,R,a,gyro,gravity,magnet,CMaccuracy] = ParseLineV5(tline)
    data = textscan(tline,'%s %s %s %s %f, %f, %f %s %s %s %f, %f, %f %s %s %s %s (%f, %f, %f, %f, %f, %f, %f, %f, %f) %s %s %s %s %s %f, %f, %f %s %s %s %s %f, %f, %f %s %s %s %s %s %f, %f, %f %s %s %s %s %s %f, %f, %f %s %s %f');
    %strfind;
    t = data{2};
    timeData = textscan(t{1},'%d:%d:%f');
    t = double(timeData{1}*3600+timeData{2}*60)+timeData{3};
    roll = data{5};
    tilt = data{6};
    pan = data{7};
    roll2 = data{11}*180/pi;
    pitch = data{12}*180/pi;
    yaw = data{13}*180/pi;
    R = [data{18},data{19},data{20};data{21},data{22},data{23};data{24},data{25},data{26}];
    gyro = [data{32},data{33},data{34}];
    gravity = [data{39},data{40},data{41}];
    a = [data{47},data{48},data{49}];
    magnet = [data{55},data{56},data{57}];
    CMaccuracy = data{60};
end
function [t,pan,tilt,roll,yaw,pitch,roll2,R,a,gyro,gravity,magnet,CMaccuracy,CMLogItemTimestamp] = ParseLineV5_1(tline)
    data = textscan(tline,'%s %s %s %s %f, %f, %f %s %s %s %f, %f, %f %s %s %s %s (%f, %f, %f, %f, %f, %f, %f, %f, %f) %s %s %s %s %s %f, %f, %f %s %s %s %s %f, %f, %f %s %s %s %s %s %f, %f, %f %s %s %s %s %s %f, %f, %f %s %s %s %f %s %s %s %f');
    %strfind;
    t = data{2};
    timeData = textscan(t{1},'%d:%d:%f');
    t = double(timeData{1}*3600+timeData{2}*60)+timeData{3};
    roll = data{5};
    tilt = data{6};
    pan = data{7};
    roll2 = data{11}*180/pi;
    pitch = data{12}*180/pi;
    yaw = data{13}*180/pi;
    R = [data{18},data{19},data{20};data{21},data{22},data{23};data{24},data{25},data{26}];
    gyro = [data{32},data{33},data{34}];
    gravity = [data{39},data{40},data{41}];
    a = [data{47},data{48},data{49}];
    magnet = [data{55},data{56},data{57}];
    CMaccuracy = data{60};
    CMLogItemTimestamp = data{65};    
end

function [t,imgTag,imgNum] = ParseImgTagLine(line)
    data = textscan(line,'%s %s %s %f %s');
    t = data{2};
    timeData = textscan(t{1},'%d:%d:%f');
    t = double(timeData{1}*3600+timeData{2}*60)+timeData{3};
    imgTag = data{3};
    imgNum = data{4};
end
    
%v4: 2013-9-28 16:06:25.468  Attitude(r,t,p) = 0.917168260476479,  35.625078257870925, -80.074562847912404 | Original(r,p,y) = 0.022333778440952, 0.948842644691467, 1.370087504386902 | RotationMatrix (m11,m12,m13,m21,m22,m23,m31,m32,m33) = (0.181528523564339, 0.983299612998962, -0.013011127710342, -0.570928215980530, 0.116154253482819, 0.812741756439209, 0.800679922103882, -0.140107423067093, 0.582478761672974) | Rotation Rate (x,y,z) = = -0.006457023788244, -0.009490260854363, -0.001872558845207 | Gravity (x,y,z) = 0.013011116534472, -0.812741756439209, -0.582478821277618 | User Acceleration (x,y,z) = -0.001841682707891, -0.000689029286150, -0.005152429919690 | Magnetic Field (x,y,z) = = -314.400909423828125, 74.444686889648438, -591.371276855468750
%v5: %2013-10-09 19:31:18.866  Attitude(r,t,p) = 0.616250829656639, -0.961349339122706, -12.671278155748446 | Original(r,p,y) = 2.571604251861572, 1.550866484642029, -2.350358486175537 | RotationMatrix (m11,m12,m13,m21,m22,m23,m31,m32,m33) = (0.975548624992371, 0.219520539045334, -0.010753855109215, 0.014173567295074, -0.014009139500558, 0.999801456928253, 0.219326287508011, -0.975507318973541, -0.016777986660600) | Rotation Rate (x,y,z) = 0.005148008000106, 0.004694045055658, -0.009407209232450   | Gravity (x,y,z) = 0.010753860697150, -0.999801397323608, 0.016777945682406 | User Acceleration (x,y,z) = -0.001125565264374, 0.006438980810344, -0.003289175452664 | Magnetic Field (x,y,z) = -215.133743286132812, 59.573593139648438, -546.765014648437500 CMMFCAccuracy = 1
%2013-10-03 21:18:19.554  20131003_211819_554 0 begin
%2013-10-03 21:18:19.648  20131003_211819_648 10000 end