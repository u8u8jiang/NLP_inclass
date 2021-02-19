clear all;

for i = 0:5
    ref{i + 1} = load(['features/speaker01/' num2str(i) '_1.wav.txt']);
end

for i = 0:5
    test{i + 1} = load(['features/speaker01/' num2str(i) '_2.wav.txt']);
    gt(i+1) = i+1;
end


for i = 1: length(test)
    for j = 1: length(ref)
        [dist, d, D] = dtw(test{i}', ref{j}');
        dist1(i,j) = dist;
    end
end

[val, ind] = min(dist1');
cfm = confusionmat(gt, ind);
acc = sum(diag(cfm)) / sum(sum(cfm)) * 100



