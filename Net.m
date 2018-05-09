run('./DataManipulation/Data.m')
rng('shuffle');

net = patternnet(20);
net.trainParam.showWindow = 0;
% No feature normalization in input
net.inputs{1}.processFcns = {};
% No feature normalization in output:
net.outputs{2}.processFcns = {};
net.divideFcn = 'divideind';

[tr, va, te] = GetIndices(size(P, 2), size(t,1)); 
net.divideParam.trainInd = tr;
net.divideParam.valInd = va;
net.divideParam.testInd = te;

[net, traind] = train(net, P, t);

hold on
plot (1:length(traind.perf), traind.perf)
plot (1:length(traind.vperf), traind.vperf)
plot (1:length(traind.tperf), traind.tperf)
legend('Train', 'Perform', 'Validate')
data = P(:, te);
targets = t(:,te);

o = softmax((net.LW{2} * (tansig((net.IW{1} * data) + net.b{1}))) + net.b{2});

test_ptzatza = [ 0 0 0 1 -1 0 1 1 1 -1 2 2 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1]';
test_no_ptzatza = [-1 -1 1 0 0 2 2 2 1 0 0 1 -1 1 0 0 1 1 1 0 0 0 0 0 0]';

layer_1_resaults = tansig((net.IW{1} * test_no_ptzatza) + net.b{1});
layer_2_resaults = softmax((net.LW{2} * layer_1_resaults) + net.b{2})

