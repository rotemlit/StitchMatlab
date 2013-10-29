dataPath = '..\\Data\\';
outputPath = '..\\Output\\';

global sFrameId;

%data = LoadData([dataPath,'Fronto Parallel Test\20131017_095723_986.log'],6341,5);
%data = LoadData([dataPath,'Trax Shelves - Scenario1\20131006_100835_839.log'],2587,4);
%data = LoadData([dataPath,'Trax Shelves - Scenario2\20131006_100934_870.log'],2613,4);
%data = LoadData([dataPath,'Trax Shelves - Scenario3-Vertical Move\20131006_101047_908.log'],2641,4);
%data = LoadData([dataPath,'Trax Shelves - Scenario4 - vertical tilt\20131006_101226_133.log'],2691,4);
data = LoadData([dataPath,'Superpharm_1\20131022_173529_167.log'],6550,5);
%data = LoadData([dataPath,'Superpharm_2\20131022_173928_727.log'],6681,5);
%data = LoadData([dataPath,'OmegaCorrection\20131023_154710_877.log'],6816,5);

% randSeed=rng('shuffle');
% save('randSeed1.mat','randSeed');
load randSeed1.mat;
rng(randSeed);

frameRange = 1:60;%length(data.im);

global sParams;
sParams = GetParamsV1();

s = size(data.im{1});
stitch = zeros(s(1)*2,s(2)*10,3,'uint8');

anglesPreprocessor = AnglesPreprocessor(sParams.thetaLPF_Beta,sParams.phiLPF_Beta,sParams.omegaDriftBeta);

ind = data.images.beginI(1);
ang1 = AngleSet(data.tilt(ind),data.roll(ind),data.pan(ind));
omega0 = ang1.omega;
initialOmega = omega0;

imAligned = cell(0);
lastInd = data.images.beginI(frameRange(1))-1;
firstI = lastInd+1;
omegas=zeros(1,length(data.pan));
hCurr2Stitch = eye(3);
prevOffsetDone = [0;0];
disp (['Processing frames ',num2str(frameRange(1)),' to ',num2str(frameRange(end)),',']);
hCurr2StitchDebug = zeros(3,3,length(frameRange));
%filteredTheta = zeros(1,length(data.pan));
%filteredPhi = zeros(1,length(data.pan));
%filteredOmega = zeros(1,length(data.pan));
for frameId = frameRange % main loop
    sFrameId = frameId; % for debugging
    disp(['Frame ',num2str(frameId)]);
    ind = data.images.beginI(frameId);
    for i=lastInd+1:ind
        [angles,omega0] = anglesPreprocessor.Process(0.01,AngleSet(data.tilt(i),data.roll(i),data.pan(i)));
        %filteredTheta(i) = angles.theta;
        %filteredPhi(i)   = angles.phi;
        %filteredOmega(i) = angles.omega;
        omegas(i) = omega0;
        lastI = i;
    end
    ang1 = AngleSet(data.tilt(ind),data.roll(ind),data.pan(ind));
    
    %omega0 = initialOmega;
    
    data.im{frameId} = Add1ToRedChannel(data.im{frameId});
    
    imAligned{frameId} = data.im{frameId};
    [imAligned{frameId},offsetDone] = CorrectImageToFrontoParallel(data.im{frameId},ang1,omega0);
    imwrite(imAligned{frameId},num2str(sFrameId,[outputPath,'imOut_%04d.jpg']));
    if (frameId ~= frameRange(1))
        hPrev2Curr = MatchPrev2Curr(imAligned{frameId-1},prevOffsetDone,imAligned{frameId},offsetDone);
        transFail = isempty(hPrev2Curr); % meaning no solution was found
        if (transFail)
            hPrev2Curr = TranslationHomography([size(imAligned{frameId},2)+2,0]);
        end
        hCurr2Stitch = hPrev2Stitch * inv(hPrev2Curr);
        hCurr2StitchDebug(:,:,frameId-frameRange(1)+1) = hCurr2Stitch;
    end
    onlyCenterStrip = frameId > frameRange(1) && ~transFail;
    stitch = AddImageToStitch(stitch,imAligned{frameId},hCurr2Stitch,onlyCenterStrip);
    imwrite(stitch,num2str(sFrameId,[outputPath,'stitch_%04d.jpg']));
    
    lastInd = ind;
    hPrev2Stitch = hCurr2Stitch;
    prevOffsetDone = offsetDone;
end

% if (false)
%     range = firstI:lastI;
%     plot(data.t(range)-data.t(range(1)),data.pan(range),data.t(range)-data.t(range(1)),omegas(range))
%     plot(data.t(range)-data.t(range(1)),data.tilt(range),data.t(range)-data.t(range(1)),filteredTheta(range))
%     plot(data.t(range)-data.t(range(1)),data.roll(range),data.t(range)-data.t(range(1)),filteredPhi(range))
% end
