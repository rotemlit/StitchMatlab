function params = GenerateParams_2()
params.NumSubWindowsPerAxis = 3;
params.NumPointsPerSubWindow = 150;
params.KeyPointsMinThrFactor = 0.01;
params.KeyPointsThrFactor = 0.001;
params.MaxShiftLimit = false;
params.MaxShiftRefPercentile = 0.1;
params.MaxPointsShiftFactor = 1.2;
params.SelectHighestModality = false;
params.RANSAC_MaxIters = 1000; %500
params.RANSAC_NumIters = 100;
params.RANSAC_Size0 = 2; %4
params.RANSAC_GoodRatio = 0.07; %0.3
params.RANSAC_StopRatio = 0.7;
params.RANSAC_MaxValidPointsDist1 = 5;
params.RANSAC_MaxValidPointsDist2 = 3;
params.myeps = 0.01;
params.LK_PyramidDepth = 2;