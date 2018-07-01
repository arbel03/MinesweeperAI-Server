function out = Net ()
%run('./DataManipulation/Data.m')
rng('shuffle');
load('SortedData.mat')

net = patternnet(28);
net.trainParam.showWindow = 1;
% No feature normalization in input
net.inputs{1}.processFcns = {};
% No feature normalization in output:
net.outputs{2}.processFcns = {};
net.divideFcn = 'divideind';
net.trainParam.max_fail = 15;

[tr, va, te] = GetIndices(size(P, 2), size(t,1)); 
net.divideParam.trainInd = tr;
net.divideParam.valInd = va;
net.divideParam.testInd = te;


[net, traind] = train(net, P, t);

% Plot net resaults.
hold on
plot (1:length(traind.perf), traind.perf)
plot (1:length(traind.vperf), traind.vperf)
plot (1:length(traind.tperf), traind.tperf)
legend('Train', 'Perform', 'Validate')
data = P(:, te);
targets = t(:,te);

% Pass comunication parameters to server view corresponding files.
csvwrite('Weights1.csv',net.IW{1});
csvwrite('Weights2.csv',net.LW{2});
csvwrite('Biases1.csv',net.b{1});
csvwrite('Biases2.csv',net.b{2});

out = 0
end

function [ NormalizedData ] = FeatureNormalization(InputData, NormalizedIndexes)
%FeatureNormalization This function normalizes data, this function receives
%a vector of indexes it should use for normalizing.
NormalizedPopulation = InputData(:,NormalizedIndexes);
NormalizedMean = mean(NormalizedPopulation');
NormalizedRange = max(NormalizedPopulation') - min(NormalizedPopulation');
NormalizedData = (InputData-NormalizedMean')./NormalizedRange';
end


