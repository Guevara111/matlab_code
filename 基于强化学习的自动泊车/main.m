freeSpotIdx = 7;
map = ParkingLot(freeSpotIdx);

egoInitialPose = [20, 15, 0];

egoTargetPose = createTargetPose(map,freeSpotIdx)

%%
autoParkingValetParams

mdl = 'rlAutoParkingValet';
open_system(mdl)

%%
createMPCForParking


numObservations = 16;
observationInfo = rlNumericSpec([numObservations 1]);
observationInfo.Name = 'observations';

steerMax = pi/4;
discreteSteerAngles = -steerMax : deg2rad(15) : steerMax;
actionInfo = rlFiniteSetSpec(num2cell(discreteSteerAngles));
actionInfo.Name = 'actions';
numActions = numel(actionInfo.Elements);


%%
blk = [mdl '/RL Controller/RL Agent'];
env = rlSimulinkEnv(mdl,blk,observationInfo,actionInfo);

%%
env.ResetFcn = @autoParkingValetResetFcn;


%%
rng(0)
criticNetwork = [
    featureInputLayer(numObservations,'Normalization','none','Name','observations')
    fullyConnectedLayer(128,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(128,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(128,'Name','fc3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(1,'Name','fc4')];

criticOptions = rlRepresentationOptions('LearnRate',1e-3,'GradientThreshold',1);
critic = rlValueRepresentation(criticNetwork,observationInfo,...
    'Observation',{'observations'},criticOptions);


actorNetwork = [
    featureInputLayer(numObservations,'Normalization','none','Name','observations')
    fullyConnectedLayer(128,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(128,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(numActions, 'Name', 'out')
    softmaxLayer('Name','actionProb')];

actorOptions = rlRepresentationOptions('LearnRate',2e-4,'GradientThreshold',1);
actor = rlStochasticActorRepresentation(actorNetwork,observationInfo,actionInfo,...
    'Observation',{'observations'},actorOptions);



agentOpts = rlPPOAgentOptions(...
    'SampleTime',Ts,...
    'ExperienceHorizon',200,...
    'ClipFactor',0.2,... 
    'EntropyLossWeight',0.01,...
    'MiniBatchSize',64,...
    'NumEpoch',3,...
    'AdvantageEstimateMethod',"gae",...
    'GAEFactor',0.95,...
    'DiscountFactor',0.998);
agent = rlPPOAgent(actor,critic,agentOpts);
%%
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',10000,...
    'MaxStepsPerEpisode',200,...
    'ScoreAveragingWindowLength',200,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',80);


%%
   
trainingStats = train(agent,env,trainOpts);


%%
freeSpotIdx =9;  % free spot location
sim(mdl);