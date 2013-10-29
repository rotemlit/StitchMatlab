function data = LoadData(logFilename, firstImageId, version)
if (exist('version'))
    data = ParseLogFile2(logFilename,version);
else
    data = ParseLogFile2(logFilename);
end
if (~exist('firstImageId') || isempty(firstImageId))
    return;
end
[pathstr, name, ext] = fileparts(logFilename);
id = firstImageId;
i=1;
imgFileName = [pathstr,'\IMG_',num2str(id),'.jpg'];
data.im = {};
data.imTags = {};
while (exist(imgFileName,'file'))
    data.im{i} = imread(imgFileName);
    info = imfinfo(imgFileName);
    if (isfield(info,'ImageDescription'))
        data.imTags{i} = info.ImageDescription;
    end;
    if (size(data.im{i},1) < size(data.im{i},2))
        data.im{i} = imrotate(data.im{i},90);
    end
    i=i+1;
    id=id+1;
    imgFileName = [pathstr,'\IMG_',num2str(id),'.jpg'];
end